import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalu_potha/Transactions/model/monthly_total.dart';
import 'package:dalu_potha/Transactions/model/transaction_model.dart';
import 'package:dalu_potha/Transactions/summar_screen.dart';
import 'package:dalu_potha/enums/transaction_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../auth/model/customer_model.dart';
import '../database.dart';

class TransactionListScreen extends StatefulWidget {
  final Customer customer;
  final String email;
  const TransactionListScreen(
      {Key? key, required this.customer, required this.email})
      : super(key: key);

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  final DataRepository repository = DataRepository();
  TextEditingController dateController = TextEditingController();
  // format date in required form here we use yyyy-MM-dd that means time is removed

  DateTime selectedDate = DateTime.now();
  List<TransactionModel> _myList = [];
  Future<Null> _selectTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(), //get today's date
        firstDate: DateTime(
            2000), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101));

    if (pickedDate != null) {
      print(
          pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
      String formattedDate = DateFormat('yyyy-MM-dd').format(
          pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
      print(
          formattedDate); //formatted date output using intl package =>  2022-07-04
      //You can format date as per your need

      setState(() {
        dateController.text =
            formattedDate; //set foratted date to TextField value.
      });
    } else {
      print("Date is not selected");
    }
  }

  Color cardBgColor(String type) {
    switch (type) {
      case "Dalu":
        {
          return Colors.greenAccent;
        }

      case "tea":
        {
          return Colors.orangeAccent;
        }

      case "Advance":
        {
          return Colors.redAccent;
        }

      default:
        {
          return Colors.white;
        }
    }
  }

  String measureType(String type) {
    switch (type) {
      case "Dalu":
        {
          return "Kg";
        }

      case "tea":
        {
          return "";
        }

      case "Advance":
        {
          return "0";
        }

      default:
        {
          return "";
        }
    }
  }

  void showSummery(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text('Summery'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '1 kilo Price',
                        icon: Icon(Icons.one_k),
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        icon: Icon(Icons.email),
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Message',
                        icon: Icon(Icons.message),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd hh:mm').format(selectedDate);
    double total = 0;
    var amountController = TextEditingController();
    bool isFirstShow = false;
    List<double> monthlyTotal = [];
    int arrayIndex = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer.customerName ?? ""),
        actions: [
          IconButton(
              onPressed: () {
                showNewAlert();
              },
              icon: Icon(Icons.add)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SummeryScreen(
                            title: "",
                            lastMonthsList: getLastMonthRecords(_myList))));
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('user')
              .doc(widget.email)
              .collection("customers")
              .doc(widget.customer.referenceID)
              .get()
              .asStream(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            Customer customer = Customer.fromSnapshot(snapshot.data);

            _myList = customer.transactions;
            _myList.sort(
                (a, b) => a.transaction_dttm!.compareTo(b.transaction_dttm!));

            List<double> monthlyTotal = [];
            for (int i = 1; i < 13; i++) {
              monthlyTotal.add(0);
            }

            for (TransactionModel transactionModel in _myList) {
              String current_month = transactionModel.transaction_dttm!;
              String current_formated_month =
                  DateFormat.M().format(DateTime.parse(current_month));
              double currentAmount =
                  monthlyTotal[int.parse(current_formated_month)];
              currentAmount = currentAmount + transactionModel.amount!;
              monthlyTotal[int.parse(current_formated_month)] = currentAmount;
            }

            return ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: _myList.length,
                itemBuilder: (BuildContext context, int index) {
                  TransactionModel transactionModel = _myList[index];
                  if (index == 0) {
                    isFirstShow = true;
                  } else {
                    isFirstShow = false;
                  }
                  String current_month = _myList[index].transaction_dttm!;
                  String current_formated_month = DateFormat.yMMMM('en_US')
                      .format(DateTime.parse(current_month));

                  String current_formated_month_for_total =
                      DateFormat.M().format(DateTime.parse(current_month));

                  String next_dttm = "";
                  String next_formattedDate = "";
                  if (index != _myList.length - 1) {
                    next_dttm = _myList[index + 1].transaction_dttm!;
                    next_formattedDate = DateFormat.yMMMM('en_US')
                        .format(DateTime.parse(next_dttm));
                    arrayIndex++;
                    // if (current_formated_month != next_formattedDate) {
                    //   total = total + transactionModel.amount!;
                    //   // monthlyTotal.add(total);
                    //   total = 0;
                    //   arrayIndex++;
                    // } else {
                    //   total = total + transactionModel.amount!;
                    // }
                  }

                  // else {
                  //   total = 0;
                  //   _myList.reversed;
                  //   for (int backwordIndex = 0;
                  //       backwordIndex < _myList.length;
                  //       backwordIndex++) {
                  //     String current_month =
                  //         _myList[backwordIndex].transaction_dttm!;
                  //     String current_formated_month = DateFormat.yMMMM('en_US')
                  //         .format(DateTime.parse(current_month));
                  //
                  //     String privious_month =
                  //         _myList[backwordIndex + 1].transaction_dttm!;
                  //     String privious_formated_month = DateFormat.yMMMM('en_US')
                  //         .format(DateTime.parse(privious_month));
                  //
                  //     if (current_formated_month == privious_formated_month) {
                  //       total = total + _myList[backwordIndex].amount!;
                  //     }
                  //     break;
                  //   }
                  //
                  //   // monthlyTotal.add(total);
                  //   arrayIndex++;
                  // }

                  return Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        if (isFirstShow) Text(current_formated_month),
                        Card(
                          color:
                              cardBgColor(transactionModel.transaction_type!),
                          child: ListTile(
                            trailing: Text(transactionModel.amount.toString() +
                                measureType(
                                    transactionModel.transaction_type!)),
                            subtitle:
                                Text(transactionModel.transaction_dttm ?? ""),
                            title: Text(transactionModel.transaction_type!),
                          ),
                        ),
                        // (current_formated_month != next_formattedDate)
                        //     ? Row(
                        //         mainAxisAlignment: MainAxisAlignment.end,
                        //         children: [
                        //           Padding(
                        //             padding: const EdgeInsets.only(right: 8.0),
                        //             child: Text(
                        //                 "${monthlyTotal[int.parse(current_formated_month_for_total)]} Kg"),
                        //           ),
                        //         ],
                        //       )
                        //     : Container(),
                        (current_formated_month != next_formattedDate)
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: 16.0, left: 8),
                                child: Text(next_formattedDate),
                              )
                            : Container()
                      ]));

                  if (index == 0) {
                    String privious_date =
                        customer.transactions[index].transaction_dttm!;
                    String privious_formattedDate = DateFormat.MMMM('en_US')
                        .format(DateTime.parse(privious_date));
                    return Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(privious_formattedDate),
                          Card(
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(transactionModel.transaction_dttm ?? ""),
                                  Text(transactionModel.amount.toString() +
                                      " Kg")
                                ],
                              ),
                            ),
                          )
                        ]));
                  } else if (index == customer.transactions.length - 1) {
                    return Container(
                      child: Card(
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(transactionModel.transaction_dttm ?? ""),
                              Text(transactionModel.amount.toString() + " Kg")
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    String privious_date =
                        customer.transactions[index - 1].transaction_dttm!;
                    String next_dttm =
                        customer.transactions[index].transaction_dttm!;
                    String privious_formattedDate = DateFormat.MMMM('en_US')
                        .format(DateTime.parse(privious_date));
                    String next_formattedDate = DateFormat.MMMM('en_US')
                        .format(DateTime.parse(next_dttm));
                    if (privious_formattedDate == next_formattedDate) {
                      // monthTotal = monthTotal + transactionModel.amount!;
                    }
                    return Container(
                        child: Column(
                      children: [
                        (privious_formattedDate != next_formattedDate)
                            ? Text(next_formattedDate)
                            : Container(),
                        Card(
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(transactionModel.transaction_dttm ?? ""),
                                Text(transactionModel.amount.toString() + " Kg")
                              ],
                            ),
                          ),
                        ),
                        (privious_formattedDate != next_formattedDate)
                            ? Text("")
                            : Container()
                      ],
                    ));
                  }
                },
                separatorBuilder: (BuildContext context, int index) {
                  // String privious_date =
                  //     customer.transactions[index].transaction_dttm!;
                  // String next_dttm =
                  //     customer.transactions[index + 1].transaction_dttm!;
                  // String privious_formattedDate = DateFormat.MMMM('en_US')
                  //     .format(DateTime.parse(privious_date));
                  // String next_formattedDate = DateFormat.MMMM('en_US')
                  //     .format(DateTime.parse(next_dttm));
                  // if (privious_formattedDate != next_formattedDate) {
                  //   monthTotal = 0;
                  //   return Text(next_formattedDate.toString());
                  // }
                  return Container();
                });
          }),
    );
  }

  showNewAlert() {
    TransactionType _chosenValue = TransactionType.leaf;
    var amountController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text('Add New Amount'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: dateController,
                      decoration: InputDecoration(
                          labelText: 'Date',
                          icon: Icon(Icons.date_range),
                          suffix: IconButton(
                              onPressed: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        DateTime.now(), //get today's date
                                    firstDate: DateTime(
                                        2000), //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime.now());

                                if (pickedDate != null) {
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd').format(
                                          pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed

                                  setState(() {
                                    dateController.text =
                                        formattedDate; //set foratted date to TextField value.
                                  });
                                } else {
                                  print("Date is not selected");
                                }
                              },
                              icon: Icon(Icons.calendar_today))),
                    ),
                    StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return DropdownButton<TransactionType>(
                            value: _chosenValue,
                            onChanged: (newValue) {
                              setState(() {
                                _chosenValue = newValue!;
                              });
                            },
                            items: TransactionType.values
                                .map((TransactionType classType) {
                              return DropdownMenuItem<TransactionType>(
                                  value: classType,
                                  child: Text(classType.name));
                            }).toList());
                      },
                    ),
                    TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        icon: Icon(Icons.scale),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextButton(
                  child: Text("Save"),
                  onPressed: () {
                    print(_chosenValue);
                    double total = widget.customer.totalAmount +
                        double.parse(amountController.text);
                    TransactionModel tm = TransactionModel(
                        transaction_type: _chosenValue.name,
                        transaction_dttm: dateController.text,
                        amount: double.parse(amountController.text));
                    repository.updatePassengersConnectedWithDRiver(
                        widget.email, tm, widget.customer.referenceID!, total);
                    setState(() {});
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  List<TransactionModel> getLastMonthRecords(
      List<TransactionModel> currentList) {
    List<TransactionModel> lastMonthsList = [];
    String currentTransactionMonth = DateFormat.yMMMM('en_US')
        .format(DateTime.parse(currentList.last.transaction_dttm!));
    for (TransactionModel transactionModel in currentList) {
      String nextTransactionMonth = DateFormat.yMMMM('en_US')
          .format(DateTime.parse(transactionModel.transaction_dttm!));
      if (currentTransactionMonth == nextTransactionMonth) {
        lastMonthsList.add(transactionModel);
      }
    }
    return lastMonthsList;
  }
  // Future<Null> _selectDate(
  //   BuildContext context,
  // ) async {
  //   final DateTime? picked = await showDatePicker(
  //       context: context,
  //       initialDate: selectedDate,
  //       initialDatePickerMode: DatePickerMode.day,
  //       firstDate: DateTime(2015),
  //       lastDate: DateTime(2101));
  //   if (picked != null)
  //     setState(() {
  //       selectedDate = picked;
  //       _dateController.text = DateFormat.yMd().format(selectedDate);
  //     });
  // }
}
