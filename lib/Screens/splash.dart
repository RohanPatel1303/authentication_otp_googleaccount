import 'dart:async';
import 'package:authentication_otp_googleaccount/Screens/homepage.dart';
import 'package:authentication_otp_googleaccount/Screens/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  FirebaseAuth auth =FirebaseAuth.instance;
  void initState(){
    super.initState();
    Timer(const Duration(seconds: 3), () {
      checkExistingUser();
    });
  }
  checkExistingUser(){
    if(auth.currentUser?.uid==null){
      Get.off(const LoginScreen());
    }
    else{
      Get.off(HomeScreen());
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.blue
        ),
      ),
    );
  }
}
