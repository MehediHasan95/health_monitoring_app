import 'package:flutter/material.dart';

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
        backgroundColor: Colors.blue.shade900,
      ),
      body: const Center(
        child: Text('Health Tips'),
      ),
    );
  }
}
