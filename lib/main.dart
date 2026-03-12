import 'package:admin_service/colors.dart';
import 'package:admin_service/providers/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/left_tabs.dart';
import 'widgets/resource.dart';

GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Expanded(
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(color: actveColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "uid терминала:",
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),

                SizedBox(
                  width: 250,
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      focusColor: Colors.white,
                      labelText: 'логин',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {},
                  ),
                ),
                Text(
                  "Пароль:",
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
                SizedBox(
                  width: 250,
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      focusColor: Colors.white,
                      labelText: 'пароль',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) async {
                      ref.read(configProvider.notifier).verifyHash(value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool verify = ref.watch(configProvider).verify;
    if (verify) {
      return MaterialApp(
        title: 'Admin washer',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        home: const MyHomePage(title: 'Topaz Washer Home Page'),
      );
    } else {
      return MaterialApp(
        title: 'Admin washer',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        home: const LoginScreen(),
      );
    }
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LeftTabs(),
            Container(width: 10, color: const Color.fromARGB(54, 0, 0, 0)),
            Resource(),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
