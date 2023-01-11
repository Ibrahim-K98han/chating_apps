import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_firebase/auth/auth_service.dart';
import 'package:flutter_firebase/models/userModel.dart';
import 'package:flutter_firebase/pages/user_profile_page.dart';
import 'package:flutter_firebase/providers/user_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login_page';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool isLogin = true, isObscureText = true;
  final formKey = GlobalKey<FormState>();
  String errMsg = '';

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: formKey,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(10),
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  return null;
                },
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email),
                    filled: true,
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  return null;
                },
                controller: passController,
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                        icon: Icon(isObscureText
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => setState(() {
                              isObscureText = !isObscureText;
                            })),
                    filled: true,
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  isLogin = true;
                  authenticate();
                },
                child: Text('LOGIN'),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('New User?'),
                      TextButton(
                        onPressed: () {
                          isLogin = false;
                          authenticate();
                        },
                        child: Text('Register Here'),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ForgotPassword?'),
                      TextButton(
                        onPressed: () {},
                        child: Text('Click Here'),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                errMsg,
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
        ),
      ),
    );
  }

  authenticate() async {
    if (formKey.currentState!.validate()) {
      bool status;
      try {
        if (isLogin) {
          status = await AuthService.login(
              emailController.text, passController.text);
        } else {
          status = await AuthService.register(
              emailController.text, passController.text);
          await AuthService.sendVerificationMail();
          final userModel = UserModel(
              uid: AuthService.user!.uid, email: AuthService.user!.email);
          if (mounted) {
            await Provider.of<UserProvider>(context, listen: false)
                .addUser(userModel);
          }
        }
        if (status) {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, UserProgile.routeName);
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          errMsg = e.message!;
        });
      }
    }
  }
}
