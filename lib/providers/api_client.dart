import 'dart:convert';
import 'package:admin_service/ipadress.dart';
import 'package:riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:bcrypt/bcrypt.dart';

class ConfigState {
  final String ipTerm;
  final String base64Screen;
  final String ipRobot;
  final int portRobot;
  final String season;
  final bool verify;
  const ConfigState({
    this.ipTerm = "192.168.0.2",
    this.base64Screen = '',
    this.ipRobot = "192.168.9.3",
    this.portRobot = 3001,
    this.season = "",
    this.verify = false,
  });

  ConfigState copyWith({
    String? ipTerm,
    String? base64Screen,
    String? ipRobot,
    int? portRobot,
    String? season,
    bool? verify,
  }) {
    return ConfigState(
      ipTerm: ipTerm ?? this.ipTerm,
      ipRobot: ipRobot ?? this.ipRobot,
      portRobot: portRobot ?? this.portRobot,
      season: season ?? this.season,
      base64Screen: base64Screen ?? this.base64Screen,
      verify: verify ?? this.verify,
    );
  }
}

class ConfigNotifier extends StateNotifier<ConfigState> {
  ConfigNotifier() : super(const ConfigState());
  //static const ipback = "localhost";
  void loadConfig() async {
    try {
      var response = await http.get(
        Uri.http('$ipback:3030', '/api/get/config'),
        headers: {
          'Authorization': 'Bearer $apiToken',
        },
      );
      if (response.statusCode == 200) {
        print("инициализируем config");
        var jsonData = jsonDecode(response.body);
        state.copyWith(season: jsonData["current_season"]);
        print("season = ${jsonData["current_season"]}");
      }
    } catch (e) {
      print("Ошибка инициализации рецептов: $e");
    }
  }


  void setIpTerm(String ip) {
    state = state.copyWith(ipTerm: ip);
  }


  void setSeason(String season) async {
    try {
      var response = await http.patch(
        Uri.http('$ipback:3030', '/api/config/patch/season=$season'),
        headers: {
          'Authorization': 'Bearer $apiToken',
        },
      );
      if (response.statusCode == 200) {
        state = state.copyWith(season: season);
        print("Изменен сезон на $season");
      } else {
        print("Ошибка изменения сезона ${response.statusCode}");
      }
    } catch (e) {
      print("Ошибка изменения сезона на сервере: $e");
    }
  }

  void getSeason() async {
    try {
      var response = await http.get(
        Uri.http('$ipback:3030', '/api/config/get/season'),
        headers: {
        'Authorization': 'Bearer $apiToken',
      },
      );
      if (response.statusCode == 200) {
        state = state.copyWith(season: response.body);
      } else {
        print("Ошибка загрузки сезона ${response.statusCode}");
      }
    } catch (e) {
      print("Ошибка изменения сезона на сервере: $e");
    }
  }

  void updateScreen() async {
    try {
      var response = await http.get(
        Uri.http('$ipback:3030', '/api/GET/screenshot'),
        headers: {
          'Authorization': 'Bearer $apiToken',
        },
      );
      if (response.statusCode == 200) {
        print("Получен скриншот терминала");
        Map<String, dynamic> jsonData = json.decode(response.body);
        state = state.copyWith(base64Screen: jsonData["image"]);
      }
    } catch (e) {
      print("Ошибка получения скрина: $e");
    }
  }

  void verifyHash(String text) async {
    try {
      var response = await http.get(
        Uri.http('$ipback:3030', '/api/config/GET/hash'),
        headers: {
          'Authorization': 'Bearer $apiToken',
        },
      );
      if (response.statusCode == 200) {
        print("Получен хеш");
        String hashed = response.body.trim();
        state = state.copyWith(verify: BCrypt.checkpw(text, hashed));
      }
    } catch (e) {
      print("Ошибка получения хеша: $e");
    }
  }
}

final configProvider = StateNotifierProvider<ConfigNotifier, ConfigState>(
  (ref) => ConfigNotifier(),
);
