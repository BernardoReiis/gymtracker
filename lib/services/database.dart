import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/temperature.dart';
import '../models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference gymsCollection =
      FirebaseFirestore.instance.collection('gyms');
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference temperatureCollection =
      FirebaseFirestore.instance.collection('temperatures');

  Future updateUserData(String username, String email, double weight,
      double height, int age, String gender) async {
    return await userCollection.doc(uid).set({
      "username": username,
      "email": email,
      "gender": gender,
      "age": age,
      "height": height,
      "weight": weight,
      "isManager": false,
    });
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      username: snapshot.get("username"),
      email: snapshot.get("email"),
      gender: snapshot.get("gender"),
      height: snapshot.get("height").toDouble(),
      weight: snapshot.get("weight").toDouble(),
      age: snapshot.get("age"),
      isManager: snapshot.get("isManager"),
    );
  }

  List<TemperatureData> _temperatureDataFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return TemperatureData(
        dataTime: doc.get("data_time"),
        temperature: doc.get("temperature"),
        temperatureSensorId: doc.get("temperature_sensor_id"),
      );
    }).toList();
  }

  TemperatureData _temperatureToShowFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) {
          return TemperatureData(
            dataTime: doc.get("data_time"),
            temperature: doc.get("temperature"),
            temperatureSensorId: doc.get("temperature_sensor_id"),
          );
        })
        .toList()
        .first;
  }

  Stream<QuerySnapshot> get usersData {
    return userCollection.snapshots();
  }

  Stream<QuerySnapshot> get temperatureData {
    return temperatureCollection.snapshots();
  }

  Stream<List<TemperatureData>> get temperatureDataLatest {
    return temperatureCollection
        .orderBy("data_time", descending: true)
        .limit(4)
        .snapshots()
        .map(_temperatureDataFromSnapshot);
  }

  Stream<TemperatureData> get temperatureShowManagerHome {
    return temperatureCollection
        .orderBy("data_time", descending: true)
        .limit(1)
        .snapshots()
        .map(_temperatureToShowFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
