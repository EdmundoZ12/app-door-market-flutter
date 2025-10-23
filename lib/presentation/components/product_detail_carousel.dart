import 'package:flutter/material.dart';

class ProductDetailCarousel extends StatefulWidget {
  const ProductDetailCarousel({super.key, required this.images});

  final List<String> images;

  @override
  State<ProductDetailCarousel> createState() => _ProductDetailCarouselState();
}

class _ProductDetailCarouselState extends State<ProductDetailCarousel> {
  late final PageController _pageController;
  late List<String> _images;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _images = widget.images.isEmpty ? [''] : widget.images;
    _pageController = PageController();
  }

  @override
  void didUpdateWidget(ProductDetailCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.images != widget.images) {
      _images = widget.images.isEmpty ? [''] : widget.images;
      if (_currentIndex >= _images.length) {
        _currentIndex = 0;
        _pageController.jumpToPage(0);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 260,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              color: const Color(0xFFF8F8FA),
              child: PageView.builder(
                controller: _pageController,
                itemCount: _images.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  return _buildImage(_images[index], fit: BoxFit.contain);
                },
              ),
            ),
          ),
        ),
        if (_images.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _images.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentIndex == index ? 16 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? const Color(0xFFE53935)
                      : Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildImage(String path, {BoxFit fit = BoxFit.cover}) {
    if (path.isEmpty) {
      return _buildPlaceholder();
    }
    return Image.asset(
      path,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFEDEDED),
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_not_supported,
        color: Colors.grey,
        size: 42,
      ),
    );
  }
}
