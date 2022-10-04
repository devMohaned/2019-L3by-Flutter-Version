import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportScreen extends StatefulWidget {
  @override
  ReportScreenState createState() {
    // TODO: implement createState
    return ReportScreenState();
  }
}

class ReportScreenState extends State<ReportScreen> {
  final FocusNode _reportTitleFocusNode = FocusNode();
  final FocusNode _reportDescriptionFocusNode = FocusNode();

  TextEditingController _reportTitleController = new TextEditingController();
  TextEditingController _reportDescriptionController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: getToolbar(context),
      body: ListView(
        children: <Widget>[
          reportTitleField(),
          reportDescriptionField(),
        ],
      ),
    );
  }

  Widget reportTitleField() {
    return Container(
      child: TextField(
        controller: _reportTitleController,
        textInputAction: TextInputAction.next,
        onChanged: (String changedText) {},
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Title',
          labelText: 'Report Title',
        ),
        focusNode: _reportTitleFocusNode,
        onSubmitted: (term) {
          _fieldFocusChange(
              context, _reportTitleFocusNode, _reportDescriptionFocusNode);
        },
      ),
      margin: EdgeInsets.only(left: 12.0, right: 12.0),
    );
  }

  Widget reportDescriptionField() {
    return Container(
      child: TextField(
        controller: _reportDescriptionController,
        textInputAction: TextInputAction.next,
        onChanged: (String changedText) {},
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'There was some issue with...',
          labelText: 'Report Description',
        ),
        focusNode: _reportDescriptionFocusNode,
        onSubmitted: (term) {
          _fieldFocusChange(context, _reportDescriptionFocusNode, null);
        },
      ),
      margin: EdgeInsets.only(left: 12.0, right: 12.0),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  AppBar getToolbar(BuildContext _context) {
    return AppBar(
      automaticallyImplyLeading: true,
      title: Text('Make a Report'),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.done),
            onPressed: () => _launchURL(
                "talentsinstudio@gmail.com",
                _reportTitleController.text,
                _reportDescriptionController.text)),
      ],
    );
  }

  _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
