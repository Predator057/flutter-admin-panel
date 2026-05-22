import 'package:admin_service/providers/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:admin_service/terminal_types.dart';
import 'package:admin_service/ipadress.dart';
import 'package:riverpod/legacy.dart';
import 'dart:convert';

class OptionsState {
  final List<Option> options;
  const OptionsState({this.options = const []});

  OptionsState copyWith({
    String? base64Screen,
    List<Recipe>? recipes,
    List<Option>? options,
    List<Transaction>? transactions,
  }) {
    return OptionsState(options: options ?? this.options);
  }
}

class OptionsNotifier extends StateNotifier<OptionsState> {
  final Ref ref;
  OptionsNotifier(this.ref) : super(const OptionsState());
  void initDB() async {
    String ipback = ref.read(configProvider).ipTerm;
    try {
      var response = await http.get(
        Uri.http('$ipback:3030', '/api/option'),
        headers: {'Authorization': 'Bearer $apiToken'},
      );
      if (response.statusCode == 200) {
        print("инициализируем опции");
      }
    } catch (e) {
      print("Ошибка инициализации опций: $e");
    }
  }

  void setActive(String param, bool val) async {
    List<Option> options = state.options;
    for (var o in options) {
      if (o.param == param) {
        o.isActive = val;
        state = state.copyWith(options: options);
      }
    }
  }

  void setPrice(String param, double price) {
    List<Option> options = state.options;
    for (var o in options) {
      if (o.param == param) {
        o.price = price;
        state = state.copyWith(options: options);
      }
    }
  }

  void saveState() async {
    try {
      String ipback = ref.read(configProvider).ipTerm;
      var response = await http.put(
        Uri.http('$ipback:3030', '/api/put/options/confirm'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
        body: jsonEncode(state.options),
      );
      print("сохраним = ${jsonEncode(state.options)}");
      if (response.statusCode == 200) {
        print("сохранили");
      } else {
        print("Не удалось сохранить ${response.statusCode}");
      }
    } catch (e) {
      print("Не удалось сохранить $e");
    }
  }

  void getOptions() async {
    try {
      String ipback = ref.read(configProvider).ipTerm;
      var response = await http.get(
        Uri.http('$ipback:3030', '/api/get/options'),
        headers: {'Authorization': 'Bearer $apiToken'},
      );
      if (response.statusCode == 200) {
        print("Получены опции ${response.body}");
        Map<String, dynamic> jsonData = json.decode(response.body);
        final List<Option> newOptions = [];
        if (jsonData.containsKey("options") && jsonData["options"] is List) {
          for (dynamic r in jsonData["options"]) {
            if (r is Map<String, dynamic>) {
              newOptions.add(
                Option(
                  r["param"] as String? ?? '',
                  (r["price"] as num?)?.toDouble() ?? 0,
                  r["is_active"] as bool? ?? false,
                  r["name"] as String? ?? '',
                ),
              );
            }
          }
        }
        state = state.copyWith(options: newOptions);
      }
    } catch (e) {
      print("Ошибка получения опций: $e");
    }
  }
}

final optionsProvider = StateNotifierProvider<OptionsNotifier, OptionsState>(
  (ref) => OptionsNotifier(ref),
);
