import 'package:flutter/material.dart';

class NewExpenseScreen extends StatefulWidget {
  const NewExpenseScreen({super.key});

  @override
  State<StatefulWidget> createState() => _NewExpenseScreenState();
}

class _NewExpenseScreenState extends State<NewExpenseScreen> {
  
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
      body: Center(
        child: Text('New Expense Screen'),
      ),
    );
  }

}