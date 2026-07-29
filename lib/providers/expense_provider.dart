import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense_model.dart';

enum SortOption { date, amount }

class ExpenseProvider with ChangeNotifier {
  final Box<Expense> _expenseBox = Hive.box<Expense>('expenses');

  String _selectedCategory = 'All';
  SortOption _sortOption = SortOption.date;

  String get selectedCategory => _selectedCategory;
  SortOption get sortOption => _sortOption;

  List<Expense> get expenses {
    return _expenseBox.values.toList();
  }

  List<Expense> get filteredExpenses {
    List<Expense> tempExpenses = expenses;

    if (_selectedCategory != 'All') {
      tempExpenses = tempExpenses
          .where((expense) => expense.category == _selectedCategory)
          .toList();
    }

    tempExpenses.sort((a, b) {
      if (_sortOption == SortOption.date) {
        return b.date.compareTo(a.date);
      } else {
        return b.amount.compareTo(a.amount);
      }
    });

    return tempExpenses;
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSortOption(SortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  void addExpense(Expense expense) {
    _expenseBox.add(expense);
    notifyListeners();
  }

  void deleteExpense(String id) {
    final expenseKey = _expenseBox.keys.firstWhere(
          (key) => _expenseBox.get(key)?.id == id,
      orElse: () => null,
    );
    if (expenseKey != null) {
      _expenseBox.delete(expenseKey);
      notifyListeners();
    }
  }
}