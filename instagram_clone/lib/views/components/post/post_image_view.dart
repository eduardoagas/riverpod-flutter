import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';

import '../../../state/posts/models/post.dart';

class PostImageView extends StatelessWidget {
  final Post post;
  const PostImageView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AspectRatio(
      aspectRatio: post.aspectRatio,
      child: (kIsWeb)
          ? ImageNetwork(
              //onTap: onTapped,
              image: post.fileUrl,
              fitAndroidIos: BoxFit.cover,
              fitWeb: BoxFitWeb.cover,
              fullScreen: true,
              height: size.width,
              width: size.width,
              onLoading: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Image.network(
              post.fileUrl,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
    );
  }
}
