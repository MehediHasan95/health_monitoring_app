import 'package:flutter/foundation.dart';
import 'package:health_monitoring_app/database/database_helper.dart';
import 'package:health_monitoring_app/model/doctor_model.dart';

class DoctorProvider extends ChangeNotifier {
  Future<bool> isDoctor(String email) => DatabaseHelper.isDoctor(email);
  List<DoctorModel> doctorList = [];

  void getAllDoctorData() {
    DatabaseHelper.fetchAllDoctorData().listen((event) {
      doctorList = List.generate(event.docs.length,
          (index) => DoctorModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }
}
