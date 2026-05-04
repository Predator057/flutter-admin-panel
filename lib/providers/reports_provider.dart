import 'package:http/http.dart' as http;
import 'package:admin_service/terminal_types.dart';
import 'package:admin_service/ipadress.dart';
import 'package:riverpod/legacy.dart';
import 'dart:convert';

class ReportsState {
  final List<Transaction> transactions;
  final List<Transaction> filterTrs;
  final int count;
  final int toDayCount;
  final List<String> countsSales;
  const ReportsState({
    this.transactions = const [],
    this.filterTrs = const [],
    this.toDayCount = -1,
    this.count = -1,
    this.countsSales = const [],
  });

  ReportsState copyWith({
    List<Transaction>? transactions,
    List<Transaction>? filterTrs,
    int? count,
    int? toDayCount,
  }) {
    return ReportsState(
      transactions: transactions ?? this.transactions,
      filterTrs: filterTrs ?? this.filterTrs,
      count: count ?? this.count,
      toDayCount: toDayCount ?? this.toDayCount,
    );
  }
}

class ReportsNotifier extends StateNotifier<ReportsState> {
  ReportsNotifier() : super(const ReportsState());
  void getTransactions() async {
    try {
      var response = await http.get(
        Uri.http('$ipback:3030', '/api/get/transactions'),
        headers: {
          'Authorization': 'Bearer $apiToken',
        },
      );
      if (response.statusCode == 200) {
        print("Получены транзакции ${response.body}");
        Map<String, dynamic> jsonData = json.decode(response.body);
        final List<Transaction> newTransactions = [];
        if (jsonData.containsKey("transactions") &&
            jsonData["transactions"] is List) {
          for (dynamic t in jsonData["transactions"]) {
            if (t is Map<String, dynamic>) {
              newTransactions.add(
                Transaction(
                  t["id"] as int? ?? 0,
                  t["nr"] as String? ?? '',
                  _toOptionFromId(t["pro"]),
                  t["drt"] as int? ?? 0,
                  t["prs"] as double? ?? 0,
                  DateTime.parse(t["dts"] as String? ?? ''),
                  t["dte"] as String? ?? '',
                ),
              );
            } else {
              print("trs не map");
            }
          }
        }
        state = state.copyWith(transactions: newTransactions);
      } else {
        print("Ошибка trs = ${response.statusCode}");
      }
    } catch (e) {
      print("Ошибка получения истории транзакций: $e");
    }
  }

  List<Transaction> getCacheTrs() {
    return (state.transactions);
  }

  void getCountTransaction() async {
    try {
      var response = await http.get(
        Uri.http('$ipback:3030', '/api/transactions/count'),
        headers: {
          'Authorization': 'Bearer $apiToken',
        },
      );
      int count = int.parse(response.body);
      state = state.copyWith(count: count);
    } catch (e) {}
  }

  void addTransaction(Transaction t) async {
    try {
      var response = await http.post(
        Uri.http('$ipback:3030', '/api/post/transactions/add'),
        headers: {
          'Authorization': 'Bearer $apiToken',
        },
        body: jsonEncode(t),
      );
      if (response.statusCode == 200) {}
    } catch (e) {}
  }

  List<Transaction> filterTrsFromDate(
    DateTime begin,
    DateTime end,
    List<Transaction> transactions,
  ) {
    List<Transaction> temp = List.empty(growable: true);
    begin = DateTime(begin.year, begin.month, begin.day, 0, 0, 0, 0, 0);
    end = DateTime(
      end.year,
      end.month,
      end.day + 1,
      end.hour,
      end.minute,
      end.second,
    );
    print("trss = $transactions");
    for (var c in transactions) {
      if (!c.dateTimeStart.isBefore(begin) &&
          c.dateTimeStart.millisecondsSinceEpoch <=
              end.millisecondsSinceEpoch) {
        temp.add(c);
      }
    }
    return (temp);
  }

  double getSumToday() {
    double sum = 0;
    for (var t in getToDayTrs()) {
      sum += t.sum;
    }
    return (sum);
  }

  List<Transaction> getToDayTrs() {
    List<Transaction> temp = List.empty(growable: true);
    var now = DateTime.now();
    var begin = DateTime(now.year, now.month, now.day, 0, 0, 0, 0);
    var end = DateTime(begin.year, begin.month, begin.day + 1, 0, 0, 0, 0);
    print("trss = ${state.transactions}");
    for (var c in state.transactions) {
      if (!c.dateTimeStart.isBefore(begin) &&
          c.dateTimeStart.millisecondsSinceEpoch <=
              end.millisecondsSinceEpoch) {
        temp.add(c);
      }
    }
    return (temp);
  }

  List<String> _toOptionFromId(List<dynamic> data) {
    List<String> temp = [];
    print("options in data = ${data}");
    for (var o in data) {
      switch (o) {
        case 1:
          temp.add("Коврики");
          break;
        case 2:
          temp.add("Шасси");
          break;
        case 3:
          temp.add("Обдув");
          break;
        case 4:
          temp.add("Пылесос");
          break;
        case 5:
          temp.add("Антимоскит");
          break;
        default:
          temp.add("Неизв. опц.");
          break;
      }
    }
    return (temp);
  }
}

final reportsProvider = StateNotifierProvider<ReportsNotifier, ReportsState>(
  (ref) => ReportsNotifier(),
);
