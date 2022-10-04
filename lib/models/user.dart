import 'package:flutter_games_exchange/src/utils/constants.dart';

class User {
  String first_name,
      last_name,
      firebase_uid,
      email,
      password,
      platform,
      facebook,
      whatsapp,
      profile_image,
      token,
      user_state;
  int location, district;

  User(
      this.first_name,
      this.last_name,
      this.firebase_uid,
      this.email,
      this.password,
      this.platform,
      this.profile_image,
      this.token,
      this.facebook,
      this.whatsapp,
      this.location,
      this.district,
      this.user_state);

  Map<String, dynamic> toMap() {
    return {
      'first_name': first_name,
      'last_name': last_name,
      'firebase_uid': firebase_uid,
      'email': email,
      'password': password,
      'platform': platform,
    };
  }

   User.fromJson(Map<String, dynamic> json)
      : first_name = json['first_name'],
  last_name = json['last_name'],
  firebase_uid = json['firebase_uid'],
  email = json['email'],
  password = '00000000',
  platform = json['platform'],
  profile_image = /*'${Constants.PROFILE_LINK}*/ '${json['profile_image']}',
  token = json['token'],
  facebook = json['facebook'],
  whatsapp = json['whatsapp'],
  location = json['location'] != null ? int.parse(json['location']) : 500000 ?? 500000,
  district = json['district'] != null ? int.parse(json['district']) : 500000 ?? 500000,
  user_state = json['user_state'];



  factory User.dummyUser() {
    return User(
        'first_name',
        'last_name',
        'firebase_uid',
        'email',
        '00000000',
        'platform',
        'profile_image',
        'token',
        'facebook',
        'whatsapp',
        0,
        0,
        'HTTP_EXCEPTION'
    );
  }


}
