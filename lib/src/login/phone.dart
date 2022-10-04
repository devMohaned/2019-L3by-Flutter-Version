import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/providers/verification_provider.dart';

class PhoneScreen extends StatelessWidget {

  final FocusNode _phoneNumberFocus = FocusNode();
  final FocusNode _codeNumberFocus = FocusNode();

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);


    return Container(
      padding: EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(margin: EdgeInsets.only(top: 30.0)),
          phoneNumberField(bloc),
          Container(margin: EdgeInsets.only(top: 8.0)),
          codeNumberField(bloc),
          Container(margin: EdgeInsets.only(top: 8.0)),
          verifyButton(bloc),
        ],
      ),
    );
  }

  Widget phoneNumberField(bloc) {
    return StreamBuilder(
      stream: bloc.verifyPhoneNumber,
      builder: (context, snapshot) {
        return TextField(
          textInputAction: TextInputAction.next,
          onChanged: bloc.changeVerifyPhoneNumber,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: '+20 0115 748 1819',
            labelText: 'Phone Number',
            errorText: snapshot.error,
          ),
          focusNode: _phoneNumberFocus,
          onSubmitted: (term) {
            _fieldFocusChange(context, _phoneNumberFocus, _codeNumberFocus);
          },
        );
      },
    );
  }

  Widget codeNumberField(bloc) {
    return StreamBuilder(
      stream: bloc.verifyCodeNumber,
      builder: (context, snapshot) {
        return TextField(
          textInputAction: TextInputAction.next,
          onChanged: bloc.changeVerifyCodeNumber,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: '123456',
            labelText: 'Code',
            errorText: snapshot.error,
          ),
          focusNode: _codeNumberFocus,
          onSubmitted: (term) {
            _fieldFocusChange(context, _codeNumberFocus, null);
          },
        );
      },
    );
  }

  Widget verifyButton(bloc) {
    return StreamBuilder(
      stream: bloc.verifyPhoneNumber,
      builder: (context, snapshot) {
        return RaisedButton(
          child: Text('Verify'),
          /*  color: Colors.blue[700],
          textColor: Colors.white,*/
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)),
          onPressed: snapshot.hasData ? bloc.sendCodeToPhoneNumber : null,
        );
      },
    );
  }
}