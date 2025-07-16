import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _HomePageState();
}

class _HomePageState extends State<RegistrationScreen> {
  late ImagePicker imagePicker;
  File? _image;
  late FaceDetector faceDetector;
  List<Face> faces = [];
  ui.Image? image;
  img.Image? faceImage; // cropped image
  Uint8List? faceImageBytes;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    final options = FaceDetectorOptions(enableClassification: true);
    faceDetector = FaceDetector(options: options);
  }

  Future<void> _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      await doFaceDetection();
    }
  }

  Future<void> _imgFromGallery() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      await doFaceDetection();
    }
  }

  Future<void> doFaceDetection() async {
    _image = await removeRotation(_image!);
    InputImage inputImage = InputImage.fromFile(_image!);
    final result = await faceDetector.processImage(inputImage);

    if (result.isNotEmpty) {
      final Rect faceRect = result[0].boundingBox;

      final bytes = await _image!.readAsBytes();
      final decodedImage = img.decodeImage(bytes);
      if (decodedImage != null) {
        faceImage = img.copyCrop(
          decodedImage,
          x: faceRect.left.toInt().clamp(0, decodedImage.width),
          y: faceRect.top.toInt().clamp(0, decodedImage.height),
          width: faceRect.width.toInt().clamp(0, decodedImage.width),
          height: faceRect.height.toInt().clamp(0, decodedImage.height),
        );
        faceImageBytes = Uint8List.fromList(img.encodeJpg(faceImage!));
      }
    }

    final uiImage = await decodeImageFromList(await _image!.readAsBytes());

    setState(() {
      faces = result;
      image = uiImage;
    });
  }

  Future<File> removeRotation(File inputImage) async {
    final img.Image? capturedImage = img.decodeImage(await inputImage.readAsBytes());
    final img.Image orientedImage = img.bakeOrientation(capturedImage!);
    return await File(inputImage.path).writeAsBytes(img.encodeJpg(orientedImage));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1f4037), Color(0xFF99f2c8)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Face Registration",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 30),

              // Display cropped face if available
              faceImageBytes != null
                  ? Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.memory(faceImageBytes!),
                    )
                  : Container(
                      width: screenWidth / 1.15,
                      height: screenWidth / 1.15,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFffffff), Color(0xFFd4f7e6)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(75),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: image != null
                            ? FittedBox(
                                child: SizedBox(
                                  width: image!.width.toDouble(),
                                  height: image!.height.toDouble(),
                                  child: CustomPaint(
                                    painter: FacePainter(facesList: faces, imageFile: image!),
                                  ),
                                ),
                              )
                            : Image.asset("images/logo.png", fit: BoxFit.fill),
                      ),
                    ),

              const SizedBox(height: 40),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _gradientButton(
                    icon: Icons.image,
                    label: "Gallery",
                    onTap: _imgFromGallery,
                    width: screenWidth * 0.4,
                  ),
                  _gradientButton(
                    icon: Icons.camera_alt,
                    label: "Camera",
                    onTap: _imgFromCamera,
                    width: screenWidth * 0.4,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gradientButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    double width = 150,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFFffffff), Color(0xFFc4f1e0)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black87),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  List<Face> facesList;
  ui.Image imageFile;

  FacePainter({required this.facesList, required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(imageFile, Offset.zero, Paint());

    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (Face face in facesList) {
      canvas.drawRect(face.boundingBox, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
