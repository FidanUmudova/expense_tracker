import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/expense_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive bazasını başladaq
  await Hive.initFlutter();

  // Adapteri qeydiyyatdan keçirək
  Hive.registerAdapter(ExpenseAdapter());

  // 'expenses' adında xana (box) açaq
  await Hive.openBox<Expense>('expenses');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: Text("Expense Tracker - Checkpoint 1")),
      ),
    );
  }
}