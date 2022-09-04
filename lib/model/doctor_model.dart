class DoctorModel {
  String? uid;
  String? name;
  String? gender;
  String? email;

  DoctorModel({this.uid, this.name, this.gender, this.email});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'uid': uid,
      'name': name,
      'gender': gender,
      'email': email,
    };
    return map;
  }

  factory DoctorModel.fromMap(Map<String, dynamic> map) => DoctorModel(
        uid: map['uid'],
        name: map['name'],
        gender: map['gender'],
        email: map['email'],
      );
}
