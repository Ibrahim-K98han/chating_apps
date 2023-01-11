import 'package:flutter/foundation.dart';
import 'package:flutter_firebase/db/dbhelper.dart';

import '../models/message_model.dart';

class ChatRoomProvider extends ChangeNotifier {
  List<MessageModel> msgList = [];
  Future<void> addMsg(MessageModel messageModel) =>
      DBHelper.addMsg(messageModel);

  getAllChatRoomMessages() {
    DBHelper.getAllChatRoomMessages().listen((snapshot) {
      msgList = List.generate(snapshot.docs.length,
          (index) => MessageModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }
}
