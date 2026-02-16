import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:split_track/models/participant.dart';
import 'package:split_track/providers/expense_provider.dart';
import 'package:split_track/providers/participant_provider.dart';
import 'package:split_track/screens/icon_selector_screen.dart';

/*TODOS: 
  - change onPressed in second selector in the future to select currency
  - allow decimal inputs in amount
*/

class NewExpenseScreen extends StatefulWidget {
  const NewExpenseScreen({super.key});

  @override
  State<StatefulWidget> createState() => _NewExpenseScreenState();
}

class _NewExpenseScreenState extends State<NewExpenseScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  Participant? selectedPayer;
  IconData? selectedIcon;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveExpense() async {
    if(!_formKey.currentState!.validate()) return;

    if(selectedPayer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete todos los campos'))
      );
      return;
    }

    final amount = double.tryParse(amountController.text);

    if(amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Monto inválido')),
      );
      return;
    }

    final participantProvider = context.read<ParticipantProvider>();
    final expenseProvider = context.read<ExpenseProvider>();

    try {
      await expenseProvider.createExpense(
        description: nameController.text.trim(),
        amount: amount,
        payer: selectedPayer!,
        icon: selectedIcon,
        participants: participantProvider.participants,
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar gasto: $e')),
      );

      debugPrint('Error al guardar gasto: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    debugPrint('Se renderiza screen new expense');
    final expenseProvider = context.read<ExpenseProvider>();

    debugPrint("trackId en newExpenseScreen: ${expenseProvider.trackId}");
    

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Expense', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      final icon = await Navigator.push<IconData>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const IconSelectorScreen()
                        )
                      );

                      if(icon != null) {
                        setState(() => selectedIcon = icon);
                      }
                    },
                    child: Icon(selectedIcon ?? Icons.receipt_long),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: nameController,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: null,
                    child: const Icon(Icons.percent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Monto',
                        prefixText: '\$ ',
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Consumer<ParticipantProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const CircularProgressIndicator();
                  }

                  if (provider.participants.isEmpty) {
                    return const Text(
                      'No hay participantes disponibles',
                    );
                  }

                  return DropdownButtonFormField<Participant>(
                    initialValue: selectedPayer,
                    decoration: const InputDecoration(
                      labelText: 'Pagado por',
                    ),
                    items: provider.participants.map((participant) {
                      return DropdownMenuItem(
                        value: participant,
                        child: Text(participant.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      debugPrint("Se ha seleccionado el pagador ${value?.name}");
                      setState(() => selectedPayer = value);
                    },
                    validator: (value) => value == null ? 'Seleccione un pagador' : null,
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveExpense,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                    child: const Text('Guardar gasto'),
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }

}