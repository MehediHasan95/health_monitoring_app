class UserProfileModel {
  String? username;
  String? gender;

  UserProfileModel({this.username, this.gender});

  Map<String, dynamic> toJson() => <String, dynamic>{
        'username': username,
        'gender': gender,
      };

  factory UserProfileModel.fromMap(Map<String, dynamic> map) =>
      UserProfileModel(
        username: map['username'],
        gender: map['gender'],
      );
}
