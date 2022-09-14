import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/database/database_helper.dart';
import 'package:health_monitoring_app/utils/constants.dart';

class DoctorChatRoom extends StatefulWidget {
  final String value;
  const DoctorChatRoom({Key? key, required this.value}) : super(key: key);

  @override
  State<DoctorChatRoom> createState() => _DoctorChatRoomState();
}

class _DoctorChatRoomState extends State<DoctorChatRoom> {
  final uid = AuthService.currentUser?.uid;
  final _msgController = TextEditingController();
  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getDoctorProfileInfo();
    getUserProfileInfo(widget.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(username),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.pink.shade200, Colors.purple.shade900],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: StreamBuilder<QuerySnapshot>(
                  stream: DatabaseHelper.db
                      .collection("userChatBox")
                      .doc(widget.value)
                      .collection("message")
                      .orderBy("time", descending: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data != null) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Card(
                                  color: Colors.white70,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Text(snapshot.data!.docs[index]
                                            ["message"]),
                                        // Text(
                                        //     snapshot.data!.docs[index]["time"]),
                                      ],
                                    ),
                                  )),
                            );
                          });
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  minLines: 1,
                  maxLines: 500,
                  controller: _msgController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                          onPressed: () {
                            if (_msgController.text == "") {
                              showFlushBarErrorMsg(
                                  context, "Please write something");
                            } else {
                              onSendMessage();
                              _msgController.clear();
                            }
                          },
                          icon: const Icon(Icons.send, color: Colors.white)),
                      fillColor: Colors.white30,
                      filled: true,
                      hintText: "Message",
                      hintStyle: const TextStyle(color: Colors.white)),
                  cursorColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? doctorName = '';
  String? doctorGender = '';
  Future getDoctorProfileInfo() async {
    await DatabaseHelper.db.collection('doctor').doc(uid).get().then(
      (querySnapshot) {
        doctorName = querySnapshot.data()!['name'];
        doctorGender = querySnapshot.data()!['gender'];
      },
    );
    setState(() {
      doctorName;
      doctorGender;
    });
  }

  // User Profile info
  String username = '';
  Future getUserProfileInfo(String userID) async {
    await DatabaseHelper.db
        .collection('userProfileInfo')
        .doc(userID)
        .get()
        .then(
      (querySnapshot) {
        username = querySnapshot.data()!['username'];
      },
    );
    setState(() {
      username;
    });
  }

  void onSendMessage() async {
    await DatabaseHelper.db
        .collection("doctorChatBox")
        .doc(uid)
        .collection("message")
        .add({
      "doctorName": doctorName,
      "doctorGender": doctorGender,
      "message": _msgController.text,
      "time": DateTime.now(),
    });
  }
}
