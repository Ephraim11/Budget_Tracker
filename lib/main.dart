import 'dart:io';

import 'package:flutter/material.dart';
import 'add_expense_screen.dart';
import 'add_income_screen.dart';
import 'budget_summary_screen.dart';
import 'settings_screen.dart';
import 'welcome_screen.dart';

void main() {
  runApp(const BudgetTrackerApp());
}

class BudgetTrackerApp extends StatelessWidget {
  const BudgetTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Tracker',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/addExpense': (context) => AddExpenseScreen(addItem: (ExpenseItem newItem) {}, expenseItems: []),
        '/addIncome': (context) => AddIncomeScreen(addItem: (IncomeItem newItem) {}, incomeItems: []),
        '/budgetSummary': (context) => const BudgetSummaryScreen(
          expenseItems: [],
          incomeItems: [],
          totalExpenses: 0.0,
          totalIncome: 0.0,
        ),
        '/settingsScreen': (context) => const SettingsScreen(),
      },
    );
  }
}

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.pushNamed(context, '/login');
              } else if (value == 'exit') {
                exit(0); // Implement the exit functionality here
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
              const PopupMenuItem<String>(
                value: 'exit',
                child: Text('Exit'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/addExpense');
                  },
                  child: Container(
                    width: 150.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Center(
                      child: Text(
                        'Add Expense',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.0), // Add some spacing between the tiles
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/addIncome');
                  },
                  child: Container(
                    width: 150.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Center(
                      child: Text(
                        'Add Income',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0), // Add some spacing between the tiles
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/budgetSummary');
              },
              child: Container(
                width: 150.0,
                height: 200.0,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Center(
                  child: Text(
                    'Budget Summary',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/settingsScreen');
        },
        child: const Icon(Icons.settings),
      ),
    );
  }
}
