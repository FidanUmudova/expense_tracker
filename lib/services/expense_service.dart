import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_tracker/models/expense_model.dart';

class ExpenseService {
  static const String _boxName = 'expensesBox';

  static Box<Expense> get _box => Hive.box<Expense>(_boxName);

  //CREATE
  static Future<void> addExpense(Expense expense) async {
    await _box.put(expense.id, expense);
  }

  //READ
  static List<Expense> getExpenses() {
    return _box.values.toList();
  }

  //UPDATE
  static Future<void> updateExpense(Expense expense) async {
    await expense.save();
  }

  //DELETE
  static Future<void> deleteExpense(String id) async {
    await _box.delete(id);
  }
}