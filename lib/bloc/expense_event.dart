import '../model/expense.dart';

abstract class ExpenseEvent {}

class ExpenseAdded extends ExpenseEvent {
  final Expense expense;
  ExpenseAdded(this.expense);
}
