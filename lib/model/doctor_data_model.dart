class DoctorDataModel {
  String? uid;
  String? name;
  String? email;
  String? specialist;

  DoctorDataModel({
    this.uid,
    this.name,
    this.email,
    this.specialist,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'uid': uid,
        'name': name,
        'email': email,
        'specialist': specialist,
      };

  factory DoctorDataModel.fromMap(Map<String, dynamic> map) => DoctorDataModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      specialist: map['specialist']);
}
