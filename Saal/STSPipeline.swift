//
//  STSPipeline.swift
//  Saal
//
//  Created by Husein Hakim on 02/06/25.
//

import Foundation
import SwiftUI
import MLX

@MainActor
class STSPipeline: ObservableObject {
    let transcriptionModel: WhisperState = WhisperState()
    let llmModel: LLMViewModel = LLMViewModel()
    let ttsModel: KokoroTTSModel = KokoroTTSModel()
    @Published var stsstate: STSState = .idle
    @Published var modelLoading: Bool = true
    private var downloadTask: URLSessionDownloadTask?
    let sttModel = Model(name: "base-q8_0", info: "(78 MiB)", url: "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base-q8_0.bin", filename: "base-q8_0.bin")
    
    init(downloadTask: URLSessionDownloadTask? = nil) {
        self.downloadTask = downloadTask
    }
    
    func loadModels() {
        Task {
            loadSttModel()
            await llmModel.loadModel()
            withAnimation(.easeInOut(duration: 0.8)) {
                modelLoading = false
            }
        }
    }
    
    func startListening() {
        Task {
            stsstate = .listening
            await transcriptionModel.toggleRecord()
        }
    }
    
    func generateResponse() async {
        Task {
            await MainActor.run {
                stsstate = .processing
            }
            await transcriptionModel.toggleRecord()
            
            if await transcriptionModel.finishedTranscription {
                await llmModel.generateInput(userInput: transcriptionModel.transcription)
            }
            
            if llmModel.finishedGeneration {
                await MainActor.run {
                    stsstate = .speaking
                }
                generateAudio(text: llmModel.output)
                await MainActor.run {
                    stsstate = .idle
                }
            }
        }
    }
    
    private func generateAudio(text: String) {
        let t = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let speaker = Speaker(id: 4, name: "af_jessica")
        
        MLX.GPU.set(cacheLimit: 20 * 1024 * 1024)
        ttsModel.say(t, TTSVoice.fromIdentifier(speaker.name) ?? .afHeart, speed: Float(1.2))
    }
    
    private func downloadSttModel() {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: sttModel.fileURL.path) {
            print("Model already exists at \(sttModel.fileURL.path), skipping download.")
            return
        }

        print("Model not found. Downloading from \(sttModel.url)")

        guard let url = URL(string: sttModel.url) else {
            print("Invalid URL.")
            return
        }

        downloadTask = URLSession.shared.downloadTask(with: url) { temporaryURL, response, error in
            if let error = error {
                print("Download error: \(error.localizedDescription)")
                return
            }

            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode),
                  let temporaryURL = temporaryURL else {
                print("Failed to download model.")
                return
            }

            do {
                try fileManager.copyItem(at: temporaryURL, to: self.sttModel.fileURL)
                print("Model saved to \(self.sttModel.fileURL.path)")
            } catch {
                print("Error saving model: \(error.localizedDescription)")
            }
        }

        downloadTask?.resume()
    }
    
    private func loadSttModel() {
        Task {
            downloadSttModel()
            transcriptionModel.loadModel(path: self.sttModel.fileURL)
        }
    }
}

enum STSState {
    case idle
    case listening
    case processing
    case speaking
}
