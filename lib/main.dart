import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/expense_model.dart';
import 'providers/expense_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseAdapter());
  await Hive.openBox<Expense>('expenses');

  runApp(
    ChangeNotifierProvider(
      create: (context) => ExpenseProvider(),
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
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showAddExpenseModal(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Yeni Xərc Əlavə Et",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Başlıq (Title)'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Başlıq boş ola bilməz!';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Məbləğ (Amount)'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Məbləğ boş ola bilməz!';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Zəhmət olmasa yalnız rəqəm daxil edin!';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Məbləğ 0-dan böyük olmalıdır!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text('Əlavə et'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton<String>(
                  value: provider.selectedCategory,
                  items: ['All', 'Food', 'Transport', 'Bills', 'Entertainment']
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) context.read<ExpenseProvider>().setCategory(val);
                  },
                ),
                DropdownButton<SortOption>(
                  value: provider.sortOption,
                  items: const [
                    DropdownMenuItem(value: SortOption.date, child: Text("Tarixə görə")),
                    DropdownMenuItem(value: SortOption.amount, child: Text("Məbləğə görə")),
                  ],
                  onChanged: (opt) {
                    if (opt != null) context.read<ExpenseProvider>().setSortOption(opt);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: provider.filteredExpenses.isEmpty
                ? const Center(child: Text("Xərc tapılmadı"))
                : ListView.builder(
              itemCount: provider.filteredExpenses.length,
              itemBuilder: (context, index) {
                final item = provider.filteredExpenses[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(item.category.isNotEmpty ? item.category[0] : '?'),
                  ),
                  title: Text(item.title),
                  subtitle: Text(item.date.toString().split(' ')[0]),
                  trailing: Text(
                    "\$${item.amount.toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExpenseModal(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}