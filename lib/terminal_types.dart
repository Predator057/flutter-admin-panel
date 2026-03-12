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

class ConfigWithoutPass {
  final String ipRobot;
  final int portRobot;
  final String ipKKT;
  ConfigWithoutPass(this.ipRobot, this.portRobot, this.ipKKT);

  Map<String, dynamic> toJson() => {
    'ip_robot': ipRobot,
    'port_robot': portRobot,
    'ip_kkt': ipKKT,
  };
}

enum Seasons { summer, winter }
