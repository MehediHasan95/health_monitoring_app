import 'package:flutter/foundation.dart';
import 'package:health_monitoring_app/database/database_helper.dart';
import 'package:health_monitoring_app/model/doctor_model.dart';

class DoctorProvider extends ChangeNotifier {
  Future<bool> isDoctor(String email) => DatabaseHelper.isDoctor(email);
  List<DoctorModel> doctorList = [];
  List<String> specialist = [];
  List<String> hospital = [];

  void getAllDoctorData() {
    DatabaseHelper.fetchAllDoctorData().listen((event) {
      doctorList = List.generate(event.docs.length,
          (index) => DoctorModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

// Get all specialist list
  void getAllSpecialist() {
    DatabaseHelper.fetchAllSpecialist().listen((event) {
      specialist = List.generate(
          event.docs.length, (index) => event.docs[index].data()['specialist']);
      notifyListeners();
    });
  }

// Get all hospital list
  void getAllHospital() {
    DatabaseHelper.fetchAllHospital().listen((event) {
      hospital = List.generate(
          event.docs.length, (index) => event.docs[index].data()['hospital']);
      notifyListeners();
    });
  }
}
