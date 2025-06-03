//
//  LLMViewModel.swift
//  Koa Heal
//
//  Created by Husein Hakim on 25/05/25.
//

import Foundation
import MLXLMCommon
import MLXLLM

class LLMViewModel: ObservableObject {
    private(set) var modelContainer: ModelContainer?
    private let modelConfiguration: ModelConfiguration = ModelRegistry.llama3_2_3B_4bit
    @Published var downloadProgress: Progress = Progress()
    @Published var output: String = ""
    @Published var finishedGeneration: Bool = false
    
    func loadModel() async {
        do {
            modelContainer = try await LLMModelFactory.shared.loadContainer(
                configuration: modelConfiguration
            ) { progress in
                Task { @MainActor in
                    self.downloadProgress = progress
                    print("Download progress: \(progress.fractionCompleted)")
                }
            }
        } catch {
            print("error loading model \(error.localizedDescription)")
        }
    }
    
    func generateInput(userInput: String) async {
        do {
            let result = try await modelContainer!.perform { context in
              let prompt = UserInput(prompt: userInput)
              let input = try await context.processor.prepare(input: prompt)
                return try MLXLMCommon.generate(input: input, parameters: .init(), context: context) { tokens in
                    let text = context.tokenizer.decode(tokens: tokens)

                    Task { @MainActor in
                        output = text
                        finishedGeneration = true
                    }

                    return .more
                }
            }
        } catch {
            print("error generating output: \(error.localizedDescription)")
        }
    }
}
