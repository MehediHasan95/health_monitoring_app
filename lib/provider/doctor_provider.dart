import 'package:flutter/foundation.dart';
import 'package:health_monitoring_app/database/database_helper.dart';

class DoctorProvider extends ChangeNotifier {
  Future<bool> isDoctor(String email) => DatabaseHelper.isDoctor(email);
}
