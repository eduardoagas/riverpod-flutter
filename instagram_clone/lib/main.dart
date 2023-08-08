import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/providers/auth_state_providers.dart';
import 'package:instagram_clone/state/auth/providers/is_loading_provider.dart';
import 'package:instagram_clone/state/auth/providers/is_logged_in_provider.dart';
import 'package:instagram_clone/views/components/animations/empty_contents_animation_view.dart';
import 'package:instagram_clone/views/components/loading/loading_screen.dart';
import 'package:instagram_clone/views/login/login_view.dart';
import 'firebase_options.dart';

/*import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
} */

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blueGrey,
          indicatorColor: Colors.blueGrey,
        ),
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
        ),
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        home: Consumer(
          builder: (context, ref, child) {
            // take care of loading display

            ref.listen<bool>(isLoadingProvider, (_, isLoading) {
              if (isLoading) {
                LoadingScreen.instance().show(context: context);
              } else {
                LoadingScreen.instance().hide();
              }
            });

            final isLoggedIn = ref.watch(
                isLoggedInProvider); //watching for rebuilds, listenings for callbacks
            if (isLoggedIn) {
              return const MainView();
            } else {
              return const LoginView();
            }
          },
        ));
  }
}

//for when you are already logged
class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Title')),
      body: Consumer(
        builder: (_, ref, child) {
          return SingleChildScrollView(
            child: Column(children: [
              TextButton(
                  onPressed: () async {
                    await ref.read(authStateProvider.notifier).logOut();
                  },
                  child: const Text('Logout')),
              const EmptyContentsAnimationView(),
            ]),
          );
        },
      ),
    );
  }
}
