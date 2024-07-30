# Dots App

Dots is a mobile application designed to enhance accessibility for both visually impaired and sighted users. The application leverages advanced AI models to offer four key features: Braille Translation, Vision, Read and Translate, and Echo. Each feature provides distinct advantages and meets particular user requirements.

## Features

### 1. Braille Translation
- **User Captures Braille Image**: The user captures an image of braille text.
- **Image Pre-processing**: The image undergoes pre-processing for detection.
- **Braille Detection and Conversion**: Braille is detected and converted to Unicode using YOLO-v8.
- **Text Translation**: The text is translated into the desired language using GPT-4.
- **Auditory Output**: The translated text is converted into auditory output for the user.

### 2. Vision
- **User Shakes Device**: The user shakes the device to capture an image.
- **Image Capturing**: The captured image is sent to the LVLM (GPT-4V).
- **Image Description Generation**: An image description is generated.
- **Auditory Output**: The user hears the image description.

### 3. Read and Translate
- **Capture Image with Text**: The user captures an image containing text.
- **Image Processing**: The image is sent to LVLM, which processes the image.
- **Response Generation**: The response is sent back to the app.
- **Auditory Output**: The app converts the text into auditory output.

### 4. Echo
- **Shake Detection**: The user shakes the device to start recording.
- **Audio Processing**: Recorded audio files are sent to the Whisper API.
- **Response Translation**: The received response is translated.
- **Auditory Output**: The app converts the translated outputs into auditory output.

## Methods
The application employs various advanced AI techniques and models to process and provide outputs as per the user’s requirements. The key methodologies involve:
- Image Pre-processing
- Braille Detection and Conversion using YOL -v8
- Text Translation using GPT-4V(ision)
- Audio processing using Whisper API
