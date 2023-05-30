import 'package:flutter/material.dart';
import 'package:p_14_messanger/screens/about_channel.dart';
import 'package:p_14_messanger/screens/chat_screen.dart';
import 'package:p_14_messanger/screens/home_screen.dart';
import 'package:p_14_messanger/screens/login_screen.dart';
import 'package:p_14_messanger/screens/sell_screen.dart';

kNavigator(BuildContext context, String status) {
  if (status == 'chat') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const ChatScreen();
        },
      ),
    );
  }else if(status == 'ChannelAbout') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const ChannelAbout();
        },
      ),
    );
  }else  if(status == 'SellScreen'){

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const SellScreen();
        },
      ),
    );

  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          if (status == 'login') {
            return const LoginScreen();
          } else if (status == 'home') {
            return const HomeScreen();
          } else {
            return const HomeScreen();
          }
        },
      ),
    );
  }
}
