import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_tracker/models/expense_model.dart';

class ExpenseService {
  static const String _boxName = 'expensesBox';

  static Box<Expense> get _box => Hive.box<Expense>(_boxName);

  // 1. CREATE - Yeni xərc əlavə etmək
  static Future<void> addExpense(Expense expense) async {
    await _box.put(expense.id, expense);
  }

  // 2. READ - Bütün xərcləri almaq
  static List<Expense> getExpenses() {
    return _box.values.toList();
  }

  // 3. UPDATE - Mövcud xərci yeniləmək
  static Future<void> updateExpense(Expense expense) async {
    await expense.save();
  }

  // 4. DELETE - Xərci silmək
  static Future<void> deleteExpense(String id) async {
    await _box.delete(id);
  }
}