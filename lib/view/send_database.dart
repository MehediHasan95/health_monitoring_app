import 'package:flutter/material.dart';
import 'package:health_monitoring_app/model/sensor_data_model.dart';
import 'package:health_monitoring_app/provider/sensor_data_provider.dart';
import 'package:health_monitoring_app/utils/constants.dart';
import 'package:provider/provider.dart';

class SendDatabase extends StatefulWidget {
  const SendDatabase({Key? key}) : super(key: key);
  static const String routeNames = '/SendDatabase';

  @override
  State<SendDatabase> createState() => _SendDatabaseState();
}

class _SendDatabaseState extends State<SendDatabase> {
  final _formKey = GlobalKey<FormState>();
  final _bpmController = TextEditingController();
  final _spo2Controller = TextEditingController();
  final _tempCController = TextEditingController();

  @override
  void dispose() {
    _bpmController.dispose();
    _spo2Controller.dispose();
    _tempCController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text('Send to database'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(25.0),
          children: [
            TextFormField(
              controller: _bpmController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Hear Rate'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return emptyFieldErrMsg;
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _spo2Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Oxygen Saturation'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return emptyFieldErrMsg;
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _tempCController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Temperature'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return emptyFieldErrMsg;
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _saveSensorDataToDatabase,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveSensorDataToDatabase() {
    if (_formKey.currentState!.validate()) {
      final sensorDataModel = SensorDataModel(
        bpm: _bpmController.text,
        spo2: _spo2Controller.text,
        tempC: _tempCController.text,
        timestamp: DateTime.now(),
      );
      Provider.of<SensorDataProvider>(context, listen: false)
          .saveSensorData(sensorDataModel)
          .then((value) {
        setState(() {
          _bpmController.clear();
          _spo2Controller.clear();
          _tempCController.clear();
        });
        showMsg(context, 'Submit Successfull');
      }).catchError((error) {
        showMsg(context, error);
      });
    }
  }
}
