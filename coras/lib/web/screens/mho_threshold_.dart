// show_uploaded_image_screen.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ThresholdScreen extends StatefulWidget {
  const ThresholdScreen({super.key});

  @override
  State<ThresholdScreen> createState() => _ShowUploadedImageScreenState();
}

class _ShowUploadedImageScreenState extends State<ThresholdScreen> {
  // For mobile/native: store File
  File? _localImageFile;

  // For web: store bytes
  Uint8List? _imageBytes;

  // Optional: store a network URL (demonstrates cached_network_image)
  String? _networkImageUrl;

  final ImagePicker _picker = ImagePicker();

  // Only pick from gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (picked == null) return; // user cancelled

      if (kIsWeb) {
        // On web: get bytes and clear local file
        final bytes = await picked.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _localImageFile = null;
          _networkImageUrl = null;
        });
      } else {
        // On mobile/desktop: use File
        setState(() {
          _localImageFile = File(picked.path);
          _imageBytes = null;
          _networkImageUrl = null;
        });
      }
    } catch (e) {
      debugPrint('Image pick error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  Widget _buildImageWidget() {
    // Placeholder when nothing selected
    const placeholder = Center(
      child: Text(
        'No image selected',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );

    Widget? rawImage;

    if (_imageBytes != null) {
      // Web (or any case where you have bytes)
      rawImage = Image.memory(_imageBytes!, fit: BoxFit.contain);
    } else if (_localImageFile != null) {
      // Mobile/desktop file
      rawImage = Image.file(_localImageFile!, fit: BoxFit.contain);
    } else if (_networkImageUrl != null && _networkImageUrl!.isNotEmpty) {
      // Network image (cached)
      rawImage = CachedNetworkImage(
        imageUrl: _networkImageUrl!,
        fit: BoxFit.contain,
        placeholder: (c, u) => const Center(child: CircularProgressIndicator()),
        errorWidget:
            (c, u, e) =>
                const Center(child: Icon(Icons.broken_image, size: 48)),
      );
    } else {
      return placeholder;
    }

    return InteractiveViewer(
      panEnabled: true,
      scaleEnabled: true,
      minScale: 0.5,
      maxScale: 4.0,
      child: Center(child: rawImage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // full-screen image area
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(255, 245, 245, 245),
              child: _buildImageWidget(),
            ),
          ),

          // Import Image button at top-left
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: ElevatedButton.icon(
                  onPressed: _pickImageFromGallery,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Import Image'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.65),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Clear button bottom-right for convenience
          if (_imageBytes != null ||
              _localImageFile != null ||
              (_networkImageUrl != null && _networkImageUrl!.isNotEmpty))
            SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _imageBytes = null;
                        _localImageFile = null;
                        _networkImageUrl = null;
                      });
                    },
                    child: const Icon(Icons.clear),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
