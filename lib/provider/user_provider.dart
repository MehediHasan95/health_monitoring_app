import 'package:flutter/foundation.dart';
import 'package:health_monitoring_app/database/database_helper.dart';

class UserProvider extends ChangeNotifier {
  Future<bool> isUser(String email) => DatabaseHelper.isUser(email);
}
