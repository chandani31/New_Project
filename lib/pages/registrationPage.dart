import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdmart/pages/signUpPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Constants/textFormField.dart';

class registrationPage extends StatefulWidget {

  @override
  State<registrationPage> createState() => _registrationPageState();
}

class _registrationPageState extends State<registrationPage> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 120,),
                Text(
                  "Registration",
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
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                  ),
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter a valid mobile number';
                  //   }
                  //   return null;
                  // },
                  hintText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
                myTextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                  ),
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter a valid mobile number';
                  //   }
                  //   return null;
                  // },
                  hintText: 'EmailID',
                  prefixIcon: Icon(Icons.email),
                ),
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
                myTextFormField(
                  controller: addressController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                  ),
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter a valid mobile number';
                  //   }
                  //   return null;
                  // },
                  hintText: 'Address',
                  prefixIcon: Icon(Icons.message),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Extract data from controllers
                      String name = nameController.text;
                      String email = emailController.text;
                      String mobileNo = mobileNoController.text;
                      String address = addressController.text;
        
                      // Call function to perform registration with the extracted data
                      _registerUser(name, email, mobileNo,address);
                    }
                    else {
                      print('Form validation failed...');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown.withOpacity(0.5),
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
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                    }, child: Text("Already have an account? Login", style: TextStyle(color: Colors.brown.withOpacity(0.9), fontSize: 16, fontWeight: FontWeight.bold))
          ),
        
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _registerUser(String name, String email, String mobileNo, String address) async {
    try {
      // Use FirebaseAuth to create a new user with email and password
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: 'randomPassword', // You can generate a random password or ask the user to input it
      );

      // Get the newly created user
      User? user = userCredential.user;

      // Now, you can store additional user information like name and address in your database
      // For simplicity, let's print the user information for now
      print('User registered successfully:');
      print('Name: $name');
      print('Email: $email');
      print('Address: $address');

      // Save to Firebase Firestore
      final FirebaseFirestore _firebasefirestore = FirebaseFirestore.instance;

      await _firebasefirestore.collection("users").doc(user!.uid).set({
        'email': email,
        'name': name,
        'address': address,
        'mobileNo': mobileNo,
      });


      // Navigate to the next screen after successful registration
      // You can navigate to the home screen or any other screen here
      // For example:
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } catch (e) {
      print('Error registering user: $e');
      // Handle registration errors here
    }
  }

}
