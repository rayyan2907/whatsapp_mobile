import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whatsapp_mobile/color.dart';
import 'package:whatsapp_mobile/services/dpSetService.dart';
import 'package:whatsapp_mobile/widgets/Selectors/cameraSelector.dart';
import '../Selectors/dpSelector.dart';
import 'login.dart';

class ProfilePictureScreen extends StatefulWidget {
  final String? email;
  const ProfilePictureScreen({super.key, required this.email});

  @override
  State<ProfilePictureScreen> createState() => _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen> {
  bool _isLoading = false;
  File? _selectedImage;
  Uint8List? _imageBytes;
  bool _isDragOver = false;

  // Simulated file picker (replace with actual image_picker implementation)
  Future<void> _pickImage() async {
    try {
      // For demonstration, we'll simulate file selection
      _showImagePicker();
    } catch (e) {
      _showError('Error picking image: $e');
    }
  }

  void _openWhatsAppDpPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WhatsAppDpPicker(
        onImagesSelected: (images) {
          if (images.isNotEmpty) {
            setState(() {
              _selectedImage = images.first;
            });
          }
        },
      ),
    );
  }

  void _openWhatsAppCameraPicker() async {
    final File? image = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const WhatsAppCameraPage()),
    );

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F2C34),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 55,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF8696A0),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Profile Picture',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOptionButton(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    _openWhatsAppCameraPicker();
                  },
                ),
                _buildOptionButton(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _openWhatsAppDpPicker();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFF25D366),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _setProfilePicture() async {
    if (_selectedImage != null) {
      setState(() {
        _isLoading = true;
      });
      final msg = await DpUploadService().UploadDp(
        widget.email!,
        _selectedImage!,
      );
      if (msg == 'success') {

        _showSuccessDialog();
        setState(() {
          _isLoading=false;
        });
      } else {
        Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      _showError('Please select an image first');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F2C34),
        title: const Text(
          'Profile Picture Set',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Your profile picture has been updated successfully!',
          style: TextStyle(color: Color(0xFF8696A0)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _navigateToNextScreen();
            },
            child: const Text(
              'Continue',
              style: TextStyle(color: Color(0xFF25D366)),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToNextScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 100),
      ),
      (route) => false,
    );
  }

  void _skipForNow() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F2C34),
        title: const Text(
          'Skip Profile Picture?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'You can always add a profile picture later from settings.',
          style: TextStyle(color: Color(0xFF8696A0)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF8696A0)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _navigateToNextScreen();
            },
            child: const Text(
              'Skip',
              style: TextStyle(color: Color(0xFF25D366)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // WhatsApp Logo
              const FaIcon(
                FontAwesomeIcons.whatsapp,
                color: Color(0xFF25D366),
                size: 70,
              ),

              const SizedBox(height: 32),

              // Title
              const Text(
                'Set Profile Picture',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              const Text(
                'Choose a photo that represents you - it will be displayed as a circle',
                style: TextStyle(color: Color(0xFF8696A0), fontSize: 16),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Success Message
              const Text(
                'Account created. Set profile photo',
                style: TextStyle(color: Color(0xFF25D366), fontSize: 14),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Drag and Drop Area
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: _isDragOver
                        ? const Color(0xFFF5F5F5)
                        : const Color(0xFFE8E8E8),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: _isDragOver
                          ? const Color(0xFF25D366)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: _selectedImage != null
                      ? _buildSelectedImage()
                      : _buildDropZone(),
                ),
              ),

              const SizedBox(height: 16),

              // Supported formats text
              const Text(
                'Supported formats: JPG, PNG, GIF. Maximum size: 5MB',
                style: TextStyle(color: Color(0xFF8696A0), fontSize: 12),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Set Profile Picture Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _selectedImage != null && !_isLoading
                      ? _setProfilePicture
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedImage != null
                        ? const Color(0xFF25D366)
                        : const Color(0xFF25D366).withOpacity(0.5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Set as Profile Picture',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Skip Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: _skipForNow,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF2A3942), width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Skip for now',
                    style: TextStyle(
                      color: Color(0xFF8696A0),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropZone() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.add_a_photo, color: Colors.grey.shade600, size: 30),
        ),
        const SizedBox(height: 16),
        Text(
          'Drag and drop your photo here',
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'or ',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            GestureDetector(
              onTap: _pickImage,
              child: const Text(
                'browse files',
                style: TextStyle(
                  color: Color(0xFF25D366),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectedImage() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: FileImage(_selectedImage!),
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.bottomRight,
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF25D366),
        ),
        padding: const EdgeInsets.all(6),
        child: const Icon(Icons.check, color: Colors.white, size: 18),
      ),
    );
  }
}
