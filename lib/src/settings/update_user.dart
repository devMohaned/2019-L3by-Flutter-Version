import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/bloc/homepage_bloc.dart';
import 'package:flutter_games_exchange/bloc/update_user_bloc.dart';
import 'package:flutter_games_exchange/models/user.dart';
import 'package:flutter_games_exchange/providers/update_user_provider.dart';
import 'package:flutter_games_exchange/src/utils/location_utils.dart';
import 'package:flutter_games_exchange/styles/container_styles.dart';
import 'package:flutter_games_exchange/styles/text_styles.dart';
import 'package:flutter_games_exchange/styles/widgets.dart';

class UpdateUserScreen extends StatefulWidget {
  HomePageBloc _homePageBloc;
  String first_name, last_name;
  int location, district;

  UpdateUserScreen(this._homePageBloc, this.first_name, this.last_name,
      this.location, this.district);

  @override
  UpdateUserScreenState createState() {
    // TODO: implement createState
    return UpdateUserScreenState(
        _homePageBloc, first_name, last_name, location, district);
  }
}

class UpdateUserScreenState extends State<UpdateUserScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();

  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  String location, district;

  HomePageBloc _homePageBloc;
  String first_name, last_name;
  int previous_location, previous_district;

  UpdateUserScreenState(this._homePageBloc, this.first_name, this.last_name,
      this.previous_location, this.previous_district);

  @override
  void initState() {
    _firstNameController.text = first_name;
    _lastNameController.text = last_name;
    if (previous_location != 500000 && previous_location != null)
      location =
          LocationUtils.getEgyptLocationStringFromIndex(previous_location);
    else
      location = 'Not Found';
    if (previous_district != 500000)
      district = LocationUtils.getDistrictFromIndex(previous_district);
    else
      district = 'Not Found';
  }

  bool isFirstTime = true;
  @override
  Widget build(BuildContext context) {
    final bloc = UpdateUserProvider.of(context);
    if(isFirstTime)
      {
        isFirstTime = false;
        bloc.changeUpdateFirstName(first_name);
        bloc.changeUpdateLastName(last_name);
        bloc.changeLocationStream(location);
        bloc.changeDistrictStream(district);
      }
    return buildList(context, bloc);
  }

  AppBar getToolbar(BuildContext _context) {
    return AppBar(
      automaticallyImplyLeading: true,
      title: Text('Update Information'),
//      actions: <Widget>[Icon(Icons.done)],
    );
  }

  Widget buildList(BuildContext context, UpdateUserBloc bloc) {
    User currentUser = _homePageBloc.getCurrentUser();
    return Scaffold(
      appBar: getToolbar(context),
      body: ListView(
        children: <Widget>[
          Container(margin: EdgeInsets.only(top: 30.0)),
          firstNameField(bloc),
          Container(margin: EdgeInsets.only(top: 8.0)),
          lastNameField(bloc),
          Container(margin: EdgeInsets.only(top: 8.0)),
          locationSpinner(bloc),
          Container(margin: EdgeInsets.only(top: 8.0)),
          districtSpinner(bloc),
          Container(margin: EdgeInsets.only(top: 8.0)),
          updateButton(bloc)
        ],
      ),
    );
  }

  Widget firstNameField(bloc) {
    return StreamBuilder(
      initialData: first_name,
      stream: bloc.updateFirstName,
      builder: (context, snapshot) {
        return Container(
          child: TextField(
            controller: _firstNameController,
            textInputAction: TextInputAction.next,
            onChanged: (String changedText) {
              bloc.changeUpdateFirstName(changedText);
              bloc.changeUpdateCanUpdate(true);
            },
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
          ),
          margin: EdgeInsets.only(left: 12.0, right: 12.0),
        );
      },
    );
  }

  Widget lastNameField(bloc) {
    return StreamBuilder(
      initialData: last_name,
      stream: bloc.updateLastName,
      builder: (context, snapshot) {
        return Container(
          child: TextField(
            controller: _lastNameController,
            textInputAction: TextInputAction.next,
            onChanged: (String changedText) {
              bloc.changeUpdateLastName(changedText);
              bloc.changeUpdateCanUpdate(true);
            },
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Ibrahim',
              labelText: 'Last name',
              errorText: snapshot.error,
            ),
            focusNode: _lastNameFocus,
            onSubmitted: (term) {
              _fieldFocusChange(context, _lastNameFocus, null);
            },
          ),
          margin: EdgeInsets.only(left: 12.0, right: 12.0),
        );
      },
    );
  }

  Widget updateButton(UpdateUserBloc bloc) {
    return StreamBuilder(
      stream: bloc.submitUpdateValid,
      builder: (context, snapshot) {
        return ButtonTheme(
          height: 40.0,
          minWidth: 80.0,
          child: RaisedButton(
            child: Text('Update'),
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
            onPressed:
                snapshot.hasData ? () => bloc.update(_homePageBloc.getCurrentUser().firebase_uid,_homePageBloc, context)  : null,
          ),
        );
      },
    );
  }

  Widget locationSpinner(UpdateUserBloc _bloc) {
    List<String> data = getLocations();
    String locationInString =
        LocationUtils.getEgyptLocationStringFromIndex(previous_location);
    int prevIndex = getIndexFromArrayWithValue(data, locationInString);
    _bloc.changeLocationStream(location != 'Not Found' ? location :locationInString);
    return StreamBuilder<String>(
        stream: _bloc.locationStream,
        builder: (context, snapshot) {
          print('location $location / ${data[0]}');
          return data.length > 0
              ? Container(
                  margin: EdgeInsets.only(
                      left: 12.0, top: 4.0, right: 12.0, bottom: 4.0),
                  child: DropdownButton<String>(
                    value: location != 'Not Found' ? location : data[0],
                    hint: new Text('Country'),
                    isExpanded: true,
                    items: data.map(
                      (String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      },
                    ).toList(),
                    onChanged: (String location) {
                      setState(() {
                        this.location = location;
                        district =
                            '${LocationUtils.getEgyptDistrictArray(LocationUtils.getEgyptLocationIndex(location))[0]}';
                        _bloc.changeLocationStream(this.location);
                        _bloc.changeDistrictStream(district);
                        _bloc.changeUpdateCanUpdate(true);
                        print('Location Spinner ${this.location}');
                      });

                    },
                  ),
                )
              : CircularProgressIndicator();
        });
  }

  List<String> getLocations() {
    return LocationUtils.countries;
  }

  List<String> getDistricts(String location) {
    return LocationUtils.getEgyptDistrictArray(
        LocationUtils.getEgyptLocationIndex(location));
  }

  Widget districtSpinner(UpdateUserBloc _bloc) {
    if(location != 'Not Found') {
      List<String> districts = LocationUtils.getEgyptDistrictArray(
          LocationUtils.getEgyptLocationIndex(location));
      return Container(
        margin: EdgeInsets.only(left: 12.0, top: 4.0, right: 12.0, bottom: 8.0),
        child: DropdownButton<String>(
          value: district != 'Not Found' ? district : districts[0],
          isExpanded: true,
          hint: new Text('District'),
          items: districts.map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          onChanged: (district) {
            setState(() {
              this.district = district;
            });
            _bloc.changeDistrictStream(district);
            _bloc.changeUpdateCanUpdate(true);
          },
        ),
      );
    }
    return Container();
  }

  int getIndexFromArrayWithValue(List<String> list, String value) {
    for (int i = 0; i < list.length; i++) {
      if (value.toLowerCase() == list[i].toLowerCase()) {
        return i;
      }
    }
    return 500000;
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
