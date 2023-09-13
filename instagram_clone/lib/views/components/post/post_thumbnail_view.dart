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
    return GestureDetector(
      onTap: onTapped,
      child: ImageNetwork(
        image: post.thumbnailUrl,
        fitAndroidIos: BoxFit.cover,
        fitWeb: BoxFitWeb.cover,
        fullScreen: true,
        height: 150,
        width: 150,
      ),
    );
  }
}
