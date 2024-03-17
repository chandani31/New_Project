import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdmart/pages/registrationPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fdmart/pages/otpPage.dart';
import '../Constants/textFormField.dart';

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
      backgroundColor: Colors.grey.withOpacity(0.9),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                    _verifyPhone();
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
    );
  }

  // Future<void> _verifyPhone() async {
  //   try {
  //     final formattedPhoneNumber =
  //         '+91' + mobileNoController.text.toString(); // Use the desired country code
  //
  //     await _auth.verifyPhoneNumber(
  //       phoneNumber: formattedPhoneNumber,
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         await _auth.signInWithCredential(credential);
  //         // Optionally, navigate to the next screen here
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         print('Verification failed: ${e.message}');
  //       },
  //       codeSent: (String verificationId, int? resendToken) {
  //         print('Code sent. Verification ID: $verificationId');
  //         setState(() {
  //           _verificationId = verificationId;
  //         });
  //         // Navigate to the OTP page
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => OtpPage(
  //               phoneNumber: formattedPhoneNumber,
  //               verificationId: verificationId,
  //             ),
  //           ),
  //         );
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {
  //         print('Auto retrieval timed out');
  //       },
  //     );
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  Future<void> sendOTP(String mobileNo) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Query Firestore to check if the mobile number exists
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('users')
        .where('mobileNo', isEqualTo: mobileNo)
        .get();

    // Check if any documents were returned (i.e., mobile number is registered)
    if (snapshot.docs.isNotEmpty) {
      try {
        // Send OTP using Firebase Authentication
        await auth.verifyPhoneNumber(
          phoneNumber: mobileNo,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
            // OTP verification completed automatically
          },
          verificationFailed: (FirebaseException e) {
            print("Verification failed: ${e.message}");
            // Handle verification failure
          },
          codeSent: (String verificationID, int? resendToken) {
            print("Verification code sent. VerificationID: $verificationID");
            // Handle OTP code sent
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            print("Auto retrieval timeout. VerificationID: $verificationId");
            // Handle auto retrieval timeout
          },
          timeout: Duration(seconds: 60), // Timeout duration for OTP code
        );
      } catch (e) {
        print("Error sending OTP: $e");
        // Handle error sending OTP
      }
    } else {
      // Phone number is not registered
      print("Phone number is not registered");
    }
  }

  Future<void> _verifyPhone() async {
    try {
      final formattedPhoneNumber = '+91' + mobileNoController.text.toString();

    // Use the desired country code

      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
          });
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
            return OtpPage(phoneNumber: formattedPhoneNumber, verificationId: _verificationId,);
          },));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('Auto retrieval timed out');
        },
      );
    } catch (e) {
      print('Error: $e');
    }
  }


}
