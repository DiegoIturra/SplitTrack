import 'package:flutter/material.dart';

class ParticipantInput extends StatelessWidget {
  final TextEditingController controller;
  final String avatarUrl;
  final FocusNode focusNode;

  const ParticipantInput({
    super.key,
    required this.controller,
    required this.avatarUrl,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(radius: 24, backgroundImage: NetworkImage(avatarUrl)),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Ingresa el nombre',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
