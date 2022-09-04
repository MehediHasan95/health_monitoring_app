class UserProfileModel {
  String? username;
  String? email;
  String? gender;
  String? uid;
  DateTime? birthday;

  UserProfileModel({
    this.username,
    this.email,
    this.gender,
    this.uid,
    this.birthday,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'username': username,
        'email': email,
        'gender': gender,
        'uid': uid,
        'birthday': birthday,
      };

  UserProfileModel.fromSnapshot(snapshot)
      : username = snapshot.data()['username'],
        email = snapshot.data()['email'],
        gender = snapshot.data()['gender'],
        uid = snapshot.data()['uid'],
        birthday = snapshot.data()['birthday'].toDate();
}
