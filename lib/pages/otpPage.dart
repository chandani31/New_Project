import 'package:fdmart/Constants/textFormField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fdmart/pages/homePage.dart'; // Import your home page
import 'package:fdmart/pages/signUpPage.dart'; // Import your registration page

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  OtpPage({required this.phoneNumber, required this.verificationId});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController _smsController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 150,),
            myTextFormField(
              controller: _smsController,
              // validator: (value) {
              //   if (value!.isEmpty) {
              //     return "Enter OTP";
              //   }
              //   return "";
              // },
              decoration: InputDecoration(),
              hintText: "Enter OTP",
              prefixIcon: Icon(Icons.message),
            ),
            ElevatedButton(
              onPressed: () {
                _signInWithOTP();
              },
              child: Text('Submit OTP'),
            ),
          ],
        ),
      ),
    );
  }

  void _signInWithOTP() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _smsController.text,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      // Check if the user is already registered
      if (user != null) {
        // User is already registered, navigate to home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // User is not registered, navigate to registration page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignUpPage()),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
