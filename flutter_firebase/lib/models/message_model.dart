import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  int? msgId;
  String? userUid;
  String msg;
  Timestamp timestamp;
  String? image;

  MessageModel(
      {this.msgId,
      this.userUid,
      required this.msg,
      required this.timestamp,
      this.image});

  Map<String, dynamic> toMap() {
    return {
      'msgId': msgId,
      'userUid': userUid,
      'msg': msg,
      'timestamp': timestamp,
      'image': image,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) => MessageModel(
        msgId: map['msgId'],
        userUid: map['userUid'],
        msg: map['msg'],
        timestamp: map['timestamp'],
        image: map['image'],
      );
}
