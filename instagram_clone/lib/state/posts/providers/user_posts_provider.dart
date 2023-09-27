import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/posts/models/post.dart';
import 'package:instagram_clone/state/posts/models/post_key.dart';

import '../../../constants/firebase_collection.dart';
import '../../../constants/firebase_field.dart';
import '../../auth/providers/user_id_provider.dart';

final userPostsProvider = StreamProvider.autoDispose<Iterable<Post>>((ref) {
  final userId = ref.watch(userIdProvider);
  final controller = StreamController<Iterable<Post>>();

  controller.onListen = () {
    controller.sink.add([]);
  };

  // if (kIsWeb) FirebaseFirestore.instance.enablePersistence();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.posts)
      .orderBy(FirebaseFieldName.createdAt, descending: true)
      .where(PostKey.userId, isEqualTo: userId)
      .snapshots()
      .listen((snapshot) {
    final documents = snapshot.docs;

    final posts = documents
        .where(
      (doc) => !doc.metadata.hasPendingWrites,
    )
        .map((doc) {
      //print(doc.metadata.isFromCache ? "NOT FROM NETWORK" : "FROM NETWORK");
      return Post(postId: doc.id, json: doc.data());
    });
    controller.sink.add(posts as Iterable<Post>);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
