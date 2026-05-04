class Recipe {
  int id;
  double price;
  String name;
  bool isActive;
  List<Operation> operations;
  Recipe(this.id, this.price, this.name, this.isActive, this.operations);
  Map<String, dynamic> toJson() => {
    "id": id,
    "price": price,
    "name": name,
    "is_active": isActive,
    "operations": operations.map((op) => op.toJson()).toList(),
  };
}

class Operation {
  final String name;
  final int param;
  final int ratio;
  final int timeout;
  const Operation(this.name, this.param, this.ratio, this.timeout);
  Map<String, dynamic> toJson() => {
    "name": name,
    "param": param,
    "ratio": ratio,
    "timeout": timeout,
  };
}

class Option {
  final String param;
  double price;
  bool isActive;
  final String name;
  Option(this.param, this.price, this.isActive, this.name);
  Map<String, dynamic> toJson() => {
    "param": param,
    "price": price,
    "is_active": isActive,
    "name": name,
  };
}

class Transaction {
  final int id;
  final String nameRecipe;
  final List<String> paramsOption;
  final int duration;
  final double sum;
  final DateTime dateTimeStart;
  final String dateTimeEnd;
  const Transaction(
    this.id,
    this.nameRecipe,
    this.paramsOption,
    this.duration,
    this.sum,
    this.dateTimeStart,
    this.dateTimeEnd,
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'nr': nameRecipe,
    'pro': paramsOption,
    'drt': duration,
    'prs': sum,
    'dts': dateTimeStart,
    'dte': dateTimeEnd,
  };
}

class Config {
  final String ipRobot;
  final int portRobot;
  final String addrFr;
  final String currentSeason;
  final String tokenOfd;
  final String portBill;
  final String currentOfd;
  final String notifierText;
  final int timeoutScreenSaver;
  Config(this.ipRobot, this.portRobot, this.addrFr, this.currentSeason, this.tokenOfd, this.portBill, this.currentOfd, this.notifierText, this.timeoutScreenSaver);

  Map<String, dynamic> toJson() => {
    'ipv4_robot': ipRobot,
    'port_robot': portRobot,
    'addr_fr': addrFr,
    'current_season': currentSeason,
    'token_ofd': tokenOfd,
    'port_bill': portBill,
    'current_ofd': currentOfd,
    'notifier_text': notifierText,
    'screen_saver_timeout': timeoutScreenSaver,
  };
}
class Authorization {
  final String hash;
  final String login;
  Authorization(this.hash, this.login);
  Map<String, dynamic> toJson() =>{
    'hash': hash,
    'login': login,
  };
}

enum Seasons { summer, winter }
