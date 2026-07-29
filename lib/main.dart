import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart'; // 1. Provider-i daxil edirik
import 'models/expense_model.dart';
import 'providers/counter_provider.dart'; // 2. Yaratdığımız Provider-i daxil edirik

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive bazasını başladaq
  await Hive.initFlutter();

  // Adapteri qeydiyyatdan keçirək
  Hive.registerAdapter(ExpenseAdapter());

  // 'expenses' adında xana (box) açaq
  await Hive.openBox<Expense>('expenses');

  runApp(
    // 3. runApp daxilində ChangeNotifierProvider ilə bükürük
    ChangeNotifierProvider(
      create: (context) => CounterProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: Text("Expense Tracker - Checkpoint 3")),
      ),
    );
  }
}