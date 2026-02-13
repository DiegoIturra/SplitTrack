import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:split_track/models/participant.dart';
import 'package:split_track/providers/participant_provider.dart';
import 'package:split_track/screens/icon_selector_screen.dart';

/*TODOS: 
  - change onPressed in second selector in the future to select currency
  - allow decimal inputs in amount
  - add participants selector
  - replace static list of participants with the real list from databaase
*/

class NewExpenseScreen extends StatefulWidget {
  final int trackId;

  const NewExpenseScreen({super.key, required this.trackId});

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

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () {
                      debugPrint('Guardar Gasto');
                    },
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