import 'package:flutter/foundation.dart';
import 'package:health_monitoring_app/database/database_helper.dart';
import 'package:health_monitoring_app/model/user_model.dart';

class UserProvider extends ChangeNotifier {
  Future<bool> isUser(String email) => DatabaseHelper.isUser(email);
  List<UserModel> userList = [];

  void getAllUserData() {
    DatabaseHelper.fetchAllUserData().listen((event) {
      userList = List.generate(event.docs.length,
          (index) => UserModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }
}
