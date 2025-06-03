# Saal - Open Soure Local STS(Speech-to-Speech) Swift Pipeline

**Saal** is an open-source, local speech-to-speech (STS) processing pipeline built for Swift/iOS developers. It allows you to convert spoken input into spoken output, making it ideal for voice assistants, emotion-aware AI, or real-time voice applications.

---

## 🧩 What Powers Saal?
Saal is created by combining multiple packages to help with an on-device pipeline. It combines the following open-source packages:
1) **[Whisper.cpp](https://github.com/ggerganov/whisper.cpp)** — High-performance ASR (Automatic Speech Recognition) engine based on OpenAI’s Whisper model.
2) **[MLX Swift](https://github.com/ml-explore/mlx-swift and https://github.com/ml-explore/mlx-swift-examples.git)** — A powerful array framework for local ML and LLM inference on Apple silicon.
3) **[MLX Audio](https://github.com/ml-explore/mlx-audio)** — TTS engine using local audio models. Saal uses the **Kokoro** model for speech synthesis.

---

## 🚀 Features
- 🎤 Local speech-to-speech
- 🔒 Completely offline — no API or internet required
- 📱 Native Swift + Xcode project

---

## 🛠️ Getting Started

### 1. Clone the repo

### 2. Sign the app with your developer account 

### 3. Download Kokoro TTS safetensor file from huggingface:
The following link will take you to the hugging face directory of mlx-communit/kokoro: https://huggingface.co/mlx-community/Kokoro-82M-bf16/tree/main
Navigate to files and versions and download 'kokoro-v1_0.safetensors'

### 4. Add the safetensor file to the tts folder inside the STSPipeline folder

### 5. Sign and embed ESpeak.ng and Whsiper frameworks

### 6. You're all set! Run the app and let the models download

---

## Usage
To use this pipeline in your own apps, simply copy the STSPipeline folder and STSViewModel into your app, along with the Whisper and ESpeakNG framework.

Take a look at the STSViewModel to understand how to toggle different states such as listening, thinking, speaking and idle. There is also support for easily adding progress views for when the models are being loded/downloded

---

## 🧑‍💻 Contributing
Pull requests and ideas are welcome! Feel free to open an issue or fork the repo and submit a PR.

---

## 👀 Coming Soon
I plan on improving the STS pipeline by:
- Implementing VAD(Voice ACtivity Detection) to remove the need for switching the microphone on and off and detect when the user stops speaking for a seamless experience
- Add options for devlopers to toggle different: Whisper.cpp models for improved speed, LLM models such as Qwen, gemma, etc with the support of MLX, different Kokoro Voices

📄 License
This project is licensed under the MIT License. See the LICENSE file for details.

---

## 🙌 Acknowledgements
A huge thanks to:
ggerganov for Whisper.cpp
mlx-community for MLX, MLX Audio, and Kokoro

Without these amazing open-source projects Saal would not have been possible!
