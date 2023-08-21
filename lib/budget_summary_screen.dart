import 'package:flutter/material.dart';
import 'add_expense_screen.dart';
import 'add_income_screen.dart';

class BudgetSummaryScreen extends StatefulWidget {
  final List<ExpenseItem> expenseItems;
  final List<IncomeItem> incomeItems;
  final double totalExpenses; // New parameter
  final double totalIncome; // New parameter

  const BudgetSummaryScreen({
    Key? key,
    required this.expenseItems,
    required this.incomeItems,
    required this.totalExpenses,
    required this.totalIncome,
  }) : super(key: key);

  @override
  _BudgetSummaryScreenState createState() => _BudgetSummaryScreenState();
}

class _BudgetSummaryScreenState extends State<BudgetSummaryScreen> {
  // Function to clear all added items
  void clearAllItems() {
    setState(() {
      widget.expenseItems.clear();
      widget.incomeItems.clear();
    });
  }

  double calculateTotalExpenses() {
    return widget.totalExpenses; // Use the provided totalExpenses parameter
  }

  double calculateTotalIncome() {
    return widget.totalIncome; // Use the provided totalIncome parameter
  }

  double calculateBudget() {
    double totalIncome = calculateTotalIncome();
    double totalExpenses = calculateTotalExpenses();
    return totalIncome - totalExpenses;
  }

  String getBudgetStatus() {
    double budget = calculateBudget();
    if (budget < 0) {
      return 'You have liabilities';
    } else if (budget > 0) {
      return 'Your budget is healthy, you have assets';
    } else {
      return 'Nothing Yet';
    }
  }

  void addExpenseItem(ExpenseItem newItem) {
    setState(() {
      widget.expenseItems.add(newItem);
    });
  }

  void addIncomeItem(IncomeItem newItem) {
    setState(() {
      widget.incomeItems.add(newItem);
    });
  }

  void pushExpensesToBudgetSummary(BuildContext context, List<ExpenseItem> updatedExpenseItems) {
    double totalExpenses = updatedExpenseItems.fold(
      0.0,
      (sum, item) => sum + item.totalAmount,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BudgetSummaryScreen(
          incomeItems: widget.incomeItems,
          expenseItems: updatedExpenseItems, // Use the updated list here
          totalExpenses: totalExpenses,
          totalIncome: widget.totalIncome,
        ),
      ),
    );
  }

  void pushIncomesToBudgetSummary(BuildContext context, List<IncomeItem> updatedIncomeItems) {
    double totalIncome = updatedIncomeItems.fold(
      0.0,
      (sum, item) => sum + item.amount,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BudgetSummaryScreen(
          incomeItems: updatedIncomeItems, // Use the updated list here
          expenseItems: widget.expenseItems,
          totalExpenses: widget.totalExpenses,
          totalIncome: totalIncome,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 235, 210, 210),
      appBar: AppBar(
        title: const Text('Budget Summary'),
      ),
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Expenses',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Column(
                    children: widget.expenseItems.map((item) {
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text('Total: \$${item.totalAmount.toStringAsFixed(2)}'),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Income',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Column(
                    children: widget.incomeItems.map((item) {
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text('Amount: \$${item.amount.toStringAsFixed(2)}'),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              // Show a dialog to choose transaction type
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Choose Transaction Type'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: _navigateToAddExpenseScreen,
                        child: const Text('Add Expense'),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _navigateToAddIncomeScreen,
                        child: const Text('Add Income'),
                      ),
                    ],
                  ),
                ),
              );
            },
            label: const Text('Add Transaction'),
            icon: const Icon(Icons.add),
          ),
          const SizedBox(height: 16.0), // Add some spacing between buttons
          SizedBox(
            width: 56, // Set width to match FloatingActionButton
            height: 56, // Set height to match FloatingActionButton
            child: ElevatedButton(
              onPressed: clearAllItems,
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                primary: Color.fromARGB(255, 197, 190, 190), // Change the color to your preference
              ),
              child: const Icon(Icons.clear),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Budget',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                calculateBudget().toStringAsFixed(2),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: calculateBudget() < 0 ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToAddExpenseScreen() async {
    final newItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpenseScreen(
          addItem: addExpenseItem,
          expenseItems: widget.expenseItems,
        ),
      ),
    );
    if (newItem != null) {
      addExpenseItem(newItem);
    }
  }

  void _navigateToAddIncomeScreen() async {
    final newItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddIncomeScreen(
          addItem: addIncomeItem,
          incomeItems: widget.incomeItems,
        ),
      ),
    );
    if (newItem != null) {
      addIncomeItem(newItem);
    }
  }
}
