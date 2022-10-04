import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  PrivacyPolicyState createState() {
    return PrivacyPolicyState();
  }
}

class PrivacyPolicyState extends State<PrivacyPolicy> {
  String lines = 'Loading';

  @override
  void initState() {
    getFileLines();
  }

  @override
  Widget build(BuildContext context) {
    return buildList(context);
  }

  Widget buildList(BuildContext context) {
    return Scaffold(
      appBar: getToolbar(),
      body: ListView(
        children: <Widget>[
          Text('${lines}'),
        ],
      ),
    );
  }

  AppBar getToolbar() {
    return AppBar(
      automaticallyImplyLeading: true,
      title: Text('Privacy Policy'),
    );
  }

  getFileLines() async {
    String path = 'privacy_policy';
    ByteData data = await rootBundle.load('assets/$path.txt');
    String directory = (await getTemporaryDirectory()).path;
    File file = await writeToFile(data, '$directory/$path.txt');
    var privacyLines = await file.readAsString();
    this.lines = privacyLines.toString();
    setState(() {});
  }

  Future<File> writeToFile(ByteData data, String path) {
    ByteBuffer buffer = data.buffer;
    return File(path).writeAsBytes(buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    ));
  }
}
