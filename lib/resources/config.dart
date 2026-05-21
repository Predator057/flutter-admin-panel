import 'package:admin_service/colors.dart';
import 'package:admin_service/providers/config_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfigSetScreen extends ConsumerStatefulWidget {
  const ConfigSetScreen({super.key});

  @override
  ConfigSetScreenState createState() => ConfigSetScreenState();
}

class ConfigSetScreenState extends ConsumerState<ConfigSetScreen> {
  String currOfd = "";
  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(configScreenProvider);
    currOfd = provider.currentOfd;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 100,
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            color: actveColor,
            child: Text(
              "Конфигурация",
              style: TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                ConfigRow(
                  title: "ip адресс робота:",
                  label: provider.ipRobot,
                  onSubmited: (s) {
                    ref.read(configScreenProvider.notifier).setIpRobot(s);
                  },
                ),
                Container(
                  height: 45,
                  color: const Color.fromARGB(113, 0, 0, 0),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 220,
                        height: 40,
                        child: Container(
                          alignment: Alignment.center,
                          color: cellColor,
                          child: Text("порт робота", style: _headerStyle),
                        ),
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: SizedBox(
                          height: 40,
                          child: Container(
                            alignment: Alignment.center,
                            color: cellColor,
                            child: TextField(
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly, // Только цифры 0-9
                              ],
                              decoration: InputDecoration(
                                filled: true,
                                focusColor: Colors.white,
                                labelText: provider.portRobot.toString(),
                                border: OutlineInputBorder(),
                              ),
                              onSubmitted: (value) {
                                if (value != "") {
                                  ref
                                      .read(configScreenProvider.notifier)
                                      .setPortRobot(int.parse(value));
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ConfigRow(
                  title: "ip адресс:порт ФР:",
                  label: provider.addrFr,
                  onSubmited: (s) {
                    ref.read(configScreenProvider.notifier).setIpKKT(s);
                  },
                ),
                ConfigRow(
                  title: "token API OFD:",
                  label: provider.tokenOfd,
                  onSubmited: (s) {
                    ref.read(configScreenProvider.notifier).setIpRobot(s);
                  },
                ),
                ConfigRow(
                  title: "Порт купюроприемника:",
                  label: provider.portBill,
                  onSubmited: (s) {
                    ref.read(configScreenProvider.notifier).setPortBill(s);
                  },
                ),
                ConfigRow(
                  title: "Таймаут скринсейвера:",
                  label: provider.timeoutScreenSaver.toString(),
                  onSubmited: (s) {
                    ref
                        .read(configScreenProvider.notifier)
                        .setTimeoutScreenSaver(int.parse(s));
                  },
                ),
                ConfigRow(
                  title: "Текст уведомление:",
                  label: provider.notifierText,
                  onSubmited: (s) {
                    ref.read(configScreenProvider.notifier).setTextNotifier(s);
                  },
                ),
                ConfigRow(
                  title: "Текст вызова оператора:",
                  label: provider.textAdmin,
                  onSubmited: (s) {
                    ref.read(configScreenProvider.notifier).setTextAdmin(s);
                  },
                ),
                ConfigRow(
                  title: "Время начала раб. дня:",
                  label: provider.timeBeginDay,
                  onSubmited: (s) {
                    ref.read(configScreenProvider.notifier).setTimeBeginDay(s);
                  },
                ),
                ConfigRow(
                  title: "Время окончания раб. дня:",
                  label: provider.timeEndDay,
                  onSubmited: (s) {
                    ref.read(configScreenProvider.notifier).setTimeEndDay(s);
                  },
                ),
                RadioGroup<String>(
                  onChanged: (s) {
                    if (s != null) {
                      print("выбрали сезон $s");
                      ref.read(configScreenProvider.notifier).setCurrentOfd(s);
                    }
                  },
                  groupValue: currOfd,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Ваш ОФД: ", style: _style),
                      SizedBox(
                        height: 50,
                        width: 260,
                        child: ListTile(
                          title: Text(r"ООО 'Ярус'", style: _style),
                          leading: Radio<String>(
                            activeColor: Colors.amber,
                            toggleable: true,
                            value: "ООО 'Ярус'",
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 50,
                        width: 200,
                        child: ListTile(
                          title: Text(r"Такском", style: _style),
                          leading: Radio<String>(
                            activeColor: Colors.amber,
                            toggleable: true,
                            value: "Такском",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Button(
                  content: "Сохранить",
                  onClick: () {
                    ref.read(configScreenProvider.notifier).saveChanged();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ConfigRow extends ConsumerStatefulWidget {
  final String title;
  final String label;
  final void Function(String) onSubmited;
  const ConfigRow({
    super.key,
    required this.title,
    required this.label,
    required this.onSubmited,
  });

  @override
  ConfigRowState createState() => ConfigRowState();
}

class ConfigRowState extends ConsumerState<ConfigRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      color: const Color.fromARGB(113, 0, 0, 0),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 220,
            height: 40,
            child: Container(
              alignment: Alignment.center,
              color: cellColor,
              child: Text(widget.title, style: _headerStyle),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: SizedBox(
              height: 40,
              child: Container(
                alignment: Alignment.center,
                color: cellColor,
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    focusColor: Colors.white,
                    labelText: widget.label,
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      widget.onSubmited(value);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Button extends StatelessWidget {
  final String content;
  final VoidCallback onClick;
  const Button({super.key, required this.content, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return (Container(
      width: 170,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: buttonGreen,
        border: Border.all(color: Colors.white38),
      ),
      child: TextButton(
        onPressed: () => onClick(),
        child: Text(content, style: _headerStyle),
      ),
    ));
  }
}

TextStyle _headerStyle = TextStyle(fontSize: 16, color: Colors.white);
TextStyle _style = TextStyle(fontSize: 26, color: Colors.white);
