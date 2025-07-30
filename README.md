# FaceTrack – Flutter Face Recognition App

A Flutter-based  application using **on-device face detection** with Google ML Kit. Designed for efficient verification using the camera and a clean, responsive UI.

##  Tech Stack

- **Flutter** for cross-platform UI  
- **Dart** as the programming language  
- **google_mlkit_face_detection** – for on-device face detection  
- **image_picker** – to capture photos via camera or gallery  
- **image** package – for cropping and orientation correction  
- **CustomPainter** – to draw bounding boxes on detected faces  
- **State Management:** basic control using `StatefulWidget`  
- **UI / Widgets:** Material Design components for polished visual design


## Screenshot 


<img width="300" height="650" alt="Simulator Screenshot - iPhone 16 Plus - 2025-07-30 at 23 32 46" src="https://github.com/user-attachments/assets/8652909c-555e-4129-9b4a-943c3213be74" />

<img width="300" height="650" alt="Simulator Screenshot - iPhone 16 Plus - 2025-07-30 at 23 32 30" src="https://github.com/user-attachments/assets/7afd0f4f-e02e-400a-a3b4-555f8d37c307" />
<img width="300" height="650" alt="Simulator Screenshot - iPhone 16 Plus - 2025-07-30 at 23 32 57" src="https://github.com/user-attachments/assets/0760cca7-d094-4eb6-bba8-ee462d6ca9e0" />







## Features

- Real-time **face detection** for attendance check-in/check-out  
- Face bounding boxes using **CustomPainter**  
- Capture and process images from camera/gallery  
- Lightweight, offline and local processing only (no backend)

##  How to Run

```bash
git clone https://github.com/Mohitchaudhary0015/FaceTrack.git
cd FaceTrack
flutter pub get
flutter run
