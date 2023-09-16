import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/providers/user_id_provider.dart';
import 'package:instagram_clone/state/image_upload/models/file_type.dart';
import 'package:instagram_clone/state/image_upload/models/thumbnail_request.dart';
import 'package:instagram_clone/state/image_upload/providers/image_uploader_provider.dart';
import 'package:instagram_clone/state/post_settings/providers/post_settings_provider.dart';
import 'package:instagram_clone/views/components/file_thumbnail_view.dart';
import 'package:instagram_clone/views/constants/strings.dart';

import '../../state/post_settings/models/post_setting.dart';

class CreateNewPostView extends StatefulHookConsumerWidget {
  final Uint8List fileWebToPost;
  final File fileToPost;
  final FileType fileType;
  const CreateNewPostView(
      {required this.fileWebToPost,
      required this.fileToPost,
      required this.fileType,
      super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateNewPostViewState();
}

class _CreateNewPostViewState extends ConsumerState<CreateNewPostView> {
  @override
  Widget build(BuildContext context) {
    final thumbnailRequest = ThumbnailRequest(
      file: widget.fileToPost,
      fileToWeb: widget.fileWebToPost,
      fileType: widget.fileType,
    );
    final postSettings = ref.watch(postSettingProvider);
    final postController = useTextEditingController();
    final isPostButtonEnabled = useState(false);
    useEffect(() {
      void listener() {
        isPostButtonEnabled.value = postController.text.isNotEmpty;
      }

      postController.addListener(listener);
      return () {
        postController.removeListener(listener);
      };
    }, [postController]);
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            Strings.createNewPost,
          ),
          actions: [
            IconButton(
              onPressed: isPostButtonEnabled.value
                  ? () async {
                      final userId = ref.read(
                        userIdProvider,
                      );
                      if (userId == null) return;
                      final message = postController.text;
                      final isUploaded = await ref
                          .read(imageUploadProvider.notifier)
                          .upload(
                              webfile: widget.fileWebToPost,
                              file: widget.fileToPost,
                              fileType: widget.fileType,
                              message: message,
                              postSettings: postSettings,
                              userId: userId);
                      if (isUploaded && mounted) {
                        Navigator.pop(context, true);
                      }
                    }
                  : null,
              icon: const Icon(Icons.send),
            )
          ]),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, //test this
          children: [
            FileThumbnailView(thumbnailRequest: thumbnailRequest),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                    labelText: Strings.pleaseWriteYourMessageHere),
                autofocus: true,
                maxLines: null,
                controller: postController,
              ),
            ),
            ...PostSetting.values.map((postSetting) => ListTile(
                //seems to be the same thing as adding tolist in the end
                title: Text(postSetting.description),
                subtitle: Text(postSetting.description),
                trailing: Switch(
                    value: postSettings[postSetting] ?? false,
                    onChanged: (isOn) {
                      ref.read(postSettingProvider.notifier).setSetting(
                            postSetting,
                            isOn,
                          );
                    })))
          ],
        ),
      ),
    );
  }
}
