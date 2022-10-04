import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlOpener{
  void openWhatsApp(BuildContext context,String phone) async
  {
    var whatsappUrl ="whatsapp://send?phone=$phone";
    await canLaunch(whatsappUrl)? launch(whatsappUrl):showSnackBar(context, 'WhatsApp Application is not found');
  }

 static void openFacebook(BuildContext context,String username) async
  {
    var facebookUrl ="http://fb.me/${username}";
    await canLaunch(facebookUrl)? launch(facebookUrl): showSnackBar(context, 'Facebook Application is not found');
  }

 static showSnackBar(BuildContext context, String error)
  {
    final snackBar = new SnackBar(content: new Text(error),
        backgroundColor: Colors.red);

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    Scaffold.of(context).showSnackBar(snackBar);

  }
}