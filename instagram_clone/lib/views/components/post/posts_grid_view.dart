import 'package:flutter/material.dart';
import 'package:instagram_clone/state/posts/models/post.dart';
import 'package:instagram_clone/views/components/post/post_thumbnail_view.dart';
import 'package:instagram_clone/views/post_comments/post_comments_view.dart';

class PostsGridView extends StatelessWidget {
  final Iterable<Post> posts;
  const PostsGridView({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, mainAxisSpacing: 8.0, crossAxisSpacing: 8.0),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts.elementAt(index);
        return PostThumbnailView(
            post: post,
            onTapped: () {
              //TODO: remove this code before details view impl
              print("tapped");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PostCommentView(postId: post.postId)));
              //TODO: navigate to the post details view
            });
      },
    );
  }
}
