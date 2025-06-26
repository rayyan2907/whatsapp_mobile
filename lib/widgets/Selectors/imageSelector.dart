import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io';

class WhatsAppImagePicker extends StatefulWidget {
  final Function(List<File>) onImagesSelected;

  const WhatsAppImagePicker({
    Key? key,
    required this.onImagesSelected,
  }) : super(key: key);

  @override
  State<WhatsAppImagePicker> createState() => _WhatsAppImagePickerState();
}

class _WhatsAppImagePickerState extends State<WhatsAppImagePicker> {
  List<AssetEntity> recentImages = [];
  List<AssetEntity> selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecentImages();
  }

  Future<void> _loadRecentImages() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true,
      );

      if (albums.isNotEmpty) {
        final List<AssetEntity> media = await albums[0].getAssetListPaged(
          page: 0,
          size: 100,
        );
        setState(() {
          recentImages = media;
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image != null) {
      widget.onImagesSelected([File(image.path)]);
      Navigator.pop(context);
    }
  }

  Future<void> _pickFromGallery() async {
    final List<XFile> images = await _picker.pickMultiImage(
      imageQuality: 80,
    );

    if (images.isNotEmpty) {
      final List<File> files = images.map((image) => File(image.path)).toList();
      widget.onImagesSelected(files);
      Navigator.pop(context);
    }
  }

  void _toggleImageSelection(AssetEntity asset) {
    setState(() {
      if (selectedImages.contains(asset)) {
        selectedImages.remove(asset);
      } else {
        selectedImages.add(asset);
      }
    });
  }

  Future<void> _sendSelectedImages() async {
    if (selectedImages.isEmpty) return;

    List<File> files = [];
    for (AssetEntity asset in selectedImages) {
      final File? file = await asset.file;
      if (file != null) {
        files.add(file);
      }
    }

    widget.onImagesSelected(files);
    Navigator.pop(context);
  }

  int _getSelectionNumber(AssetEntity asset) {
    return selectedImages.indexOf(asset) + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 24),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Select photos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (selectedImages.isNotEmpty)
                  GestureDetector(
                    onTap: _sendSelectedImages,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF25D366),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Send (${selectedImages.length})',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Camera and Gallery Options
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _pickFromCamera,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Color(0xFF25D366),
                            child: Icon(Icons.camera_alt, color: Colors.white, size: 24),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Camera',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: _pickFromGallery,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.photo_library, color: Colors.white, size: 24),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Gallery',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Recent Photos Section
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Recent',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: recentImages.length,
                    itemBuilder: (context, index) {
                      final asset = recentImages[index];
                      final isSelected = selectedImages.contains(asset);

                      return GestureDetector(
                        onTap: () => _toggleImageSelection(asset),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: AssetEntityImage(
                                asset,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            if (isSelected)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFF25D366),
                                    width: 2,
                                  ),
                                ),
                              ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? const Color(0xFF25D366)
                                      : Colors.black.withOpacity(0.3),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? Center(
                                  child: Text(
                                    '${_getSelectionNumber(asset)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Usage Example Widget
class ImagePickerDemo extends StatefulWidget {
  @override
  _ImagePickerDemoState createState() => _ImagePickerDemoState();
}

class _ImagePickerDemoState extends State<ImagePickerDemo> {
  List<File> selectedImages = [];

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WhatsAppImagePicker(
        onImagesSelected: (images) {
          setState(() {
            selectedImages = images;
          });
          // Call your function here with the selected images
          _handleSelectedImages(images);
        },
      ),
    );
  }

  void _handleSelectedImages(List<File> images) {
    // This is where you would call your function with the selected images
    print('Selected ${images.length} images');
    for (File image in images) {
      print('Image path: ${image.path}');
    }

    // Example: Upload images, process them, etc.
    // uploadImages(images);
    // processImages(images);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatsApp Image Picker Demo'),
        backgroundColor: const Color(0xFF25D366),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _showImagePicker,
              icon: const Icon(Icons.photo),
              label: const Text('Open Image Picker'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            if (selectedImages.isNotEmpty)
              Text(
                'Selected ${selectedImages.length} image(s)',
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 20),
            if (selectedImages.isNotEmpty)
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: selectedImages.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        selectedImages[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}