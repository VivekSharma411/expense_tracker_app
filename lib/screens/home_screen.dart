import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../model/expense.dart';
import 'add_expense.dart';
import 'dart:math';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        centerTitle: true,
        elevation: 2,
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpensesUpdated) {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 200,
                  child: buildChart(state.expenses),
                ),
                SizedBox(height: 10,),
                Divider(height: 1,),
                Expanded( // Wrap ListView.builder with Expanded
                  child: ListView.builder(
                    itemCount: state.expenses.length,
                    itemBuilder: (context, index) {
                      final expense = state.expenses[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(expense.category[0]),
                        ),
                        title: Text(expense.title),
                        subtitle: Text('INR ${expense.amount.toStringAsFixed(2)}'),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is ExpensesInitial) {
            return const Center(
              child: Text('No expenses added yet.'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AddExpenseScreen((expense) {
              BlocProvider.of<ExpenseBloc>(context).add(ExpenseAdded(expense));
            }),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

///buildChart
  Widget buildChart(List<Expense> expenses) {
    Map<String, double> categorizedExpenses = _categorizeExpenses(expenses);

    List<PieChartSectionData> sections = categorizedExpenses.entries.map((entry) {
      final index = categorizedExpenses.keys.toList().indexOf(entry.key);
      String displayCategory = entry.key.substring(0, min(3, entry.key.length));

      return PieChartSectionData(
        color: Colors.primaries[index % Colors.primaries.length],
        value: entry.value,
        title: displayCategory,
        radius: 50,
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }

  Map<String, double> _categorizeExpenses(List<Expense> expenses) {
    Map<String, double> categorizedExpenses = {};
    for (var expense in expenses) {
      if (!categorizedExpenses.containsKey(expense.category)) {
        categorizedExpenses[expense.category] = 0;
      }
      categorizedExpenses[expense.category] = categorizedExpenses[expense.category]! + expense.amount;
    }
    return categorizedExpenses;
  }
}

