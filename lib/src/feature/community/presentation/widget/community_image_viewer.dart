import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Future<void> showCommunityImageViewer(
  BuildContext context, {
  required List<String> imageUrls,
  int initialIndex = 0,
}) {
  return Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (context) => _CommunityImageViewerPage(
        imageUrls: imageUrls,
        initialIndex: initialIndex,
      ),
      fullscreenDialog: true,
    ),
  );
}

class _CommunityImageViewerPage extends StatefulWidget {
  const _CommunityImageViewerPage({
    required this.imageUrls,
    required this.initialIndex,
  });

  final List<String> imageUrls;
  final int initialIndex;

  @override
  State<_CommunityImageViewerPage> createState() =>
      _CommunityImageViewerPageState();
}

class _CommunityImageViewerPageState extends State<_CommunityImageViewerPage> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.imageUrls.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                '${_currentIndex + 1}/${widget.imageUrls.length}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.imageUrls.length,
        onPageChanged: (value) {
          if (!mounted) {
            return;
          }
          setState(() {
            _currentIndex = value;
          });
        },
        itemBuilder: (context, index) {
          return InteractiveViewer(
            minScale: 1,
            maxScale: 4,
            child: Center(
              child: CachedNetworkImage(
                imageUrl: widget.imageUrls[index],
                fit: BoxFit.contain,
                placeholder: (context, imageUrl) =>
                    const ColoredBox(color: Colors.black),
                errorWidget: (context, imageUrl, error) => const Icon(
                  Icons.broken_image_outlined,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
