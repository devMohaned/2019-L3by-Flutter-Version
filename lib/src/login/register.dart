import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/providers/homepage_provider.dart';
import 'package:flutter_games_exchange/providers/registeration_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_games_exchange/src/homepage/homepage.dart';
import 'package:flutter_games_exchange/src/login/login.dart';

class RegisterScreen extends StatelessWidget {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  /* final FocusNode _phoneFocus = FocusNode();
  final FocusNode _locationFocus = FocusNode();*/

  @override
  Widget build(BuildContext context) {
    final bloc = RegisterProvider.of(context);
    return _getLandingPage(bloc);
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
            _fieldFocusChange(context, _lastNameFocus, _emailFocus);
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

  /* Widget phoneNumberField(bloc) {
    return StreamBuilder(
      stream: bloc.regPhoneNumber,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeRegPhoneNumber,
          keyboardType: TextInputType.phone,
          maxLength: 11,
          decoration: InputDecoration(
            icon: new Icon(Icons.phone_android),
            hintText: '01120304050',
            labelText: 'Phone Number',
            errorText: snapshot.error,
          ),
          focusNode: _phoneFocus,
          onSubmitted:   (term){
            _fieldFocusChange(context, _phoneFocus, _locationFocus);
          },
        );
      },
    );
  }*/

  Widget emailField(bloc) {
    return StreamBuilder(
      stream: bloc.regEmail,
      builder: (context, snapshot) {
        return TextField(
          textInputAction: TextInputAction.next,
          onChanged: bloc.changeRegEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            icon: new Icon(Icons.mail_outline),
            hintText: 'you@example.com',
            labelText: 'Email Address',
            errorText: snapshot.error,
          ),
          focusNode: _emailFocus,
          onSubmitted: (term) {
            _fieldFocusChange(context, _emailFocus, _passwordFocus);
          },
        );
      },
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
                return Center(child: Text('Failed to Register, try again'));
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

/* Widget locationField(bloc) {
    _dropDownMenuItemsLocation = getDropDownMenuItemsLocation();
    bloc.changeRegLocation(_dropDownMenuItemsLocation[0].value);
    return StreamBuilder(
      stream: bloc.regLocation,
      builder: (context, snapshot) {
        return new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text("Please choose your city: "),
            new Container(
              padding: new EdgeInsets.only(top: 16.0),
            ),
            new DropdownButton(
              value: _dropDownMenuItemsLocation[0].value,
              items: _dropDownMenuItemsLocation,
              onChanged: bloc.changeRegLocation,
            ),

          ],
        );
      },
    );
  }


  Widget DistrictField(bloc) {
    _dropDownMenuItemsDistrict = getDropDownMenuItemsDistrict();
    bloc.changeRegDistrict(_dropDownMenuItemsDistrict[0].value);
    return StreamBuilder(
      stream: bloc.regDistrict,
      builder: (context, snapshot) {
        return new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text("Please choose your district: "),
            new Container(
              padding: new EdgeInsets.only(top: 16.0),
            ),
            new DropdownButton(
              value: _dropDownMenuItemsDistrict[0].value,
              items: _dropDownMenuItemsDistrict,
              onChanged: bloc.changeRegDistrict,
            ),

          ],
        );
      },
    );
  }
  List _cities = [
    '6th of October',
    '10th Of Ramadan',
    'Alexandria',
    'Aswan',
    'Asyut',
    'Beheira',
    'Beni Suef',
    'Cairo',
    'Damietta',
    'Dakahlia',
    'Faiyum',
    'Giza',
    'Gharbia',
    'Helwan',
    'Ismailia',
    'Kafr el-Sheikh',
    'Luxor',
    'Matruh',
    'Minya',
    'Monufia',
    'New Valley',
    'North Sinai',
    'Port Said',
    'Qalyubia',
    'Qena',
    'Red Sea',
    'Sharqia',
    'South Sinai',
    'Sohag',
    'Suez',
  ];

  List<DropdownMenuItem<String>> _dropDownMenuItemsLocation;
  List<DropdownMenuItem<String>> _dropDownMenuItemsDistrict;
*/

//  String _currentCity;

/*  @override
  void initState() {
      _dropDownMenuItems = getDropDownMenuItems();
  _currentCity = _dropDownMenuItems[0].value;
    super.initState();
  }*/

/*
  List<DropdownMenuItem<String>> getDropDownMenuItemsLocation() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in _cities) {
      items.add(new DropdownMenuItem(value: city, child: new Text(city)));
    }
    return items;
  }


  List<DropdownMenuItem<String>> getDropDownMenuItemsDistrict() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in _cities) {
      items.add(new DropdownMenuItem(value: city, child: new Text(city)));
    }
    return items;
  }
*/
  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Widget _registerForm(RegisterationBloc bloc, BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Container(margin: EdgeInsets.only(top: 30.0)),
            firstNameField(bloc),
            Container(margin: EdgeInsets.only(top: 8.0)),
            lastNameField(bloc),
            Container(margin: EdgeInsets.only(top: 8.0)),
            emailField(bloc),
            Container(margin: EdgeInsets.only(top: 8.0)),
            passwordField(bloc),

            /*              Container(margin: EdgeInsets.only(top: 8.0)),
          phoneNumberField(bloc),
                 Container(margin: EdgeInsets.only(top: 8.0)),
          locationField(bloc),
               Container(margin: EdgeInsets.only(top: 30.0)),
          DistrictField(bloc),*/
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
//          return HomepageScreenApp(bloc.getLastEmail(),firebase_uid,_bloc);
        return LoginScreen();
        } else {
          return _registerForm(bloc, context);
        }
      },
    );
  }
}
