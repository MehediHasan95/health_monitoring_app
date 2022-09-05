class DoctorAdviceModel {
  String? doctorName;
  String? doctorGender;
  String? message;

  DateTime? time;

  DoctorAdviceModel({
    this.doctorName,
    this.doctorGender,
    this.message,
    this.time,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'doctorName': doctorName,
        'doctorID': doctorGender,
        'message': message,
        'time': time,
      };

  DoctorAdviceModel.fromSnapshot(snapshot)
      : doctorName = snapshot.data()['doctorName'],
        doctorGender = snapshot.data()['doctorGender'],
        message = snapshot.data()['message'],
        time = snapshot.data()['time'].toDate();
}
