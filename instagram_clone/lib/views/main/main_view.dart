import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/state/auth/providers/auth_state_providers.dart';
import 'package:instagram_clone/state/image_upload/helpers/image_picker_helper.dart';
import 'package:instagram_clone/state/image_upload/models/file_type.dart';
import 'package:instagram_clone/state/post_settings/providers/post_settings_provider.dart';
import 'package:instagram_clone/views/components/dialogs/alert_dialog_model.dart';
import 'package:instagram_clone/views/components/dialogs/logout_dialog.dart';
import 'package:instagram_clone/views/crate_nem_post/create_new_post_view.dart';
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
                onPressed: () async {
                  final videoFile =
                      await ImagePickerHelper.pickVideoFromGallery();
                  if (videoFile == null) {
                    return;
                  }
                  ref.refresh(postSettingProvider);
                  if (!mounted) {
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateNewPostView(
                          fileToPost: videoFile, fileType: FileType.video),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.add_photo_alternate_outlined,
                ),
                onPressed: () async {
                  final imageFile =
                      await ImagePickerHelper.pickImageFromGallery();
                  if (imageFile == null) {
                    return;
                  }
                  ref.refresh(postSettingProvider);
                  if (!mounted) {
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateNewPostView(
                          fileToPost: imageFile, fileType: FileType.image),
                    ),
                  );
                },
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
                    child: Expanded(child: UserPostsView()),
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
