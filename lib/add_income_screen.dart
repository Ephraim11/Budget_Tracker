import 'package:flutter/material.dart';
import 'budget_summary_screen.dart';

class AddIncomeScreen extends StatefulWidget {
  final List<IncomeItem> incomeItems;
  final Function(IncomeItem newItem) addItem; // Callback to add item

  const AddIncomeScreen({
    Key? key,
    required this.incomeItems,
    required this.addItem,
  }) : super(key: key);
  
  get expenseItems => [];

  @override
  _AddIncomeScreenState createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  TextEditingController incomeNameController = TextEditingController();
  TextEditingController incomeAmountController = TextEditingController();

  void addItem() {
    String name = incomeNameController.text;
    double amount = double.parse(incomeAmountController.text);

    IncomeItem newItem = IncomeItem(
      name: name,
      amount: amount,
    );

    widget.addItem(newItem); // Call the callback to add item to BudgetSummaryScreen

    incomeNameController.clear();
    incomeAmountController.clear();
  }

 Future<void> _navigateToAddIncomeScreen() async {
    final newItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddIncomeScreen(
          addItem: widget.addItem,
          incomeItems: widget.incomeItems,
        ),
      ),
    );

    if (newItem != null) {
      setState(() {
        widget.incomeItems.add(newItem);
      });
    }
  }


  // Calculate the total income using the widget.incomeItems list
  double calculateTotalIncome() {
    double total = 0.0;
    for (var item in widget.incomeItems) {
      total += item.amount;
    }
    return total;
  }

  // Implement the pushIncomesToBudgetSummary function
  void pushIncomesToBudgetSummary(BuildContext context, List<IncomeItem> incomeItems) {
    double totalIncome = calculateTotalIncome();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BudgetSummaryScreen(
          expenseItems: widget.expenseItems ?? [], // Initialize as empty list if null
          incomeItems: widget.incomeItems ?? [], // Use widget.incomeItems directly or initialize as empty list if null
          totalIncome: totalIncome,
          totalExpenses: 0.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 235, 210, 210),
      appBar: AppBar(
        title: const Text('Add Income'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Column(
            children: [
              // Income name field
              TextField(
                controller: incomeNameController,
                decoration: InputDecoration(
                  labelText: 'Income Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // Income amount field
              TextField(
                controller: incomeAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Income Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),

              const SizedBox(height: 24.0),

              // Add Income button
              ElevatedButton(
            onPressed: _navigateToAddIncomeScreen,
            child: const Text('Add Income'),
          ),

              const SizedBox(height: 16.0),

              // Total Income
              const Text(
                'Total Income',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),

              const SizedBox(height: 8.0),

              // Display individual income items and their details
              Column(
                children: widget.incomeItems.map((item) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(item.name),
                        trailing: Text('Amount: \$${item.amount.toStringAsFixed(2)}'),
                      ),
                      // Optionally display item details when expanded
                      // You can use ExpansionPanel, ExpansionTile, or any other widget for this purpose
                    ],
                  );
                }).toList(),
              ),

              const SizedBox(height: 16.0),

              // Display the total amount of income
              Text(
                'Total Amount: \$${calculateTotalIncome().toStringAsFixed(2)}',
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
                      builder: (context) => const BudgetSummaryScreen(expenseItems: [], incomeItems: [], totalExpenses: 0.0, totalIncome: 0.0,
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


class IncomeItem {
  final String name;
  final double amount;

  IncomeItem({
    required this.name,
    required this.amount,
  });
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