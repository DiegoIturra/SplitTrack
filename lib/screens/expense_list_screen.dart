import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_track/providers/expense_provider.dart';
import 'package:split_track/widgets/image_list_item.dart';

class ExpenseListScreen extends StatelessWidget {
  const ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ExpenseProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.expenses.isEmpty) {
                  provider.loadExpenses();
                  return const Center(child: Text('No expenses yet'));
                }
                return ListView.builder(
                  itemCount: provider.expenses.length,
                  itemBuilder: (context, index) {
                    final expense = provider.expenses[index];
                    return ImageListItem(
                      title: 'Monto: ${expense.totalAmount}',
                      imageUrl:
                          "https://media.craiyon.com/2025-06-10/yfNVNakqS5urgb1GRB11ww.webp",
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ExpenseListScreen()),
                        );
                      },
                    
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  debugPrint('se crea un nuevo gasto');
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.indigo),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                ),
                child: const Text("Add New expense"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}