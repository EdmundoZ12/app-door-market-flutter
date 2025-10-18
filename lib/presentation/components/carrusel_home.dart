import 'dart:async';
import 'package:flutter/material.dart';

class CarruselHome extends StatefulWidget {
  const CarruselHome({super.key});

  @override
  State<CarruselHome> createState() => _CarruselHomeState();
}

class _CarruselHomeState extends State<CarruselHome> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  final List<String> banners = [
    'assets/images/carrusel/banner_1.png',
    'assets/images/carrusel/banner_2.png',
    'assets/images/carrusel/banner_3.png',
    'assets/images/carrusel/banner_4.png',
  ];

  @override
  void initState() {
    super.initState();
    // Iniciar en una página alta para simular loop infinito
    _pageController = PageController(initialPage: 10000);
    _currentPage = 0;
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Carrusel
        SizedBox(
          height: 160,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index % banners.length;
                });
              },
              itemBuilder: (context, index) {
                final bannerIndex = index % banners.length;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: const Color(0xFFF5F5F5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        banners[bannerIndex],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Indicadores
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              banners.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentPage == index ? 24 : 8,
                height: 4,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? const Color(0xFFD41307)
                      : Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
