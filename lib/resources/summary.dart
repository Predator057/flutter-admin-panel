//import 'dart:async';
import 'dart:convert';
import 'package:admin_service/colors.dart';
import 'package:admin_service/providers/api_client.dart';
import 'package:admin_service/providers/reports_provider.dart';
import 'package:admin_service/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String _normalFormat(int val) {
  if (val < 10) {
    return "0$val";
  }
  return val.toString();
}

class Summary extends ConsumerStatefulWidget {
  const Summary({super.key});
  @override
  SummaryState createState() => SummaryState();
}

class SummaryState extends ConsumerState<Summary> {
  // Timer? timer;
  @override
  void initState() {
    super.initState();
    ref.read(configProvider.notifier).startTimerPeriodic(1000);
    ref.read(configProvider.notifier).getBestRecipe();
    ref.read(reportsProvider.notifier).getTransactions();
  }

  // @override
  // void dispose() {
  //   timer?.cancel();
  //   timer = null;
  //   super.dispose();
  // }

  // void _startTimer() {
  //   timer = Timer.periodic(const Duration(seconds: 10), (timer) {
  //     ref.read(configProvider.notifier).updateScreen();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    int best = ref.watch(configProvider.select((st) => st.bestId));
    String base = ref.watch(configProvider.select((st) => st.base64Screen));
    int count = ref.read(reportsProvider.notifier).getToDayTrs().length;
    return (Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 100,
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              color: actveColor,
              child: Text(
                "Сводка состояния",
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Button(
                  onClick: () {
                    setState(() {
                      ref.read(reportsProvider.notifier).getTransactions();
                    });
                  },
                  content: "🔄 обновить",
                ),
              ],
            ),
            Container(
              color: const Color.fromARGB(34, 42, 131, 145),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 250,
                            padding: EdgeInsets.all(10),
                            color: actveColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Сегодня моек",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  count.toString(),
                                  style: TextStyle(
                                    fontSize: 52,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          Container(
                            padding: EdgeInsets.all(10),
                            width: 300,
                            color: actveColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Чаще выбирают",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  ref.read(configProvider).bestId == 0
                                      ? "нет данных"
                                      : ref
                                            .read(configProvider)
                                            .bestId
                                            .toString(),
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          Container(
                            padding: EdgeInsets.all(10),
                            width: 250,
                            color: actveColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Сумма за сегодня",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "${ref.read(reportsProvider.notifier).getSumToday()}₽",
                                  style: TextStyle(
                                    fontSize: 52,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        """Экран терминала: Последнее обновление: ${_normalFormat(DateTime.now().hour)}:${_normalFormat(DateTime.now().minute)}:${_normalFormat(DateTime.now().second)}""",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          //fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Container(
                        height: 480,
                        padding: EdgeInsets.all(10),
                        color: actveColor,
                        child: Screenshot(base),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    ));
  }
}

class Screenshot extends ConsumerWidget {
  final String base;
  const Screenshot(this.base, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (base != '') {
      Image image = Image.memory(base64Decode(base));
      return (image);
    } else {
      return (Image.asset('assets/images/edit.png'));
    }
  }
}

class StateModule extends StatelessWidget {
  final String content;
  final Color color;

  const StateModule({super.key, required this.content, required this.color});
  @override
  Widget build(BuildContext context) {
    return (Container(
      height: 45,
      width: 280,
      decoration: BoxDecoration(color: color),
      child: Text(
        content,
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
          //fontWeight: FontWeight.bold,
        ),
      ),
    ));
  }
}

class DiagramDemo extends ConsumerWidget {
  const DiagramDemo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return (Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      height: 230,
      decoration: BoxDecoration(
        color: actveColor,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Рейтинг программ:",
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              //fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 180,
            child: Image.asset('assets/images/diagram.png'),
          ),
        ],
      ),
    ));
  }
}
