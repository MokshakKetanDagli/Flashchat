import 'package:flash_chat_app/constants.dart';
import 'package:flash_chat_app/mywidget/mybutton.dart';
import 'package:flash_chat_app/screens/chatscreen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_app/mywidget/mytextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVerifying = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? existingUserEmail;
  String? existingUserPassword;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login'),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: myLinearGradient),
        ),
      ),
      body: LoadingOverlay(
        isLoading: isVerifying,
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
                      width: size.width * 0.50,
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
                        hintText: 'Email Address',
                        hintStyle: TextStyle(
                          fontSize: size.width * 0.05,
                          color: Colors.black,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (emailValue) {
                        existingUserEmail = emailValue;
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  MyTextField(
                    size: size,
                    textField: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          fontSize: size.width * 0.05,
                          color: Colors.black,
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      onChanged: (passwordValue) {
                        existingUserPassword = passwordValue;
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  MyButton(
                    size: size,
                    buttonType: 'Login',
                    myCallBack: () async {
                      setState(() {
                        isVerifying = true;
                      });
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: existingUserEmail.toString(),
                            password: existingUserPassword.toString());
                        // ignore: unnecessary_null_comparison
                        if (user != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Log In Successful'),
                            ),
                          );
                          setState(() {
                            isVerifying = false;
                          });
                          emailController.clear();
                          passwordController.clear();
                          Navigator.pushNamed(context, ChatScreen.id);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Log In Failed'),
                            ),
                          );

                          setState(() {
                            isVerifying = false;
                          });
                          emailController.clear();
                          passwordController.clear();
                        }
                      } catch (e) {
                        setState(() {
                          isVerifying = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
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
