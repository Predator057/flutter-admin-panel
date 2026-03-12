import 'package:http/http.dart' as http;
import 'package:admin_service/terminal_types.dart';
import 'package:admin_service/ipadress.dart';
import 'package:riverpod/legacy.dart';
import 'dart:convert';

class ConfigScrState {
  final String ipRobot;
  final int portRobot;
  final String ipKKT;
  const ConfigScrState({
    this.ipRobot = "192.168.9.3",
    this.portRobot = 3001,
    this.ipKKT = '192.168.13.234',
  });

  ConfigScrState copyWith({String? ipRobot, int? portRobot, String? ipKKT}) {
    return ConfigScrState(
      ipRobot: ipRobot ?? this.ipRobot,
      portRobot: portRobot ?? this.portRobot,
      ipKKT: ipKKT ?? this.ipKKT,
    );
  }
}

class ConfigScrNotifier extends StateNotifier<ConfigScrState> {
  ConfigScrNotifier() : super(const ConfigScrState());

  void loadConfig() async {
    try {
      var response = await http.get(
        Uri.http('$ipback:3030', '/api/config/GET'),
      );
      if (response.statusCode == 200) {
        print("получен конфиг");
        Map<String, dynamic> jsonData = json.decode(response.body);
        state = state.copyWith(
          ipRobot: jsonData["ip_robot"] as String? ?? '',
          portRobot: jsonData["port_robot"] as int? ?? 3001,
          ipKKT: jsonData["ip_kkt"] as String? ?? '',
        );
      }
    } catch (e) {
      print("Не удалось загрузить корректный конфиг из RUST REST: $e");
    }
  }

  void setIpRobot(String ip) {
    state = state.copyWith(ipRobot: ip);
  }

  void setIpKKT(String ip) {
    state = state.copyWith(ipKKT: ip);
  }

  void setPortRobot(int port) {
    state = state.copyWith(portRobot: port);
  }

  void saveChanged() async {
    ConfigWithoutPass config = ConfigWithoutPass(
      state.ipRobot,
      state.portRobot,
      state.ipKKT,
    );
    try {
      var response = await http.put(
        Uri.http('$ipback:3030', '/api/config/PUT/set'),
        body: jsonEncode(config),
      );
      if (response.statusCode == 200) {
        var saveResponse = await http.put(
          Uri.http('$ipback:3030', '/api/config/PUT/save'),
        );
        if (saveResponse.statusCode == 200) {
          print('успешно сохранено');
        }
      }
    } catch (e) {
      print("Не удалось загрузить корректный конфиг из RUST REST: $e");
    }
  }
}

final configScreenProvider =
    StateNotifierProvider<ConfigScrNotifier, ConfigScrState>(
      (ref) => ConfigScrNotifier(),
    );
