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
        backgroundColor: Colors.blue.shade900,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const Text(
                'হার্ট সুস্থ রাখার উপায়',
                style: TextStyle(
                  fontSize: 24,
                  decoration: TextDecoration.underline,
                ),
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
                  color: Colors.blue.shade900,
                ),
                moreStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  height: 2,
                ),
              ),
              const Text(
                'হার্ট সুস্থ রাখার উপায়',
                style: TextStyle(
                  fontSize: 24,
                  decoration: TextDecoration.underline,
                ),
              ),
              ReadMoreText(
                healthTips2,
                trimLines: 5,
                textAlign: TextAlign.justify,
                trimMode: TrimMode.Line,
                trimCollapsedText: " Read more ",
                trimExpandedText: " Close ",
                lessStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
                moreStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  height: 2,
                ),
              ),
              const Text(
                'হার্ট সুস্থ রাখার উপায়',
                style: TextStyle(
                  fontSize: 24,
                  decoration: TextDecoration.underline,
                ),
              ),
              ReadMoreText(
                healthTips2,
                trimLines: 5,
                textAlign: TextAlign.justify,
                trimMode: TrimMode.Line,
                trimCollapsedText: " Read more ",
                trimExpandedText: " Close ",
                lessStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
                moreStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
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
    );
  }
}
