import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/constants/firebase_collection.dart';
import 'package:instagram_clone/constants/firebase_field.dart';
import 'package:instagram_clone/state/posts/models/post.dart';

final allPostsProvider = StreamProvider.autoDispose<Iterable<Post>>((ref) {
  final controller = StreamController<Iterable<Post>>();
  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.posts)
      .orderBy(
        FirebaseFieldName.createdAt,
        descending: true,
      )
      .snapshots()
      .listen((snapshots) {
    final posts = snapshots.docs.map((doc) {
      return Post(json: doc.data(), postId: doc.id);
    });
    controller.sink.add(posts);
  });
  return controller.stream;
});
