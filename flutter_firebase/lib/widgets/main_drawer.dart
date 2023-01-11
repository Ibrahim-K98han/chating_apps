import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_firebase/auth/auth_service.dart';
import 'package:flutter_firebase/pages/chat_room_page.dart';
import 'package:flutter_firebase/pages/launcher_page.dart';
import 'package:flutter_firebase/pages/login_page.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 200,
            color: Colors.blue,
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(context, ChatRoomPage.routeName);
            },
            leading: Icon(Icons.chat),
            title: Text('Chat Room'),
          ),
          ListTile(
            onTap: () async {
              await AuthService.logout();
              Navigator.pushReplacementNamed(context, LauncherPage.routeName);
            },
            leading: Icon(Icons.logout),
            title: Text('LOGOUT'),
          ),
        ],
      ),
    );
  }
}
