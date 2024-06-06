import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class NotificationModel {
  String? profile;
  String? title;
  String? body;
  String? nid;
  NotificationModel({
    this.profile,
    this.title,
    this.body,
    this.nid,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'profile': profile,
      'title': title,
      'body': body,
      'nid': nid,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      profile: map['profile'] != null ? map['profile'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      body: map['body'] != null ? map['body'] as String : null,
      nid: map['nid'] != null ? map['nid'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) => NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
