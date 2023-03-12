import 'package:authentication_otp_googleaccount/Screens/otpscreen.dart';
import 'package:authentication_otp_googleaccount/Services/firebaseservices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/imageconstants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  TextEditingController countryController= TextEditingController();
  TextEditingController phonenocontroller=TextEditingController();
  Widget build(BuildContext context) {
    var ssize=MediaQuery.of(context).size;
    reqOTP()async{
      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "${countryController.text}+${phonenocontroller.text}",
          verificationCompleted: (credential)async{
          print("From Verification Completed");
          print(credential.smsCode);
          await FirebaseAuth.instance.signInWithCredential(credential);
          },
          verificationFailed: (e){
          print("From Verification Failed");
          print(e);
          },
          codeSent:(verificationId,resendToken){
          print(verificationId);
          Get.to(OtpVerificationScreen(),arguments: [verificationId]);

          },
          codeAutoRetrievalTimeout: (verificationId){

          }
      );



    }
    countryController.text="+91";
    return Scaffold(

      appBar: AppBar(title: const Text("Login Screen"),),
      body:
      Container(

        height: ssize.height,
        width: ssize.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(left: 10,right: 10),
            child: Column(
              children: [
                Container(
                  height: ssize.height*0.3,
                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(loginimg))),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 40,
                        child:
                        TextField(
                          controller: countryController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Text(
                        "|",
                        style: TextStyle(fontSize: 33, color: Colors.grey),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: TextField(
                            controller: phonenocontroller,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Phone",
                            ),
                          ))
                    ],
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: const [
                //     Text("Change Number")
                //   ],
                // ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ButtonStyle(elevation: MaterialStateProperty.all(10),minimumSize: MaterialStateProperty.all(Size(ssize.width*0.5, 40))),

                    onPressed: ()=>{FirebaseServices().sendOtp(countryController.text+phonenocontroller.text, OtpVerificationScreen())},
                    child: Text("Login")
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Divider(
                        height: 20,
                        color: Colors.black,

                      ),
                    ),
                    Text("Or"),
                    Expanded(
                      child: Divider(
                        height: 20,
                        color: Colors.black,

                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                    onTap:()async{
                      FirebaseServices().signInGoogle();
                    },
                    child: Image(image: AssetImage(google),height: 40,width: 40,)
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
