import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_firebase/providers/chat_room_provider.dart';
import 'package:provider/provider.dart';

class ChatRoomPage extends StatefulWidget {
  static const String routeName = '/chat_page';
  const ChatRoomPage({super.key});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final msgController = TextEditingController();
  @override
  void dispose() {
    msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ChatRoomProvider>(
        builder:(context, provider,_)=> Column(
          children: [
            Expanded(child: ListView.builder(
              itemCount: provider.msgList.length,
              itemBuilder: (context, index){
                final msg = provider.msgList[index];

              },
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: msgController,
                      decoration: InputDecoration(
                          fillColor: Colors.grey,
                          focusColor: Colors.grey,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16))),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        provider.addMsg(msgController.text);
                        msgController.clear();
                      },
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).primaryColor,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
