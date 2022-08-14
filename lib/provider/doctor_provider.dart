import 'package:flutter/foundation.dart';
import 'package:health_monitoring_app/database/database_helper.dart';
import 'package:health_monitoring_app/model/doctor_data_model.dart';

class DoctorProvider extends ChangeNotifier {
  Future<bool> isDoctor(String email) => DatabaseHelper.isDoctor(email);
  List<DoctorDataModel> getValueFromDB = [];

  void getAllDoctorData() {
    DatabaseHelper.fetchAllDoctorData().listen((event) {
      getValueFromDB = List.generate(event.docs.length,
          (index) => DoctorDataModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }
}
