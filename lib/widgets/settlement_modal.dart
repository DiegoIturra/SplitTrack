import 'package:flutter/material.dart';
import 'package:split_track/models/participant.dart';

class SettlementModal extends StatelessWidget {
  final List<dynamic> settlements;
  final List<Participant> participants;

  const SettlementModal({
    super.key, 
    required this.settlements,
    required this.participants
  });

  String _getParticipantName(int id) {
    final participant = participants.where((p) => p.id == id);
    return participant.isNotEmpty ? participant.first.name : "Usuario $id";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              width: 40,
              height: 4,
              margin: EdgeInsetsGeometry.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Text(
              "Balance de Cuentas",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 30),
            
            if (settlements.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Text("¡Todo está saldado!"),
              )
            else
              ...settlements.map((s) => ListTile(
                leading: const Icon(Icons.arrow_forward, color: Colors.redAccent),
                title: Text("${_getParticipantName(s.fromId)} debe a ${_getParticipantName(s.toId)}"),
                trailing: Text(
                  "\$${s.amount.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                ),
              )),
            
            const SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Entendido"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}