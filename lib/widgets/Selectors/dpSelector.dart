import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'dart:io';

class WhatsAppDpPicker extends StatefulWidget {
  final Function(List<File>) onImagesSelected;

  const WhatsAppDpPicker({Key? key, required this.onImagesSelected}) : super(key: key);

  @override
  State<WhatsAppDpPicker> createState() => _WhatsAppDpPickerState();
}

class _WhatsAppDpPickerState extends State<WhatsAppDpPicker> {
  List<AssetEntity> displayedImages = [];
  List<AssetEntity> selectedImages = [];
  List<AssetPathEntity> albums = [];
  AssetPathEntity? selectedAlbum;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAlbumsAndImages();
  }

  Future<void> _loadAlbumsAndImages() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend(
      requestOption: PermissionRequestOption(iosAccessLevel: IosAccessLevel.readWrite),
    );

    if (!ps.isAuth) {
      setState(() => isLoading = false);
      return;
    }

    final List<AssetPathEntity> allAlbums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      filterOption: FilterOptionGroup(
        imageOption: const FilterOption(sizeConstraint: SizeConstraint(minWidth: 1, minHeight: 1)),
        orders: [const OrderOption(type: OrderOptionType.createDate, asc: false)],
      ),
    );

    if (allAlbums.isNotEmpty) {
      final AssetPathEntity firstAlbum = allAlbums.first;
      final List<AssetEntity> media = await firstAlbum.getAssetListRange(start: 0, end: 60);
      setState(() {
        albums = allAlbums;
        selectedAlbum = firstAlbum;
        displayedImages = media;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  void _toggleImageSelection(AssetEntity asset) {
    setState(() {
      selectedImages = [asset]; // single selection
    });
  }

  Future<void> _sendSelectedImages() async {
    if (selectedImages.isEmpty) return;
    List<File> files = [];
    for (AssetEntity asset in selectedImages) {
      final File? file = await asset.file;
      if (file != null) files.add(file);
    }
    widget.onImagesSelected(files);
    Navigator.pop(context);
  }

  int _getSelectionNumber(AssetEntity asset) {
    return selectedImages.indexOf(asset) + 1;
  }

  Future<void> _onAlbumChanged(AssetPathEntity? album) async {
    if (album == null) return;
    final List<AssetEntity> media = await album.getAssetListRange(start: 0, end: 60);
    setState(() {
      selectedAlbum = album;
      displayedImages = media;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Color(0xFF1F2C34),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Center(
              child: Container(
                width: 55,
                height: 4,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
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
                          const Text(
                            'Done',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (!isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: DropdownButton<AssetPathEntity>(
                value: selectedAlbum,
                isExpanded: true,
                dropdownColor: const Color(0xFF1F2C34),
                underline: const SizedBox(),
                iconEnabledColor: Colors.white,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                onChanged: _onAlbumChanged,
                items: albums.map((album) {
                  return DropdownMenuItem(
                    value: album,
                    child: Text(album.name),
                  );
                }).toList(),
              ),
            ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.green))
                : GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: displayedImages.length,
              itemBuilder: (context, index) {
                final asset = displayedImages[index];
                final isSelected = selectedImages.contains(asset);
                return GestureDetector(
                  onTap: () => _toggleImageSelection(asset),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image(
                          image: AssetEntityImageProvider(asset),
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (isSelected)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF25D366), width: 2),
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
                            color: isSelected ? const Color(0xFF25D366) : Colors.black.withOpacity(0.3),
                            border: Border.all(color: Colors.white, width: 2),
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
    );
  }
}
