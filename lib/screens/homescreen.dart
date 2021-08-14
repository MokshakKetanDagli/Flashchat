import 'package:flash_chat_app/constants.dart';
import 'package:flash_chat_app/mywidget/mybutton.dart';
import 'package:flash_chat_app/screens/loginscreen.dart';
import 'package:flash_chat_app/screens/registerscreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation colorAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    colorAnimation =
        ColorTween(begin: Colors.orange.shade300, end: Colors.white)
            .animate(animationController);
    animationController.addListener(
      () {
        setState(() {});
      },
    );
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colorAnimation.value,
      appBar: AppBar(
        title: Text('Flash Chat'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: myLinearGradient),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'MyHero',
                    child: SizedBox(
                      height: size.height * 0.15,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  DefaultTextStyle(
                    style: GoogleFonts.roboto(
                      fontSize: size.width * 0.1,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    child: AnimatedTextKit(
                      totalRepeatCount: 3,
                      animatedTexts: [
                        TypewriterAnimatedText('Flash Chat'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              MyButton(
                size: size,
                buttonType: 'Login',
                myCallBack: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              MyButton(
                size: size,
                buttonType: 'Register',
                myCallBack: () {
                  Navigator.pushNamed(context, RegisterScreen.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
