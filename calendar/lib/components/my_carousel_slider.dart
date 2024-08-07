// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class MyCarouselSlider extends StatefulWidget {
  const MyCarouselSlider({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyCarouselSliderState createState() => _MyCarouselSliderState();
}

class _MyCarouselSliderState extends State<MyCarouselSlider> {
  final _controller = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start auto sliding images every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _controller.animateToPage(_currentPage + 1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      } else {
        _controller.animateToPage(0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when widget is disposed
    _controller.dispose();
    super.dispose();
  }

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print('Could not launch $url');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    } catch (e) {
      print('Error launching $url: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching $url: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          width: 450,
          child: PageView(
            controller: _controller,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              _buildImageWithButton(
                imagePath: "images/img1.jpg",
                url:
                    "https://www.bankofabyssinia.com/mobile-banking-in-ethiopia/",
              ),
              _buildImageWithButton(
                imagePath: "images/img2.png",
                url: "https://www.bankofabyssinia.com/",
              ),
              _buildImageWithButton(
                imagePath: "images/img3.jpg",
                url: "https://www.bankofabyssinia.com/interest-free-banking/",
              ),
            ],
          ),
        ),
        SmoothPageIndicator(
          controller: _controller,
          count: 3,
          effect: const ExpandingDotsEffect(
            activeDotColor: Color.fromARGB(255, 233, 176, 64),
            dotColor: Color.fromARGB(255, 245, 222, 174),
            dotWidth: 15,
            dotHeight: 15,
            spacing: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildImageWithButton(
      {required String imagePath, required String url}) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit
                    .cover, // Add this line to ensure the image fits perfectly
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 150,
            child: ElevatedButton(
              onPressed: () => _launchURL(url),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 247, 247,
                    247), // Replace with your desired background color
              ),
              child: const Text(
                'Learn More',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
