import 'package:flutter/material.dart';
import 'budget_summary_screen.dart';

class AddExpenseScreen extends StatefulWidget {
  final List<ExpenseItem> expenseItems;
  final Function(ExpenseItem newItem) addItem; // Callback to add item

  const AddExpenseScreen({
    Key? key,
    required this.expenseItems,
    required this.addItem,
  }) : super(key: key);

  
  get incomeItems => [];

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  TextEditingController expenseNameController = TextEditingController();
  TextEditingController expenseAmountController = TextEditingController();
  TextEditingController expenseQuantityController = TextEditingController();

  void addItem() {
    String name = expenseNameController.text;
    double amount = double.parse(expenseAmountController.text);
    int quantity = int.parse(expenseQuantityController.text);

    ExpenseItem newItem = ExpenseItem(
      name: name,
      amount: amount,
      quantity: quantity,
    );

    widget.addItem(newItem); // Call the callback to add item to BudgetSummaryScreen

    expenseNameController.clear();
    expenseAmountController.clear();
    expenseQuantityController.clear();
  }

  Future<void> _navigateToAddExpenseScreen() async {
    final newItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpenseScreen(
          addItem: widget.addItem,
          expenseItems: widget.expenseItems,
        ),
      ),
    );

    if (newItem != null) {
      setState(() {
        widget.expenseItems.add(newItem);
      });
    }
  }


  // Calculate the total expenses using the widget.expenseItems list
  double calculateTotalExpenses() {
    double total = 0.0;
    for (var item in widget.expenseItems) {
      total += item.totalAmount;
    }
    return total;
  }

  // Implement the pushExpensesToBudgetSummary function
  void pushExpensesToBudgetSummary(BuildContext context, List<ExpenseItem> expenseItems) {
    double totalExpenses = calculateTotalExpenses();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BudgetSummaryScreen(
          incomeItems: widget.incomeItems ?? [], // Initialize as empty list if null
          expenseItems: widget.expenseItems ?? [], // Use widget.expenseItems directly or initialize as empty list if null
          totalExpenses: totalExpenses,
          totalIncome: 0.0,
        ),
      ),
    );
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 235, 210, 210),
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Column(
            children: [
              // Expense name field
              TextField(
                controller: expenseNameController,
                decoration: InputDecoration(
                  labelText: 'Expense Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // Expense amount field
              TextField(
                controller: expenseAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Expense Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // Expense quantity field
              TextField(
                controller: expenseQuantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),

              const SizedBox(height: 24.0),

              // Add Expense button
              ElevatedButton(
            onPressed: _navigateToAddExpenseScreen,
            child: const Text('Add Expense'),
          ),


              const SizedBox(height: 16.0),

              // Total Expenses
              const Text(
                'Total Expenses',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),

              const SizedBox(height: 8.0),

              // Display individual expense items and their details
              Column(
                children: widget.expenseItems.map((item) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(item.name),
                        trailing: Text('Total: \$${item.totalAmount.toStringAsFixed(2)}'),
                      ),
                      // Optionally display item details when expanded
                      // You can use ExpansionPanel, ExpansionTile, or any other widget for this purpose
                    ],
                  );
                }).toList(),
              ),

              const SizedBox(height: 16.0),

              // Display the total amount of expenses
              Text(
                'Total Amount: \$${calculateTotalExpenses().toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 24.0),
              RoundedBorderArrowButton(
                buttonText: 'Go to Budget Summary',
                onPressed: () {
                  // Navigate to budget summary screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>const BudgetSummaryScreen(expenseItems: [], incomeItems: [], totalExpenses: 0.0, totalIncome: 0.0,
                        // Pass necessary parameters if required
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class ExpenseItem {
  final String name;
  final double amount;
  final int quantity;

  ExpenseItem({
    required this.name,
    required this.amount,
    required this.quantity,
  });

  double get totalAmount => amount * quantity;
}


class RoundedBorderArrowButton extends StatelessWidget {
  final String buttonText;
  final Function() onPressed;

  const RoundedBorderArrowButton({
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Colors.white, // Change the color to your preference
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
        side: const BorderSide(color: Colors.green), // You can change the border color here
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            buttonText,
            style: const TextStyle(
              color: Colors.green, // You can change the text color here
              fontWeight: FontWeight.bold,
            ),
          ),
          const Icon(
            Icons.arrow_forward,
            color: Colors.green, // You can change the arrow color here
          ),
        ],
      ),
    );
  }
}