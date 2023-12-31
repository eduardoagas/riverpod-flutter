import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/state/posts/models/post.dart';
import 'package:image_network/image_network.dart';

class PostThumbnailView extends StatelessWidget {
  final Post post;
  final VoidCallback onTapped;
  const PostThumbnailView(
      {super.key, required this.post, required this.onTapped});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTapped,
      child: (kIsWeb)
          ? ImageNetwork(
              onTap: onTapped,
              image: post.thumbnailUrl,
              //fitAndroidIos: BoxFit.cover,
              fitWeb: BoxFitWeb.fill,
              //fullScreen: true,
              height: size.width / 3,
              width: size.width / 3,
            )
          : Image.network(post.thumbnailUrl, fit: BoxFit.cover),
    );
  }
}
