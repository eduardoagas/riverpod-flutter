import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/constants/firebase_collection.dart';
import 'package:instagram_clone/constants/firebase_field.dart';
import 'package:instagram_clone/state/comments/models/comment.dart';
import 'package:instagram_clone/state/posts/models/post.dart';
import 'package:instagram_clone/state/posts/typedefs/search_term.dart';

final postsBySearchProvider = StreamProvider.family
    .autoDispose<Iterable<Post>, SearchTerm>((ref, SearchTerm searchTerm) {
  final controller = StreamController<Iterable<Post>>();

  final sub = FirebaseFirestore.instance
      .collection(
        FirebaseCollectionName.posts,
      )
      .orderBy(FirebaseFieldName.createdAt, descending: true)
      .snapshots()
      .listen((snapshot) {
    final posts = snapshot.docs
        .map((doc) => Post(postId: doc.id, json: doc.data()))
        .where((post) => post.message.toLowerCase().contains(
              searchTerm.toLowerCase(),
            ));
    controller.sink.add(posts);
  });

  ref.onDispose(() {
    controller.close();
  });
  return controller.stream;
});
