import 'package:authentication_otp_googleaccount/Screens/homepage.dart';
import 'package:authentication_otp_googleaccount/Screens/loginscreen.dart';
import 'package:authentication_otp_googleaccount/Screens/otpscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices{
  FirebaseAuth auth=FirebaseAuth.instance;

  sendOtp(String phonenumber,Widget redirectScreen)async
  {
    auth.verifyPhoneNumber(
        phoneNumber: phonenumber, 
        verificationCompleted: (credential)async{

        },
        verificationFailed:(e){
          Get.snackbar("Error", e.message.toString());
        },
        codeSent: (verificationId,resendToken){
          const CircularProgressIndicator();
          Get.off(const OtpVerificationScreen(),arguments: [verificationId,resendToken,phonenumber]);
        },
        codeAutoRetrievalTimeout: (verificationId){
          
        }
    );
  }
  verifyOtp(String verificationId,String smsCode,Widget redirectScreen) async {
   await auth.signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode)).then((value) => Get.off(const HomeScreen())).catchError((onError){Get.snackbar("Error", onError);});


  }
  resendOtp(token,phoneno)async{
    await auth.verifyPhoneNumber(
      phoneNumber: phoneno,
        verificationCompleted: (credential){},
        verificationFailed:(e){Get.snackbar("Error", e.message.toString());} ,
        codeSent: (verificationId,resendToken){
          print("the Code is Sent again");
        },
        codeAutoRetrievalTimeout: (verificationID){},
      forceResendingToken:token,
    );
  }
  signInGoogle()async{
    try{
      final GoogleSignInAccount? userAccount=await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleSignInAuthentication=await userAccount?.authentication;
      final credential=GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );
      return await auth.signInWithCredential(credential).then((value) => Get.off(HomeScreen())).catchError((onError){Get.snackbar("Error", onError.toString());});

    }on FirebaseAuthException catch(e){
      Get.snackbar("error", e.message.toString());
      throw e;
    }
  }
  logout(){
    auth.signOut();
    Get.offAll(const LoginScreen());
  }

}