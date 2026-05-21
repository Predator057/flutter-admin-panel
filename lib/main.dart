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
      body: Stack(
        children: [
          // Фон
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.jpg",
              fit: BoxFit.cover,
            ),
          ),
          // Контент по центру
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: actveColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "uid терминала:",
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                  const SizedBox(height: 8),
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
                      onChanged: (value) {
                        ref.read(configProvider.notifier).setIpTerm(value);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Пароль:",
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 250,
                    height: 40,
                    child: TextField(
                      obscureText: true, // ← рекомендую добавить для пароля
                      decoration: InputDecoration(
                        filled: true,
                        focusColor: Colors.white,
                        labelText: 'пароль',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (value) async {
                        ref
                            .read(configProvider.notifier)
                            .verifyHash(value.trim());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
