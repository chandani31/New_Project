import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdmart/pages/registrationPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fdmart/pages/otpPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Constants/textFormField.dart';
import 'otpScreen.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String _verificationId = '';
  TextEditingController mobileNoController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(height: 0,),
                Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.brown.withOpacity(0.9),
                    fontSize: 35,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5), // Shadow color
                        offset: Offset(2, 2), // Shadow offset
                        blurRadius: 5, // Shadow blur radius
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                myTextFormField(
                  controller: mobileNoController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                  ),
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter a valid mobile number';
                  //   }
                  //   return null;
                  // },
                  hintText: 'Mobile Number',
                  prefixIcon: Icon(Icons.phone),
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () {
                    String mobileNo = mobileNoController.text.toString();
                    if (_formKey.currentState!.validate()) {
                      print('Validating form...');
                      // sendOTP(mobileNo);
                      _verifyPhoneNumber();
                    }
                    else{
                      print('not Validating form...');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 20,),
                TextButton(
                    onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => registrationPage()));
                    }, child: Text("Don't have an account? Register", style: TextStyle(color: Colors.brown.withOpacity(0.9), fontSize: 16, fontWeight: FontWeight.bold))
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _verifyPhoneNumber() async {
    String phoneNumber = '+91${mobileNoController.text}'; // Add country code for India

    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
          Fluttertoast.showToast(msg: 'Verification completed successfully!');
          // Navigate to the next screen or perform desired action
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Verification Failed: $e");
          Fluttertoast.showToast(msg: 'Verification failed. Please try again.');
        },
        codeSent: (String verificationId, int? resendToken) {
          // Navigate to OTP screen passing verificationId
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                phoneNumber: phoneNumber,
                verificationId: verificationId,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle auto-retrieval timeout if needed
        },
        timeout: Duration(seconds: 60),
      );
    } catch (e) {
      print("Error verifying phone number: $e");
      Fluttertoast.showToast(msg: 'Error verifying phone number. Please try again.');
    }
  }


}
