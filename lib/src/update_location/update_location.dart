import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/bloc/homepage_bloc.dart';
import 'package:flutter_games_exchange/src/fragments/trades.dart';
import 'package:flutter_games_exchange/providers/update_location_provider.dart';
import 'package:flutter_games_exchange/src/utils/location_utils.dart';

class UpdateLocationScreen extends StatelessWidget {
  HomePageBloc homePageBloc;

  UpdateLocationScreen(this.homePageBloc);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    UpdateLocationBloc _bloc = UpdateLocationProvider.of(context);
    return buildLayout(_bloc);
  }

  Widget buildLayout(UpdateLocationBloc _bloc) {
    return new StreamBuilder<bool>(
      stream: homePageBloc.hasLocationAndDistrict,
      builder: (BuildContext context, AsyncSnapshot<bool> snapShot) {
        if (snapShot.hasData) {
          return TradeScreen(
              homePageBloc.getCurrentUser().firebase_uid, homePageBloc);
        } else {
          return new Column(
            children: <Widget>[

                  new Center(
                    child: Icon(
                      Icons.location_off,
                      size: 96.0,

                    ),

              ),
              Container(
                margin: EdgeInsets.all(4.0),
                child: Text('Please Add Your Location',
                    style: TextStyle(fontSize: 20.0, color: Colors.black)),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: 36.0, top: 4.0, right: 36.0, bottom: 4.0),
                child: DropdownButton<String>(
                  hint: new Text('Country'),
                  isExpanded: true,
                  items: getLocations().map(
                    (String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    },
                  ).toList(),
                  onChanged: (location) {
                    _bloc.changeLocationStream(location);
                  },
                ),
              ),
              StreamBuilder<String>(
                stream: _bloc.locationStream,
                builder: (context, snapshot) {
                  List<String> districts = getDistricts(snapshot.data);
                  return Container(
                    margin: EdgeInsets.only(
                        left: 36.0, top: 4.0, right: 36.0, bottom: 8.0),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: new Text('District'),
                      items: districts.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (district) {
                        _bloc.changeDistrictStream(district);
                      },
                    ),
                  );
                },
              ),
              StreamBuilder(
                stream: _bloc.canUpdate,
                builder: (context, snapshot) {
                  return ButtonTheme(
                    height: 40.0,
                    minWidth: 80.0,
                    child: RaisedButton(
                      child: Text('Add Location'),
                      /*  color: Colors.blue[700],
          textColor: Colors.white,*/
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      onPressed: snapshot.hasData
                          ? () => _bloc.updateLocation(context)
                          : null,
                    ),
                  );
                },
              ),
            ],
          );
        }
      },
    );
  }

  List<String> getLocations() {
    return LocationUtils.countries;
  }

  List<String> getDistricts(String location) {
    return LocationUtils.getEgyptDistrictArray(
        LocationUtils.getEgyptLocationIndex(location));
  }
}
