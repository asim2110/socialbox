// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? msg;
  String? senderID;
  Timestamp? time;
  String? msgID;
  String? imageUrl;
  String? audioUrl;
  String? type;
  MessageModel({
    this.msg,
    this.senderID,
    this.time,
    this.msgID,
    this.imageUrl,
    this.audioUrl,
    this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'msg': msg,
      'senderID': senderID,
      'time': time,
      'msgID': msgID,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'type': type,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      msg: map['msg'] != null ? map['msg'] as String : null,
      senderID: map['senderID'] != null ? map['senderID'] as String : null,
      time: map['time'],
      msgID: map['msgID'] != null ? map['msgID'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      audioUrl: map['audioUrl'] != null ? map['audioUrl'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
