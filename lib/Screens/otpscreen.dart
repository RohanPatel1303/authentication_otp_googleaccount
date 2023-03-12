import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:authentication_otp_googleaccount/Screens/homepage.dart';
import 'package:authentication_otp_googleaccount/Services/firebaseservices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  @override
  var verificationId=Get.arguments[0];
  var resendToken=Get.arguments[1];
  var phoneno=Get.arguments[2];
  late TextEditingController textEditingController1;

  String _comingSms = 'Unknown';

  Future<void> initSmsListener() async {

    String comingSms;
    try {
      comingSms = (await AltSmsAutofill().listenForSms)!;
    } on PlatformException {
      comingSms = 'Failed to get Sms.';
    }
    if (!mounted) return;
    setState(() {
      _comingSms = comingSms;
      print("====>Message: ${_comingSms}");
      print("${_comingSms[32]}");
      textEditingController1.text = _comingSms[0] + _comingSms[1] + _comingSms[2] + _comingSms[3]
          + _comingSms[4] + _comingSms[5]; //used to set the code in the message to a string and setting it to a textcontroller. message length is 38. so my code is in string index 32-37.
    });
  }
  @override
  void initState() {
    super.initState();
    textEditingController1 = TextEditingController();
    initSmsListener();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PinCodeTextField(
            appContext: context,
            pastedTextStyle: TextStyle(
              color: Colors.green.shade600,
              fontWeight: FontWeight.bold,
            ),
            length: 6,
            obscureText: false,
            pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(10),
                fieldHeight: 50,
                fieldWidth: 40,
                inactiveFillColor: Colors.white,
                inactiveColor: Colors.grey,
                selectedColor: Colors.grey,
                selectedFillColor: Colors.white,
                activeFillColor: Colors.white,
                activeColor: Colors.grey
            ),
            cursorColor: Colors.black,
            animationDuration: Duration(milliseconds: 300),
            enableActiveFill: true,
            controller: textEditingController1,
            keyboardType: TextInputType.number,
            boxShadows: const [
              BoxShadow(
                offset: Offset(0, 1),
                color: Colors.black12,
                blurRadius: 10,
              )
            ],
            onCompleted: (v)async {
          // FirebaseServices().verifyOtp(verificationId, textEditingController1.text, HomeScreen());
            },
            onChanged: (value) {
              setState(() {});
            },
          ),
          ElevatedButton(onPressed: (){
            FirebaseServices().verifyOtp(verificationId, textEditingController1.text, HomeScreen());
          }, child: Text("Verify")
          ),
          ElevatedButton(onPressed: (){
            FirebaseServices().resendOtp(resendToken,phoneno);

          }, child: Text("Resend Otp")
          )
        ],
      ),
    );
  }
}
