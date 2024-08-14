import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 1) {
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

  final CollectionReference adsCollection = FirebaseFirestore.instance.collection("AdsList");

  Stream<QuerySnapshot> getImageUrl() {
    return adsCollection.orderBy('timestamp', descending: true).snapshots();
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
    return StreamBuilder<QuerySnapshot>(
      stream: getImageUrl(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final ads = snapshot.data!.docs;
        return Column(
          children: [
            SizedBox(
              height: 250,
              width: 450,
              child: PageView.builder(
                controller: _controller,
                itemCount: ads.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  final ad = ads[index];
                  final imageUrl = ad['image'];
                  final url = ad['url'];
                  final adName = ad['name'];

                  return _buildImageWithButton(
                    imagePath: imageUrl,
                    url: url,
                    adName: adName,
                  );
                },
              ),
            ),
            SmoothPageIndicator(
              controller: _controller,
              count: ads.length,
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
      },
    );
  }

  Widget _buildImageWithButton({
    required String imagePath,
    required String url,
    required String adName,
  }) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Image.network(
                imagePath,
                fit: BoxFit.cover, // Add this line to ensure the image fits perfectly
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
                backgroundColor: const Color.fromARGB(255, 247, 247, 247), // Replace with your desired background color
              ),
              child: Text(
                'Learn More',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
