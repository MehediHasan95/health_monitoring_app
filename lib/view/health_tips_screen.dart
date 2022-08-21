import 'package:flutter/material.dart';
import 'package:health_monitoring_app/utils/health_tips.dart';
import 'package:readmore/readmore.dart';

class HealthTipsScreen extends StatefulWidget {
  const HealthTipsScreen({Key? key}) : super(key: key);
  static const String routeNames = '/HealthTipsScreen';
  @override
  State<HealthTipsScreen> createState() => _HealthTipsScreenState();
}

class _HealthTipsScreenState extends State<HealthTipsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Tips"),
        backgroundColor: Colors.purple.shade900,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Card - 1
              Card(
                color: Colors.amber.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/pictureOne.jpg',
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'হার্ট সুস্থ রাখার উপায়:',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      ReadMoreText(
                        healthTips1,
                        trimLines: 5,
                        textAlign: TextAlign.justify,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: " Read more ",
                        trimExpandedText: "  Close ",
                        lessStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade900,
                        ),
                        moreStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade900,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          height: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Card - 2
              Card(
                color: Colors.amber.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/pictureTwo.jpg',
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'যা খেলে হিমোগ্লোবিন বাড়বে:',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      ReadMoreText(
                        healthTips2,
                        trimLines: 5,
                        textAlign: TextAlign.justify,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: " Read more ",
                        trimExpandedText: "  Close ",
                        lessStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade900,
                        ),
                        moreStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade900,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          height: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Card - 3
              Card(
                color: Colors.amber.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/pictureThree.jpg',
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'মানুষের শরীরের তাপমাত্রা কত:',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      ReadMoreText(
                        healthTips3,
                        trimLines: 5,
                        textAlign: TextAlign.justify,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: " Read more ",
                        trimExpandedText: "  Close ",
                        lessStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade900,
                        ),
                        moreStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade900,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          height: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Card - 4
              Card(
                color: Colors.amber.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/pictureFour.jpg',
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'শরীর স্বাস্থ্য ভালো রাখার উপায়:',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      ReadMoreText(
                        healthTips4,
                        trimLines: 5,
                        textAlign: TextAlign.justify,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: " Read more ",
                        trimExpandedText: "  Close ",
                        lessStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade900,
                        ),
                        moreStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade900,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          height: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
