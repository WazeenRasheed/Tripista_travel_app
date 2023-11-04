// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'package:flutter/material.dart';
import '../../Components/custom_button.dart';
import '../../Components/custom_textfield.dart';
import '../../Components/styles.dart';
import '../../Database/database_functions.dart';
import '../../Database/models/expense_model.dart';
import '../../Database/models/trip_model.dart';
import '../../Widgets/expense_grid.dart';

class ExpenseTab extends StatefulWidget {
  ExpenseTab({super.key, required this.trip});
  TripModal trip;

  @override
  State<ExpenseTab> createState() => _ExpenseTabState();
}

class _ExpenseTabState extends State<ExpenseTab> {
  final expenseController = TextEditingController();
  String expenseType = 'Food';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return ListView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [
        SizedBox(
          height: screenSize.height * 0.02,
        ),

        // Expenses
        Container(
          padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
          height: screenSize.height * 0.16,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6), topRight: Radius.circular(6)),
            color: Colors.blueGrey[700],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Expenses',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  InkWell(
                    onTap: () {
                      addExpensesBottomSheet(context);
                    },
                    child: CircleAvatar(
                      maxRadius: 18,
                      backgroundColor: backgroundColor,
                      child: Icon(Icons.add),
                    ),
                  )
                ],
              ),
              ValueListenableBuilder(
                valueListenable: totalExpenses,
                builder: (context, value, child) => Text(
                  '₹ $value',
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: backgroundColor,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.01,
              ),
              Row(
                children: [
                  const Text(
                    'Balance : ',
                    style: TextStyle(fontSize: 16, color: backgroundColor),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ValueListenableBuilder(
                    valueListenable: balanceNotifire,
                    builder: (context, value, child) => Text(
                      '₹ $value',
                      style: TextStyle(
                          fontSize: 18,
                          color: value <= 0 ? Colors.red : backgroundColor,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 14),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6)),
            color: Colors.blueGrey[400],
          ),

          // Expense per person
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Companions',
                    style: TextStyle(fontSize: 16, color: backgroundColor),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.01,
                  ),
                  FutureBuilder(
                    future: DatabaseHelper.instance
                        .getAllCompanions(widget.trip.id!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return Text(
                          '${snapshot.data!.length + 1}',
                          style: TextStyle(
                              fontSize: 18,
                              color: backgroundColor,
                              fontWeight: FontWeight.bold),
                        );
                      }
                      return const Text('1',
                          style: TextStyle(
                              fontSize: 18,
                              color: backgroundColor,
                              fontWeight: FontWeight.bold));
                    },
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expense per Person',
                    style: TextStyle(fontSize: 15, color: backgroundColor),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.01,
                  ),
                  FutureBuilder(
                    future: getCompanion(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        final expensePerPerson =
                            calculateExpensePerPerson(snapshot.data ?? 1);
                        return Text('₹ ${expensePerPerson.toStringAsFixed(1)}',
                            style: const TextStyle(
                                fontSize: 18,
                                color: backgroundColor,
                                fontWeight: FontWeight.bold));
                      }
                      return Text(
                        "₹ ${expenseNotifier.value[0].totalexpense}",
                        style: const TextStyle(
                            fontSize: 18,
                            color: backgroundColor,
                            fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: screenSize.height * 0.022,
        ),

        // Seperate expense
        ValueListenableBuilder(
          valueListenable: expenseNotifier,
          builder: (context, value, child) {
            final expense = expenseNotifier.value[0];
            return GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / .6,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15),
              children: [
                customGrid(
                    amount: expense.food!,
                    icon: Icons.restaurant_menu_rounded,
                    text: 'Food',
                    bgcolor: Colors.orange.shade100,
                    iconColor: Colors.orange),
                customGrid(
                    text: 'Transport',
                    amount: expense.transport!,
                    icon: Icons.directions,
                    bgcolor: Colors.blue.shade100,
                    iconColor: Colors.blue),
                customGrid(
                    text: 'Hotel',
                    amount: expense.hotel!,
                    icon: Icons.hotel_rounded,
                    bgcolor: Colors.purple.shade100,
                    iconColor: Colors.purple),
                customGrid(
                    text: 'Other',
                    amount: expense.other!,
                    icon: Icons.monetization_on,
                    bgcolor: Colors.green.shade100,
                    iconColor: Colors.green)
              ],
            );
          },
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

// bottomsheet
  addExpensesBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
      showDragHandle: true,
      backgroundColor: backgroundColor,
      elevation: 0,
      isScrollControlled: true,
      context: ctx,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: StatefulBuilder(
                builder: (context, refresh) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expense',
                        style: TextStyle(
                            color: accentColor, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: _formKey,
                        child: myTextField(
                          controller: expenseController,
                          keyboardType: TextInputType.number,
                          hintText: 'Enter amount',
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Expense is required';
                            } else if (value.contains(RegExp(r'[a-z]'))) {
                              return 'Expense must be numbers';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Catagory',
                        style: TextStyle(
                            color: accentColor, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // DropDownButton
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        height: 54,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: primaryColor),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: DropdownButton<String>(
                          icon: const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.keyboard_arrow_down_rounded,
                                size: 28),
                          ),
                          iconEnabledColor: primaryColor,
                          isExpanded: true,
                          underline: Container(),
                          value: expenseType,
                          onChanged: (String? newValue) {
                            refresh(() {
                              expenseType = newValue!;
                            });
                          },
                          items: <String>['Food', 'Transport', 'Hotel', 'Other']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(color: primaryColor),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      MyButton(
                        backgroundColor: primaryColor,
                        text: 'Add',
                        textColor: backgroundColor,
                        onTap: () async {
                          await _addToDatabase();
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  _addToDatabase() async {
    if (_formKey.currentState!.validate()) {
      // get expense obj
      List<Expenses> expList =
          await DatabaseHelper.instance.getExpense(widget.trip.id!);

      int? expense = int.tryParse(expenseController.text.trim());

      // update the seperate expense
      int updatedexp = expense ?? 0;
      if (expense == null) return;

      final type = expenseType.toLowerCase();
      final currentExp = expList[0];
      if (type == 'food') {
        updatedexp += currentExp.food!;
      } else if (type == 'transport') {
        updatedexp += currentExp.transport!;
      } else if (type == 'hotel') {
        updatedexp += currentExp.hotel!;
      } else if (type == 'other') {
        updatedexp += currentExp.other!;
      }
      // adding to database
      DatabaseHelper.instance.addExpences(
          balance: currentExp.balance!,
          expType: type,
          fieldExp: updatedexp,
          newExp: expense,
          oldExp: currentExp.totalexpense!,
          tripID: currentExp.tripID!);

      setState(() {
        expenseController.text = '';
      });

      Navigator.of(context).pop();
    }
    return;
  }

  // get the companion count
  Future<int> getCompanion() async {
    final companionList =
        await DatabaseHelper.instance.getAllCompanions(widget.trip.id!);
    final noOfCompanion = companionList.length;

    return noOfCompanion;
  }

// calculate expense per person
  double calculateExpensePerPerson(int noOfCompanion) {
    final totalExpenses = expenseNotifier.value.isEmpty
        ? 0
        : expenseNotifier.value[0].totalexpense!;
    final numberOfCompanions = noOfCompanion + 1;
    return totalExpenses / numberOfCompanions;
  }
}
