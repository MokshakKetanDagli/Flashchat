import 'package:flash_chat_app/constants.dart';
import 'package:flash_chat_app/mywidget/mybutton.dart';
import 'package:flash_chat_app/mywidget/mytextfield.dart';
import 'package:flash_chat_app/screens/chatscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_overlay/loading_overlay.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_screen';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isRegistering = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? newUserEmail;
  String? newUserPassword;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Register'),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: myLinearGradient),
        ),
      ),
      body: LoadingOverlay(
        isLoading: isRegistering,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'MyHero',
                    child: SizedBox(
                      height: size.height * 0.25,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  MyTextField(
                    size: size,
                    textField: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'New Email Address',
                        hintStyle: TextStyle(
                          fontSize: size.width * 0.05,
                          color: Colors.black,
                        ),
                      ),
                      onChanged: (emailValue) {
                        newUserEmail = emailValue;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  MyTextField(
                    size: size,
                    textField: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'New Password',
                        hintStyle: TextStyle(
                          fontSize: size.width * 0.05,
                          color: Colors.black,
                        ),
                      ),
                      onChanged: (passwordValue) {
                        newUserPassword = passwordValue;
                      },
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  MyButton(
                    size: size,
                    buttonType: 'Register',
                    myCallBack: () async {
                      setState(() {
                        isRegistering = true;
                      });
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                          email: newUserEmail.toString(),
                          password: newUserPassword.toString(),
                        );
                        // ignore: unnecessary_null_comparison
                        if (newUser != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('User Registered'),
                            ),
                          );
                          setState(() {
                            isRegistering = false;
                          });
                          emailController.clear();
                          passwordController.clear();
                          Navigator.pushNamed(context, ChatScreen.id);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('User Registeration Failed'),
                            ),
                          );
                          setState(() {
                            isRegistering = false;
                          });
                          emailController.clear();
                          passwordController.clear();
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                          setState(() {
                            isRegistering = false;
                          });
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                          setState(() {
                            isRegistering = false;
                          });
                          emailController.clear();
                          passwordController.clear();
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                        setState(() {
                          isRegistering = false;
                        });
                        emailController.clear();
                        passwordController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
