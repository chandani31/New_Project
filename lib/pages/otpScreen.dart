import 'package:fdmart/Constants/textFormField.dart';
import 'package:fdmart/pages/registrationPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'homePage.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  OTPScreen({required this.phoneNumber, required this.verificationId});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  late String _smsCode;
  bool _isVerifying = false;

  void _verifyOTP() async {
    setState(() {
      _isVerifying = true;
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _smsCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      setState(() {
        _isVerifying = false;
      });

      Fluttertoast.showToast(
        msg: 'OTP is correct!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } catch (e) {
      setState(() {
        _isVerifying = false;
      });

      print("Error verifying OTP: $e");
      Fluttertoast.showToast(
        msg: 'Incorrect OTP. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => registrationPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 150,),
            Text(
              'Enter the OTP sent to ${widget.phoneNumber}',
              style: TextStyle(
                color: Colors.brown.withOpacity(0.9),
                fontSize: 20,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.2), // Shadow color
                    offset: Offset(2, 2), // Shadow offset
                    blurRadius: 5, // Shadow blur radius
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            myTextFormField(
              onChanged: (value) {
                _smsCode = value.trim();
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
              ), hintText: 'OTP',
              prefixIcon: Icon(Icons.textsms_rounded, color: Colors.black,),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isVerifying ? null : _verifyOTP,
              child: _isVerifying
                  ? CircularProgressIndicator()
                  : Text('Verify OTP', style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown.withOpacity(0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
