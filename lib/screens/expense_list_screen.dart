import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_track/providers/expense_provider.dart';
import 'package:split_track/providers/participant_provider.dart';
import 'package:split_track/routes/route_names.dart';
import 'package:split_track/widgets/expense_expansion_tile.dart';
import 'package:split_track/widgets/settlement_modal.dart';

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
      context.read<ParticipantProvider>().loadParticipants();
    });
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = context.watch<ExpenseProvider>();
    final participantProvider = context.watch<ParticipantProvider>();

    final expenses = expenseProvider.expenses;
    final participants = participantProvider.participants;

    final settlements = expenseProvider.calculateSettlements(expenses);

    for(var s in settlements) {
      debugPrint('settlement: ${s.toString()}');
    }

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
                    return ExpenseExpansionTile(expense: expense);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('Show total transactions');

                      showModalBottomSheet(
                        context: context,
                        builder: (context) => SettlementModal(settlements: settlements, participants: participants),
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 120, 181, 63),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text('Show Total'),
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('Add new expense');
                      Navigator.of(context).pushNamed(RouteNames.newExpense);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text('Add new expense'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}