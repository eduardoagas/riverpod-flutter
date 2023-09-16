import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:instagram_clone/state/auth/providers/auth_state_providers.dart';
import 'package:instagram_clone/state/image_upload/helpers/image_picker_helper.dart';
import 'package:instagram_clone/state/image_upload/models/file_type.dart';
import 'package:instagram_clone/state/post_settings/providers/post_settings_provider.dart';
import 'package:instagram_clone/state/posts/providers/user_posts_provider.dart';
import 'package:instagram_clone/views/components/dialogs/alert_dialog_model.dart';
import 'package:instagram_clone/views/components/dialogs/logout_dialog.dart';
import 'package:instagram_clone/views/create_new_post/create_new_post_view.dart';
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
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              Strings.appName,
            ),
            actions: [
              if (kIsWeb)
                SizedBox(
                  width: size.width * 0.3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Expanded(
                      ///child:
                      Center(
                        child: IconButton(
                            icon: const Icon(
                              Icons.refresh,
                            ),
                            onPressed: () async {
                              ref.invalidate(userPostsProvider);
                            }),
                      ),
                      //),
                      const SizedBox(),
                    ],
                  ),
                ),
              IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.film,
                ),
                onPressed: () async {
                  final videoFile = (kIsWeb)
                      ? await ImagePickerHelper.pickVideoFromGalleryWeb()
                      : await ImagePickerHelper.pickVideoFromGallery();
                  if (videoFile == null) {
                    return;
                  }
                  Uint8List videoData = (kIsWeb)
                      ? (videoFile as MediaInfo).data as Uint8List
                      : Uint8List.fromList(0 as List<int>);
                  final fileVideo = (kIsWeb)
                      ? File((videoFile as MediaInfo).base64 as String)
                      : File((videoFile as XFile).path);
                  ref.refresh(postSettingProvider);
                  if (!mounted) {
                    return;
                  }
                  final reloadPage = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateNewPostView(
                          fileWebToPost: videoData,
                          fileToPost: fileVideo,
                          fileType: FileType.video),
                    ),
                  );
                  if (reloadPage) {
                    ref.refresh(userPostsProvider);
                    return Future.delayed(const Duration(seconds: 1));
                  }
                },
              ),
              IconButton(
                  icon: const Icon(
                    Icons.add_photo_alternate_outlined,
                  ),
                  onPressed: () async {
                    final imageFile = (kIsWeb)
                        ? await ImagePickerHelper.pickImageFromGalleryWeb()
                        : ImagePickerHelper.pickImageFromGallery();
                    if (imageFile == null) {
                      return;
                    }
                    Uint8List imageData = (kIsWeb)
                        ? (imageFile as MediaInfo).data as Uint8List
                        : Uint8List.fromList(0 as List<int>);
                    final fileImage = (kIsWeb)
                        ? File((imageFile as MediaInfo).base64 as String)
                        : File((imageFile as XFile).path);
                    ref.refresh(postSettingProvider);
                    if (!mounted) {
                      return;
                    }
                    final reloadPage = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CreateNewPostView(
                            fileWebToPost: imageData,
                            fileToPost: fileImage,
                            fileType: FileType.image),
                      ),
                    );
                    if (reloadPage) {
                      ref.refresh(userPostsProvider);
                      return Future.delayed(const Duration(seconds: 1));
                    }
                  }),
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
