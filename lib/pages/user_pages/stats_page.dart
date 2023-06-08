import '../../services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

import 'avg_training_time.dart';
import 'graph_aux.dart';

class UserStatsPage extends StatelessWidget {
  const UserStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stats"),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(191, 76, 76, 1),
      ),
      body: Column(
        children: [
          BarChartSample1(),
          const AvgTrainingTime(),
        ],
      ),
    );
  }
}
