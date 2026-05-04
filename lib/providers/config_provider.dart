import 'package:http/http.dart' as http;
import 'package:admin_service/terminal_types.dart';
import 'package:admin_service/ipadress.dart';
import 'package:riverpod/legacy.dart';
import 'dart:convert';


class ConfigScrState {
  final String ipRobot;
  final int portRobot;
  final String addrFr;
  final String tokenOfd;
  final String portBill;
  final String currentOfd;
  final String currentSeason;
  final String notifierText;
  final int timeoutScreenSaver;
  const ConfigScrState({
    this.ipRobot = "192.168.9.3",
    this.portRobot = 3001,
    this.addrFr = '192.168.13.234',
    this.tokenOfd = '',
    this.portBill = '',
    this.currentOfd = '',
    this.currentSeason = '',
    this.notifierText = '',
    this.timeoutScreenSaver = 600,
  });

  ConfigScrState copyWith({String? ipRobot,
    int? portRobot,
    String? addrFr,
    String? tokenOfd,
    String? portBill,
    String? currentOfd,
    String? notifierText,
    int? timeoutScreenSaver,
  String? currentSeason,}) {
    return ConfigScrState(
      ipRobot: ipRobot ?? this.ipRobot,
      portRobot: portRobot ?? this.portRobot,
      tokenOfd: tokenOfd ?? this.tokenOfd,
      portBill: portBill ?? this.portBill,
      addrFr: addrFr ?? this.addrFr,
      currentOfd: currentOfd ?? this.currentOfd,
      currentSeason: currentSeason ?? this.currentSeason,
      notifierText: notifierText ?? this.notifierText,
      timeoutScreenSaver: timeoutScreenSaver ?? this.timeoutScreenSaver,
    );
  }
}

class ConfigScrNotifier extends StateNotifier<ConfigScrState> {
  ConfigScrNotifier() : super(const ConfigScrState());

  void loadConfig() async {
    try {
      var response = await http.get(
        Uri.http('$ipback:3030', '/api/config/GET'),
        headers: {
          'Authorization': 'Bearer $apiToken',
        },
      );
      if (response.statusCode == 200) {
        print("получен конфиг");
        Map<String, dynamic> jsonData = json.decode(response.body);
        state = state.copyWith(
          ipRobot: jsonData["ipv4_robot"] as String? ?? '',
          portRobot: jsonData["port_robot"] as int? ?? 3001,
          addrFr: jsonData["addr_fr"] as String? ?? '',
          tokenOfd: jsonData["token_ofd"] as String? ?? '',
          currentOfd: jsonData["current_ofd"] as String? ?? '',
          portBill: jsonData["port_bill"] as String? ?? '',
          notifierText: jsonData["notifier_text"] as String? ?? '',
          timeoutScreenSaver: jsonData["screen_saver_timeout"] as int? ?? 600,
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
    state = state.copyWith(addrFr: ip);
  }
  void setPortRobot(int port) {
    state = state.copyWith(portRobot: port);
  }
  void setPortBill(String port){
    state = state.copyWith(portBill: port);
  }
  void setAddrFr(String addr) {
    state = state.copyWith(addrFr: addr);
  }
  void setCurrentOfd(String ofd) {
    state = state.copyWith(currentOfd: ofd);
  }
  void setTextNotifier(String text) {
    state = state.copyWith(notifierText: text);
  }
  void setTimeoutScreenSaver(int timeout){
    state = state.copyWith(timeoutScreenSaver: timeout);
  }


  void saveChanged() async {
    Config config = Config(
      state.ipRobot,
      state.portRobot,
      state.addrFr,
      state.tokenOfd,
      state.currentSeason,
      state.portBill,
      state.currentOfd,
      state.notifierText,
      state.timeoutScreenSaver,
    );
    try {
      print("Сохраним конфиг");
      var response = await http.put(
        Uri.http('$ipback:3030', '/api/config/PUT/set'),
        headers: {
          'Content-Type': 'application/json', // Обязательный заголовок
          'Authorization': 'Bearer $apiToken',
        },
        body: jsonEncode(config),
      );
      print("Данные ${jsonEncode(config)}");
      print("response = ${response.statusCode}");
      if (response.statusCode == 200) {
        var saveResponse = await http.put(
          Uri.http('$ipback:3030', '/api/config/PUT/save'),
          headers: {
            'Authorization': 'Bearer $apiToken',
          },
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
