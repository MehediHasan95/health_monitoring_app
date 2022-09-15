import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:health_monitoring_app/database/database_helper.dart';
import 'package:health_monitoring_app/utils/constants.dart';
import 'package:intl/intl.dart';

class UserChatRoom extends StatefulWidget {
  final String value;
  const UserChatRoom({Key? key, required this.value}) : super(key: key);

  @override
  State<UserChatRoom> createState() => _UserChatRoomState();
}

class _UserChatRoomState extends State<UserChatRoom> {
  final uid = AuthService.currentUser?.uid;
  final _msgController = TextEditingController();
  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getDoctorProfileInfo(widget.value);
    getUserProfileInfo();
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
          title: Text(doctorName!),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.pink.shade200, Colors.purple.shade900],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: DatabaseHelper.db
                        .collection("doctorChatBox")
                        .doc(widget.value)
                        .collection("message")
                        .doc(uid)
                        .collection("chat")
                        .orderBy("time", descending: false)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text("Something is wrong");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            QueryDocumentSnapshot showGetMsg =
                                snapshot.data!.docs[index];
                            String name = showGetMsg['name'];
                            String message = showGetMsg['message'];
                            DateTime time = showGetMsg['time'].toDate();
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Card(
                                      color: Colors.white70,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                DateFormat(
                                                        'dd MMMM yyyy, hh:mm a')
                                                    .format(time)
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 8,
                                                    color:
                                                        Colors.grey.shade800)),
                                            Text(message,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.grey.shade800,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(name,
                                                style: TextStyle(
                                                    fontSize: 8,
                                                    color:
                                                        Colors.grey.shade800)),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            );
                          });
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
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: () {
                            if (_msgController.text == "") {
                              showFlushBarErrorMsg(
                                  context, "Please write something");
                            } else {
                              onSendMessage();
                            }
                          },
                        ),
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
      ),
    );
  }

  String? doctorName = '';
  Future getDoctorProfileInfo(String value) async {
    await DatabaseHelper.db.collection('doctor').doc(value).get().then(
      (querySnapshot) {
        doctorName = querySnapshot.data()!['name'];
      },
    );
    setState(() {
      doctorName;
    });
  }

  String username = '';
  String gender = '';
  Future getUserProfileInfo() async {
    await DatabaseHelper.db.collection('userProfileInfo').doc(uid).get().then(
      (querySnapshot) {
        username = querySnapshot.data()!['username'];
        gender = querySnapshot.data()!['gender'];
      },
    );

    setState(() {
      username;
      gender;
    });
  }

// .collection("userChatBox")
  void onSendMessage() async {
    await DatabaseHelper.db
        .collection("userChatBox")
        .doc(uid)
        .collection("message")
        .doc(widget.value)
        .collection('chat')
        .add({
      "name": username,
      "gender": gender,
      "message": _msgController.text,
      "time": DateTime.now(),
    });

    await DatabaseHelper.db
        .collection("doctorChatBox")
        .doc(widget.value)
        .collection("message")
        .doc(uid)
        .collection("chat")
        .add({
      "name": username,
      "message": _msgController.text,
      "time": DateTime.now(),
    });
    _msgController.clear();
  }
}
