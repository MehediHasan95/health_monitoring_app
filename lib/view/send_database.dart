import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_monitoring_app/model/sensor_data_model.dart';
import 'package:health_monitoring_app/provider/sensor_data_provider.dart';
import 'package:health_monitoring_app/utils/constants.dart';
import 'package:intl/intl.dart';
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
  DateTime? dateTime;
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
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _saveSensorDataToDatabase,
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(25.0),
          children: [
            TextFormField(
              controller: _bpmController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(hintText: 'Enter your Hear-rate'),
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
              decoration:
                  const InputDecoration(hintText: 'Enter your Oxygen-Level'),
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
              decoration: const InputDecoration(
                  hintText: 'Enter your Body-Temparature'),
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
            Card(
              elevation: 3.0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: _showDatePickerDialog,
                      child: Text(dateTime == null
                          ? 'Please select date'
                          : DateFormat('dd/MM/yyyy').format(dateTime!)),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Material(
                elevation: 1.0,
                color: Colors.blue.shade900,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: _saveSensorDataToDatabase,
                  minWidth: 200.0,
                  height: 42.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Send',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePickerDialog() async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime.now());
    if (selectedDate != null) {
      setState(() {
        dateTime = selectedDate;
      });
    }
  }

  void _saveSensorDataToDatabase() {
    if (_formKey.currentState!.validate()) {
      final sensorDataModel = SensorDataModel(
          bpm: _bpmController.text,
          spo2: _spo2Controller.text,
          tempC: _tempCController.text,
          setTimestamp: Timestamp.fromDate(dateTime!));
      Provider.of<SensorDataProvider>(context, listen: false)
          .saveSensorData(sensorDataModel)
          .then((value) {
        setState(() {
          _bpmController.text = '';
          _spo2Controller.text = '';
          _tempCController.text = '';
          dateTime = null;
        });
        showMsg(context, 'Submission Successful');
      }).catchError((error) {
        showMsg(context, error);
      });
    }
  }
}
