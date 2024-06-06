// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UsersModel {
  String? Name;
  String? Gmail;
  String? Phone;
  String? Password;
  String? UserId;
  String? profile;
  String? token;
  UsersModel({
    this.Name,
    this.Gmail,
    this.Phone,
    this.Password,
    this.UserId,
    this.profile,
    this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Name': Name,
      'Gmail': Gmail,
      'Phone': Phone,
      'Password': Password,
      'UserId': UserId,
      'profile': profile,
      'token': token,
    };
  }

  factory UsersModel.fromMap(Map<String, dynamic> map) {
    return UsersModel(
      Name: map['Name'] != null ? map['Name'] as String : null,
      Gmail: map['Gmail'] != null ? map['Gmail'] as String : null,
      Phone: map['Phone'] != null ? map['Phone'] as String : null,
      Password: map['Password'] != null ? map['Password'] as String : null,
      UserId: map['UserId'] != null ? map['UserId'] as String : null,
      profile: map['profile'] != null ? map['profile'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UsersModel.fromJson(String source) =>
      UsersModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
