import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class FriendsModel {
  String? Name;
  String? id;
  String? Gmail;
  String? FriendId;
  String? profile;
  FriendsModel({
    this.Name,
    this.id,
    this.Gmail,
    this.FriendId,
    this.profile,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Name': Name,
      'id': id,
      'Gmail': Gmail,
      'FriendId': FriendId,
      'profile': profile,
    };
  }

  factory FriendsModel.fromMap(Map<String, dynamic> map) {
    return FriendsModel(
      Name: map['Name'] != null ? map['Name'] as String : null,
      id: map['id'] != null ? map['id'] as String : null,
      Gmail: map['Gmail'] != null ? map['Gmail'] as String : null,
      FriendId: map['FriendId'] != null ? map['FriendId'] as String : null,
      profile: map['profile'] != null ? map['profile'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FriendsModel.fromJson(String source) =>
      FriendsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
