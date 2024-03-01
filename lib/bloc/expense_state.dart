import '../model/expense.dart';

abstract class ExpenseState {
  final List<Expense> expenses;

  ExpenseState(this.expenses);
}

class ExpensesInitial extends ExpenseState {
  ExpensesInitial() : super([]);
}

class ExpensesUpdated extends ExpenseState {
  ExpensesUpdated(List<Expense> expenses) : super(expenses);
}
