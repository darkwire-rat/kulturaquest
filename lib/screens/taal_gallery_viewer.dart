import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:photo_view/photo_view.dart';

class TaalGalleryViewer extends StatefulWidget {
  final String? imagePath;
  final List<String>? images;
  final int initialIndex;
  
  const TaalGalleryViewer({
    Key? key,
    this.imagePath,
    this.images,
    this.initialIndex = 0,
  }) : assert(imagePath != null || images != null, 'Either imagePath or images must be provided'),
       super(key: key);

  @override
  State<TaalGalleryViewer> createState() => _TaalGalleryViewerState();
}

class _TaalGalleryViewerState extends State<TaalGalleryViewer> {
  late int currentIndex;
  late List<String> images;
  late PageController _controller;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize images list based on what's provided
    if (widget.images != null) {
      images = widget.images!;
    } else {
      // If single image path is provided, create a list with just that image
      images = [widget.imagePath!];
    }
    
    // Ensure initialIndex is within bounds
    currentIndex = widget.initialIndex.clamp(0, images.length - 1);
    _controller = PageController(initialPage: currentIndex);
  }



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void jumpTo(int idx) {
    _controller.animateToPage(idx, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
    setState(() => currentIndex = idx);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        PhotoViewGallery.builder(
          itemCount: images.length,
          pageController: _controller,
          onPageChanged: (idx) => setState(() => currentIndex = idx),
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: AssetImage(images[index]),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
              heroAttributes: PhotoViewHeroAttributes(tag: images[index]),
            );
          },
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 32),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        // Left arrow
        if (currentIndex > 0)
          Positioned(
            left: 16,
            top: MediaQuery.of(context).size.height / 2 - 24,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 32),
              onPressed: () => jumpTo(currentIndex - 1),
            ),
          ),
        // Right arrow
        if (currentIndex < images.length - 1)
          Positioned(
            right: 16,
            top: MediaQuery.of(context).size.height / 2 - 24,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 32),
              onPressed: () => jumpTo(currentIndex + 1),
            ),
          ),
      ],
    );
  }
}
