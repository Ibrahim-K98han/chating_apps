import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_firebase/auth/auth_service.dart';
import 'package:flutter_firebase/models/userModel.dart';
import 'package:flutter_firebase/providers/user_provider.dart';
import 'package:flutter_firebase/widgets/main_drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserProgile extends StatefulWidget {
  static const String routeName = '/user_page';
  const UserProgile({super.key});

  @override
  State<UserProgile> createState() => _UserProgileState();
}

class _UserProgileState extends State<UserProgile> {
  final txtController = TextEditingController();
  @override
  void dispose() {
    txtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: Center(
        child: Consumer<UserProvider>(
          builder: (context, provider, _) =>
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: provider.getUserByUid(
              AuthService.user!.uid,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userModel = UserModel.fromMap(snapshot.data!.data()!);
                provider.userModel = userModel;
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListView(
                    children: [
                      Center(
                        child: userModel.image == null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  'images/placeholder.jpg',
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.network(
                                  userModel.image!,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: Text('Change Image'),
                        onPressed: _updateImage,
                      ),
                      const Divider(
                        color: Colors.grey,
                        height: 1,
                      ),
                      ListTile(
                        title: Text(userModel.name ?? 'No Display Name'),
                        trailing: const Icon(Icons.edit),
                        onTap: () {
                          showInputDialog('Display Name', userModel.name,
                              (value) {
                            provider.updatProfile(
                                AuthService.user!.uid, {'name': value});
                          });
                        },
                      ),
                      ListTile(
                        title: Text(userModel.mobile ?? 'No Mobile Number'),
                        trailing: const Icon(Icons.edit),
                        onTap: () {
                          showInputDialog(
                              'Display Mobile Number', userModel.mobile,
                              (value) {
                            provider.updatProfile(
                                AuthService.user!.uid, {'mobile': value});
                          });
                        },
                      ),
                      ListTile(
                        title: Text(userModel.email ?? 'No Email Address'),
                        trailing: const Icon(Icons.edit),
                        onTap: () {
                          showInputDialog(
                              'Display Email Address', userModel.email,
                              (value) {
                            provider.updatProfile(
                                AuthService.user!.uid, {'email': value});
                          });
                        },
                      ),
                    ],
                  ),
                );
              }
              if (snapshot.hasError) {
                return const Text('Failed to featch data');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  void _updateImage() async {
    final xFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 75);
    if (xFile != null) {
      try {
        final downloadUrl =
            await Provider.of<UserProvider>(context, listen: false)
                .updateImage(xFile);
        await Provider.of<UserProvider>(context, listen: false)
            .updatProfile(AuthService.user!.uid, {'image': downloadUrl});
      } catch (e) {
        rethrow;
      }
    }
  }

  showInputDialog(String title, String? value, Function(String) onsaved) {
    txtController.text = value ?? '';
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: txtController,
                  decoration: InputDecoration(hintText: 'Enter $title'),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () {
                    onsaved(txtController.text);
                    Navigator.pop(context);
                  },
                  child: Text('UPDATE'),
                )
              ],
            ));
  }
}
