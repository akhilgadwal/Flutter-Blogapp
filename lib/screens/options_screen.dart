import 'package:exblogapp/components/round_button.dart';
import 'package:exblogapp/screens/login_screen.dart';
import 'package:exblogapp/screens/sign_in.dart';
import 'package:flutter/material.dart';

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({super.key});

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/assets/images/blogapplogo.png'),
              const SizedBox(
                height: 20,
              ),
              Roundbuttons(
                  onpress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  text: 'Login'),
              const SizedBox(
                height: 20,
              ),
              Roundbuttons(
                  onpress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Signin(),
                      ),
                    );
                  },
                  text: 'REGISTER'),
            ],
          ),
        ),
      ),
    );
  }
}
