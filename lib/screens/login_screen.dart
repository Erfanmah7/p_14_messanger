import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p_14_messanger/widgets/functions.dart';
import 'package:p_14_messanger/widgets/constants.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();

  TextEditingController valCodeController = TextEditingController();

  //نمایش تکست فیلد کد
  bool isWaitingForCode = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  //codSent => global myVerificationId = verificationId
  String myVerificationId = '-1';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      if (auth.currentUser != null) HomeScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 45,
                child: TextField(
                  controller: phoneController,
                  decoration: kMyInputDecoration.copyWith(
                    hintText: 'Phone No.',
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Visibility(
                visible: isWaitingForCode,
                child: SizedBox(
                  height: 45,
                  child: TextField(
                    controller: valCodeController,
                    decoration: kMyInputDecoration.copyWith(
                      hintText: 'Code',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.purple),
                onPressed: onButtonPressed,
                child: Text(!isWaitingForCode ? 'Send Code' : 'Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onButtonPressed() async {
    String phone = phoneController.text;
    String code = valCodeController.text;

    if (isWaitingForCode == false) {
      //تایید شد
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: kMyPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        //تایید نشد
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          } else {
            print(e);
          }
        },
        //کد فرستاده شده
        codeSent: (String verificationId, int? resendToken) {
          setState(
            () {
              isWaitingForCode = true;
            },
          );
          myVerificationId = verificationId;
        },
        //زمان بازیابی خودکار کد
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } else {
      if (myVerificationId != '-1') {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            //شناسه تأیید
            verificationId: myVerificationId,
            smsCode: code);
        UserCredential userCredential =
            await auth.signInWithCredential(credential);
        print(userCredential.credential);
        if (auth.currentUser != null) {
          kNavigator(context, 'home');
        }
      } else {
        print('is not code');
      }
    }
  }
}
