import 'package:equatable/equatable.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';

import '../date.dart';

class OverviewResponse extends Equatable {
  const OverviewResponse(
      {this.transactions,
      this.budgets,
      this.categories,
      this.bankAccounts,
      this.dates,
      this.wallet});

  final List<Transaction> transactions;
  final List<Budget> budgets;
  final List<Category> categories;
  final List<BankAccount> bankAccounts;
  final List<Date> dates;
  final Wallet wallet;

  @override
  List<Object> get props =>
      [transactions, budgets, categories, bankAccounts, dates, wallet];
}
