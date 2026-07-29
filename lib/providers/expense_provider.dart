import 'package:flutter/material.dart';
import '../models/expense_model.dart';

// Çeşidləmə növləri
enum SortOption { date, amount }

class ExpenseProvider extends ChangeNotifier {
  final List<Expense> _allExpenses = [];

  String _selectedCategory = 'All';
  SortOption _sortOption = SortOption.date;


  List<Expense> get filteredExpenses {
    List<Expense> list = List.from(_allExpenses);


    if (_selectedCategory != 'All') {
      list = list.where((e) => e.category == _selectedCategory).toList();
    }


    if (_sortOption == SortOption.date) {
      list.sort((a, b) => b.date.compareTo(a.date));
    } else if (_sortOption == SortOption.amount) {
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