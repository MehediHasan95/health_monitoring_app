class DoctorModel {
  String? uid;
  String? name;
  String? gender;
  String? email;
  String? specialist;
  String? hospital;
  String? degree;

  DoctorModel(
      {this.uid,
      this.name,
      this.gender,
      this.email,
      this.specialist,
      this.hospital,
      this.degree});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'uid': uid,
      'name': name,
      'gender': gender,
      'email': email,
      'specialist': specialist,
      'hospital': hospital,
      'degree': degree,
    };
    return map;
  }

  factory DoctorModel.fromMap(Map<String, dynamic> map) => DoctorModel(
        uid: map['uid'],
        name: map['name'],
        gender: map['gender'],
        email: map['email'],
        specialist: map['specialist'],
        hospital: map['hospital'],
        degree: map['degree'],
      );
}
