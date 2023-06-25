import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:voice_note/provider/google_sign_in_provider.dart';

class LoginWithSocialMedia extends StatelessWidget {
  const LoginWithSocialMedia({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            child: Image.asset('assets/image_login.png')),
        const SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              textAlign: TextAlign.left,
              text: const TextSpan(
                  text: 'Hey there\nWelcome Back\n',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white,
                      fontStyle: FontStyle.italic),
                  children: [
                    TextSpan(
                      text: '\nLogin to your account to continue...',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontStyle: FontStyle.italic),
                    )
                  ]),
            ),
          ),
        ),
        const SizedBox(height: 50),
        SizedBox(
          width: 220,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                maximumSize: const Size(double.infinity, 50)),
            label: const Text(
              'Sign Up with Google',
            ),
            icon: const FaIcon(
              FontAwesomeIcons.google,
              color: Color.fromARGB(255, 249, 94, 83),
            ),
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.googleLogin();
            },
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 220,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                maximumSize: const Size(double.infinity, 50)),
            label: const Text(
              'Sign Up with Apple',
            ),
            icon: const FaIcon(
              FontAwesomeIcons.apple,
              color: Colors.black87,
            ),
            onPressed: () {
              // final provider =
              //     Provider.of<GoogleSignInProvider>(context, listen: false);
              // provider.appleLogin();
            },
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 220,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                maximumSize: const Size(double.infinity, 50)),
            label: const Text(
              'Sign Up with Facebook',
            ),
            icon: const FaIcon(
              FontAwesomeIcons.facebook,
              color: Colors.blue,
            ),
            onPressed: () {
              // final provider =
              //     Provider.of<GoogleSignInProvider>(context, listen: false);
              // provider.facebookLogin();
            },
          ),
        ),
      ]),
    );
  }
}
// youtube link 
// https://www.youtube.com/watch?v=1k-gITZA9CI