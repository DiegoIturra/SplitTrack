import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_track/providers/expense_provider.dart';
import 'package:split_track/routes/route_names.dart';
import 'package:split_track/widgets/image_list_item.dart';

class ExpenseListScreen extends StatefulWidget {

  const ExpenseListScreen({super.key});
  
  @override
  State<StatefulWidget> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if(!mounted) return;
      context.read<ExpenseProvider>().loadExpenses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = context.read<ExpenseProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
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
                      onTap: () {
                        debugPrint('Expense ${expense.description}, Total expense ${expense.totalAmount}');
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
                onPressed: () async {
                  debugPrint('se crea un nuevo gasto para el track con id = ${expenseProvider.trackId}');
                  Navigator.of(context).pushNamed(RouteNames.newExpense);
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