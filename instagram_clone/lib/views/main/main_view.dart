import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/providers/auth_state_providers.dart';
import 'package:instagram_clone/views/components/dialogs/alert_dialog_model.dart';
import 'package:instagram_clone/views/components/dialogs/logout_dialog.dart';
import 'package:instagram_clone/views/tabs/user_posts/user_posts_view.dart';

import '../constants/strings.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              Strings.appName,
            ),
            actions: [
              IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.film,
                ),
                onPressed: () async {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.add_photo_alternate_outlined,
                ),
                onPressed: () async {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.logout,
                ),
                onPressed: () async {
                  final shoudLogOut = await const LogoutDialog()
                      .present(context)
                      .then((value) => value ?? false);
                  if (shoudLogOut) {
                    await ref.read(authStateProvider.notifier).logOut();
                  }
                },
              ),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.person),
                ),
                Tab(
                  icon: Icon(Icons.search),
                ),
                Tab(
                  icon: Icon(Icons.home),
                )
              ],
            ),
          ),
          body: const TabBarView(children: [
            (kIsWeb)
                ? SingleChildScrollView(
                    child: UserPostsView(),
                  )
                : UserPostsView(),
            (kIsWeb)
                ? SingleChildScrollView(
                    child: UserPostsView(),
                  )
                : UserPostsView(),
            (kIsWeb)
                ? SingleChildScrollView(
                    child: UserPostsView(),
                  )
                : UserPostsView(),
          ])),
    );
  }
}