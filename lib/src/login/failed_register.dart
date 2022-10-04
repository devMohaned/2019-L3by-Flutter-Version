import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/providers/homepage_provider.dart';
import 'package:flutter_games_exchange/providers/registeration_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_games_exchange/src/homepage/homepage.dart';

class FailedRegisterScreen extends StatelessWidget {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();


  String email;
  FailedRegisterScreen(this.email);

  @override
  Widget build(BuildContext context) {
    final bloc = RegisterProvider.of(context);
    return _getLandingPage(bloc);
  }

  Widget failedToRegisterText() {
    return Center(
        child: Text(
            'Could not send your data to the server, please insert your data again.'));
  }

  Widget working(bloc) {
    return StreamBuilder(
      stream: bloc.regEmail,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeRegEmail,
          keyboardType: TextInputType.emailAddress,
          /* decoration: InputDecoration(
            icon: new Icon(Icons.mail_outline),
            hintText: 'you@example.com',
            labelText: 'Email Address',
            errorText: snapshot.error,
          ),*/
        );
      },
    );
  }

  Widget firstNameField(bloc) {
    return StreamBuilder(
      stream: bloc.regFirstName,
      builder: (context, snapshot) {
        return TextField(
          textInputAction: TextInputAction.next,
          onChanged: bloc.changeRegFirstName,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Kareem',
            labelText: 'First name',
            errorText: snapshot.error,
          ),
          focusNode: _firstNameFocus,
          onSubmitted: (term) {
            _fieldFocusChange(context, _firstNameFocus, _lastNameFocus);
          },
        );
      },
    );
  }

  Widget lastNameField(bloc) {
    return StreamBuilder(
      stream: bloc.regLastName,
      builder: (context, snapshot) {
        return TextField(
          textInputAction: TextInputAction.next,
          onChanged: bloc.changeRegLastName,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Ibrahim',
            labelText: 'Last name',
            errorText: snapshot.error,
          ),
          focusNode: _lastNameFocus,
          onSubmitted: (term) {
            _fieldFocusChange(context, _lastNameFocus, _passwordFocus);
          },
        );
      },
    );
  }

  Widget nameFields(bloc) {
    return Row(
      children: <Widget>[
        firstNameField(bloc),
        lastNameField(bloc),
      ],
    );
  }

  Widget emailField(bloc) {
    bloc.changeRegEmail(email);
        return TextField(
          enabled: false,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            icon: new Icon(Icons.mail_outline),
            hintText: email,
            labelText: 'Email Address',
          ),
    );
  }

  Widget passwordField(bloc) {
    return StreamBuilder(
      stream: bloc.regPassword,
      builder: (context, snapshot) {
        return TextField(
          textInputAction: TextInputAction.next,
          onChanged: bloc.changeRegPassword,
          decoration: InputDecoration(
              icon: new Icon(Icons.lock),
              hintText: 'Must contain 8 characters',
              labelText: 'Password',
              errorText: snapshot.error),
          obscureText: true,
          focusNode: _passwordFocus,
          onSubmitted: (term) {
//            _fieldFocusChange(context, _passwordFocus, _phoneFocus);
          },
        );
      },
    );
  }

  Widget registerButton(bloc) {
    return StreamBuilder(
      stream: bloc.submitRegValid,
      builder: (context, snapshot) {
        return ButtonTheme(
          height: 40.0,
          minWidth: 80.0,
          child: RaisedButton(
            child: Text('Register'),
            /*  color: Colors.blue[700],
          textColor: Colors.white,*/
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
            onPressed: snapshot.hasData ? () => bloc.register(context) : null,
          ),
        );
      },
    );
  }

  Widget spinningField(bloc) {
    return StreamBuilder<int>(
        initialData: 1,
        stream: bloc.regSpinnerStatus,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            int value = bloc.regSpinnerStatus.value;
            switch (value) {
              case 0:
                print('Spinner: 0');
                return Text('Failed to Register, try again');
              case 1:
                print('Spinner: 1');
                return Container(
                  width: 0.0,
                  height: 0.0,
                );
              case 2:
                print('Spinner: 2');
                return Center(child: const CircularProgressIndicator());
              default:
                print('Spinner: 2+');
                return Container(
                  width: 0.0,
                  height: 0.0,
                );
            }
          } else {
            print('Spinner: Error');
            return Container(
              width: 0.0,
              height: 0.0,
            );
          }
        });
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Widget _registerForm(RegisterationBloc bloc, BuildContext context) {
    bloc.changeRegCanRegister(true);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            failedToRegisterText(),
            Container(margin: EdgeInsets.only(top: 30.0)),
            firstNameField(bloc),
            Container(margin: EdgeInsets.only(top: 8.0)),
            lastNameField(bloc),
            Container(margin: EdgeInsets.only(top: 8.0)),
            passwordField(bloc),
            Container(margin: EdgeInsets.only(top: 8.0)),
            emailField(bloc),
            Container(margin: EdgeInsets.only(top: 8.0)),
            registerButton(bloc),
            spinningField(bloc),
          ],
        ),
      ),
    );
  }

  Widget _getLandingPage(RegisterationBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.regStatus,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          HomePageBloc _bloc = HomePageProvider.of(context);
          String firebase_uid = bloc.regStatus.value;
//          _bloc.getUserData(firebase_uid);
          return HomepageScreenApp(this.email,firebase_uid,_bloc);
        } else {
          return _registerForm(bloc, context);
        }
      },
    );
  }
}
