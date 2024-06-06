import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class RequestModel {
  String? receiverId;
  String? requestId;
  String? senderId;
  String? senderName;
  String? senderGmail;
  bool? status;
  String? Senderprofile;
  RequestModel({
    this.receiverId,
    this.requestId,
    this.senderId,
    this.senderName,
    this.senderGmail,
    this.status,
    this.Senderprofile,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'receiverId': receiverId,
      'requestId': requestId,
      'senderId': senderId,
      'senderName': senderName,
      'senderGmail': senderGmail,
      'status': status,
      'Senderprofile': Senderprofile,
    };
  }

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      receiverId:
          map['receiverId'] != null ? map['receiverId'] as String : null,
      requestId: map['requestId'] != null ? map['requestId'] as String : null,
      senderId: map['senderId'] != null ? map['senderId'] as String : null,
      senderName:
          map['senderName'] != null ? map['senderName'] as String : null,
      senderGmail:
          map['senderGmail'] != null ? map['senderGmail'] as String : null,
      status: map['status'] != null ? map['status'] as bool : null,
      Senderprofile:
          map['Senderprofile'] != null ? map['Senderprofile'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RequestModel.fromJson(String source) =>
      RequestModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
