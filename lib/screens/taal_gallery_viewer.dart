import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:photo_view/photo_view.dart';

class TaalGalleryViewer extends StatefulWidget {
  final int initialIndex;
  const TaalGalleryViewer({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<TaalGalleryViewer> createState() => _TaalGalleryViewerState();
}

class _TaalGalleryViewerState extends State<TaalGalleryViewer> {
  late int currentIndex;
  final List<String> images = [
    'assets/images/taal_volcano.jpg',
    'assets/images/taal_volcano2.jpg',
    'assets/images/taal_volcano3.jpg',
    'assets/images/taal_volcano4.jpg',
    'assets/images/taal_volcano5.jpg',
    'assets/images/taal_volcano6.jpg',
    'assets/images/taal_volcano7.jpg',
  ];
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
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
