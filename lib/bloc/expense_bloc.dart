import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/expense.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc() : super(ExpensesInitial()) {
    on<ExpenseAdded>((event, emit) {
      final newState = List<Expense>.from(state.expenses)..add(event.expense);
      emit(ExpensesUpdated(newState));
    });
  }
}
