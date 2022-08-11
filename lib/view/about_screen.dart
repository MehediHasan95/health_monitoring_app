import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);
  static const String routeNames = '/AboutScreen';

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(
                Icons.favorite,
                color: Colors.pink,
                size: 54.0,
              ),
              Text(
                'Health Corner',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              Text(
                "The Heart Rate observation system is developed mistreatment IoT technology with the target of detective work on the heartbeat of the patient to watch the danger of heart failure and additionally the regular medical checkup.",
                style: TextStyle(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text('Version: 1.0.0',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
