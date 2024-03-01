import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../model/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  final Function addExpense;

  const AddExpenseScreen(this.addExpense, {super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedCategory = 'Food';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: _titleController,
              onSubmitted: (String value){
                _submitData();
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Amount'),
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (String value) {
                _submitData();
              },
            ),
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.only(top: 10),
              child: DropdownButton<String>(
                value: _selectedCategory,

                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },

                items: <String>['Food', 'Transportation', 'Utilities', 'Entertainment']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 10),
              child: ElevatedButton(

                onPressed: _submitData,
                child: const Text('Save Expense'),
              ),
            ),
          ],
        ),
      ),
    );
  }
   void  _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = _amountController.text;
    final selectedCategory = _selectedCategory;

    if (enteredTitle.isEmpty || enteredAmount.isEmpty || selectedCategory == null) {
      _showValidationError('Please fill in all fields.');
      return;
    }

    double? amount = double.tryParse(enteredAmount);
    if (amount == null || amount <= 0) {
      _showValidationError('Amount must be a positive number.');
      return;
    }

    final newExpense = Expense(
      id: DateTime.now().toString(),
      title: enteredTitle,
      amount: amount,
      category: selectedCategory,
    );

    BlocProvider.of<ExpenseBloc>(context).add(ExpenseAdded(newExpense));

    Navigator.of(context).pop();
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

}

