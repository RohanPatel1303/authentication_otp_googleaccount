import 'package:authentication_otp_googleaccount/Services/firebaseservices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? phonenumber="Empty";

  @override
  void initState(){
    super.initState();
    FirebaseAuth auth=FirebaseAuth.instance;
    if(auth.currentUser?.uid!=null){
      if(auth.currentUser?.phoneNumber!=null){
        phonenumber=auth.currentUser?.phoneNumber;
        print(phonenumber);
      }
      else{
        phonenumber=auth.currentUser?.email;
        print(phonenumber);
      }
    }
  }
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Home Screen"),),
      body: Column(
        children: [
          phonenumber!=null?Text(phonenumber!):Text("No Data"),
          ElevatedButton(onPressed:(){FirebaseServices().logout();}, child: Text("Log Out"))
        ],
      ),
    );
  }
}
