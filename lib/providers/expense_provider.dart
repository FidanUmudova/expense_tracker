import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense_model.dart';

enum SortOption { date, amount }

class ExpenseProvider extends ChangeNotifier {
  final List<Expense> _allExpenses = [];
  String _selectedCategory = 'All';
  SortOption _sortOption = SortOption.date;

  // main.dart-ın istifadə etməsi üçün Getter-lər
  String get selectedCategory => _selectedCategory;
  SortOption get sortOption => _sortOption;

  ExpenseProvider() {
    _loadExpenses();
  }

  void _loadExpenses() {
    final box = Hive.box<Expense>('expenses');
    _allExpenses.clear();
    _allExpenses.addAll(box.values.toList());
    notifyListeners();
  }

  List<Expense> get filteredExpenses {
    List<Expense> list = List.from(_allExpenses);

    if (_selectedCategory != 'All') {
      list = list.where((e) => e.category == _selectedCategory).toList();
    }

    if (_sortOption == SortOption.date) {
      list.sort((a, b) => b.date.compareTo(a.date));
    } else {
      list.sort((a, b) => b.amount.compareTo(a.amount));
    }

    return list;
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSortOption(SortOption option) {
    _sortOption = option;
    notifyListeners();
  }
}