import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/message_model.dart';

class MessageItem extends StatelessWidget {
  final MessageModel messageModel;
  const MessageItem({Key? key, required this.messageModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: ,
            )
          ],
        ),
      ),
    );
  }
}
