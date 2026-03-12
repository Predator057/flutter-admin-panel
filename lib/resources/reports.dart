import 'dart:convert';
import 'dart:io';

import 'package:admin_service/colors.dart';
import 'package:admin_service/providers/reports_provider.dart';
import 'package:admin_service/terminal_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/button.dart';

class CSVStruct {
  final String header =
      "\ufeff#;name;опции;длительность;стоимость;дата/время начала;дата/время окончания\n";
  final List<Transaction> transactions;
  const CSVStruct(this.transactions);
  void saveToCsv() async {
    // Делайте async полностью
    String csv = header;
    for (var t in transactions) {
      String row =
          "${t.id};${t.nameRecipe};${t.paramsOption};${t.duration};${t.sum};${t.dateTimeStart};${t.dateTimeEnd}\n";
      csv += row; // Используйте += вместо "$csv$row"
    }
    print("csv =$csv");

    final now = DateTime.now();
    final filename =
        "${Platform.environment['USERPROFILE']}/Documents/wash_reports_${now.day}_${now.month}_${now.year} ${now.hour}-${now.minute}.csv";
    final file = File(filename);

    await file.writeAsString(csv, encoding: utf8); // async версия, без sync
  }
}

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  OptionsScreenState createState() => OptionsScreenState();
}

class OptionsScreenState extends ConsumerState<ReportsScreen> {
  String? season;
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();

  @override
  void initState() {
    super.initState();
    ref.read(reportsProvider.notifier).getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    List<Transaction> transactions = ref.watch(reportsProvider).transactions;
    if (transactions.isEmpty) {
      print("trs пуст");
      //ref.read(serviceProvider.notifier).initDB();
      ref.read(reportsProvider.notifier).getTransactions();
    }
    return (Expanded(
      child: Column(
        children: [
          Container(
            height: 100,
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            color: actveColor,
            child: Text(
              "ОТЧЕТЫ",
              style: TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 40),
          DatePickerRow(
            startChanged: (dt) {
              setState(() {
                start = dt;
              });
            },
            endChanged: (dt) {
              setState(() {
                end = dt;
              });
            },
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(164, 231, 245, 255),
                width: 3,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Button(
                  onClick: () {
                    setState(() {
                      ref.read(reportsProvider.notifier).getTransactions();
                    });
                  },
                  content: "🔄 обновить",
                ),
                Button(
                  onClick: () {
                    var csv = CSVStruct(
                      ref
                          .read(reportsProvider.notifier)
                          .filterTrsFromDate(start, end, transactions),
                    );
                    csv.saveToCsv();
                  },
                  content: "📥 загрузить *.csv",
                ),
              ],
            ),
          ),

          SizedBox(height: 20),
          Header(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var tr
                      in ref
                          .read(reportsProvider.notifier)
                          .filterTrsFromDate(start, end, transactions))
                    TransactionRow(tr),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

class TransactionRow extends StatelessWidget {
  final Transaction transaction;

  const TransactionRow(this.transaction, {super.key});
  @override
  Widget build(BuildContext context) {
    return (Container(
      height: 45,
      color: cellColor,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            alignment: Alignment.center,
            width: 40,
            height: 40,
            color: cellColor,
            child: Text(transaction.id.toString(), style: _style),
          ),
          Container(
            alignment: Alignment.center,
            width: 100,
            height: 40,
            color: cellColor,
            child: Text(transaction.nameRecipe.toString(), style: _style),
          ),
          Container(
            alignment: Alignment.center,
            width: 300,
            height: 40,
            color: cellColor,
            child: Text(
              transaction.paramsOption.isEmpty
                  ? "Без опций"
                  : transaction.paramsOption.toString(),
              style: _style,
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: 100,
            height: 40,
            color: cellColor,
            child: Text(transaction.duration.toString(), style: _style),
          ),
          Container(
            alignment: Alignment.center,
            width: 80,
            height: 40,
            color: cellColor,
            child: Text(transaction.sum.toString(), style: _style),
          ),
          Container(
            alignment: Alignment.center,
            width: 200,
            height: 40,
            color: cellColor,
            child: Text(transaction.dateTimeStart.toString(), style: _style),
          ),
          Container(
            alignment: Alignment.center,
            width: 200,
            height: 40,
            color: cellColor,
            child: Text(transaction.dateTimeEnd, style: _style),
          ),
        ],
      ),
    ));
  }
}

class Header extends StatelessWidget {
  const Header({super.key});
  @override
  Widget build(BuildContext context) {
    return (Container(
      height: 45,
      color: header,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            alignment: Alignment.center,
            width: 40,
            height: 40,
            color: cellColor,
            child: Text("#", style: _headerStyle),
          ),
          Container(
            alignment: Alignment.center,
            width: 100,
            height: 40,
            color: cellColor,
            child: Text("id_r", style: _headerStyle),
          ),
          Container(
            alignment: Alignment.center,
            width: 300,
            height: 40,
            color: cellColor,
            child: Text("опции", style: _headerStyle),
          ),
          Container(
            alignment: Alignment.center,
            width: 100,
            height: 40,
            color: cellColor,
            child: Text("длительность", style: _headerStyle),
          ),
          Container(
            alignment: Alignment.center,
            width: 80,
            height: 40,
            color: cellColor,
            child: Text("стоимость", style: _headerStyle),
          ),
          Container(
            alignment: Alignment.center,
            width: 200,
            height: 40,
            color: cellColor,
            child: Text("дата/время начала", style: _headerStyle),
          ),
          Container(
            alignment: Alignment.center,
            width: 200,
            height: 40,
            color: cellColor,
            child: Text("дата/время окончания", style: _headerStyle),
          ),
        ],
      ),
    ));
  }
}

class DatePickerRow extends StatelessWidget {
  final void Function(DateTime) startChanged;
  final void Function(DateTime) endChanged;
  const DatePickerRow({
    super.key,
    required this.startChanged,
    required this.endChanged,
  });

  @override
  Widget build(BuildContext context) {
    return (Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text("Фильтр по дате от: ", style: _style),
        DateInput(type: DateType.begin, onChanged: (dt) => startChanged(dt)),
        Text("до: ", style: _style),
        DateInput(type: DateType.end, onChanged: (dt) => endChanged(dt)),
      ],
    ));
  }
}

class DateInput extends StatefulWidget {
  final DateType type;
  final void Function(DateTime) onChanged;
  const DateInput({super.key, required this.type, required this.onChanged});

  @override
  State<StatefulWidget> createState() => DataInputState();
}

class DataInputState extends State<DateInput> {
  bool open = false;
  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return (Container(
      color: buttonRed,
      child: Row(
        children: [
          DateCell(
            date: date,
            isOpen: open,
            onChanged: (dt) {
              date = dt;
              widget.onChanged(dt);
            },
            onPressed: (v) {
              setState(() {
                open = v;
              });
            },
          ),
        ],
      ),
    ));
  }
}

class DateCell extends StatelessWidget {
  final bool isOpen;
  final void Function(bool) onPressed;
  final void Function(DateTime) onChanged;
  final DateTime date;
  const DateCell({
    required this.date,
    required this.isOpen,
    required this.onPressed,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return (Container(
      width: 280,
      color: cellColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(_dateTime(date), style: _style),
              Container(
                width: 50,
                height: 50,
                color: const Color.fromARGB(202, 255, 255, 255),
                child: TextButton(
                  onPressed: () {
                    onPressed(!isOpen);
                  },
                  child: Text("📅"),
                ),
              ),
            ],
          ),
          if (isOpen)
            Container(
              width: 280,
              height: 200,
              decoration: BoxDecoration(
                color: const Color.fromARGB(204, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
              ),
              child: CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                onDateChanged: (dt) {
                  onPressed(!isOpen);
                  onChanged(dt);
                },
              ),
            ),
        ],
      ),
    ));
  }
}

enum DateType { begin, end }

String _dateTime(DateTime dateTime) {
  String month = dateTime.month.toString();
  String day = dateTime.day.toString();

  if (dateTime.month < 10) {
    month = '0${dateTime.month}';
  }
  if (dateTime.day < 10) {
    day = '0${dateTime.day}';
  }
  String date = '$day.$month.${dateTime.year}';
  return date;
}

TextStyle _style = TextStyle(fontSize: 20, color: Colors.white);
TextStyle _headerStyle = TextStyle(fontSize: 14, color: Colors.white);
