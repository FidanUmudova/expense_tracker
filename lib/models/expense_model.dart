import 'package:hive/hive.dart';

part 'expense_model.g.dart'; // Build runner generasiya edəcək

@HiveType(typeId: 0)
class Expense extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String category; // Məsələn: 'Food', 'Transport', 'Bills'

  @HiveField(4)
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });
}