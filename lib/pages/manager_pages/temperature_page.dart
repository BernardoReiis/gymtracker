import '../../services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManagerTemperaturePage extends StatelessWidget {
  const ManagerTemperaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gym Temperature"),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(191, 76, 76, 1),
      ),
      body: Container(),
    );
  }
}
