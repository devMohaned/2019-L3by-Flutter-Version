import 'package:firebase_database/firebase_database.dart';

class FirebaseDatabaseHelper {
  // If 0, then user's online
  // if 1 then user's offline
  static addOnlineListener(String firebase_uid) {
    DatabaseReference reference = FirebaseDatabase.instance
        .reference()
        .child("status")
        .child(firebase_uid);
    reference.set(0);
    reference.onDisconnect().set(1);
  }
}
