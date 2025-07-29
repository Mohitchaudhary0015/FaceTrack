# FaceTrack – Flutter Face Recognition Attendance App

A Flutter-based attendance application using **on-device face detection** with Google ML Kit. Designed for efficient verification using the camera and a clean, responsive UI.

## 🧰 Tech Stack

- **Flutter** for cross-platform UI  
- **Dart** as the programming language  
- **google_mlkit_face_detection** – for on-device face detection  
- **image_picker** – to capture photos via camera or gallery  
- **image** package – for cropping and orientation correction  
- **CustomPainter** – to draw bounding boxes on detected faces  
- **State Management:** basic control using `StatefulWidget`  
- **UI / Widgets:** Material Design components for polished visual design

## 🚀 Features

- Real-time **face detection** for attendance check-in/check-out  
- Face bounding boxes using **CustomPainter**  
- Capture and process images from camera/gallery  
- Lightweight, offline and local processing only (no backend)

## 📁 How to Run

```bash
git clone https://github.com/Mohitchaudhary0015/FaceTrack.git
cd FaceTrack
flutter pub get
flutter run
