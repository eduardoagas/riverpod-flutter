import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/constants/firebase_collection.dart';
import 'package:instagram_clone/constants/firebase_field.dart';
import 'package:instagram_clone/state/comments/extensions/comment_sorting_by_request.dart';
import 'package:instagram_clone/state/comments/models/comment.dart';
import 'package:instagram_clone/state/comments/models/post_comments_request.dart';
import 'package:instagram_clone/state/comments/models/post_with_comments.dart';
import 'package:instagram_clone/state/posts/models/post.dart';

final specificPostWithCommentsProvider = StreamProvider.family
    .autoDispose<PostWithComments, RequestForPostAndComments>(
  (ref, RequestForPostAndComments request) {
    final controller = StreamController<PostWithComments>();

    Post? post;
    Iterable<Comment>? comments;

    void notify() {
      final localPost = post;
      if (localPost == null) {
        return;
      }
      final outputComments = (comments ?? []).applySortingFrom(
        request,
      );
      final results =
          PostWithComments(post: localPost, comments: outputComments);
      controller.sink.add(results);
    }

    //watch changes to the post
    final postSub = FirebaseFirestore.instance
        .collection(
          FirebaseCollectionName.posts,
        )
        .where(FieldPath.documentId, isEqualTo: request.postId)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isEmpty) {
        post = null;
        comments = null;
        notify();
        return;
      }
      final doc = snapshot.docs.first;
      if (doc.metadata.hasPendingWrites) {
        return;
      }
      post = Post(
        postId: doc.id,
        json: doc.data(),
      );
      notify();
    });

    //watch changes to the comments
    final commentsQuery = FirebaseFirestore.instance
        .collection(
          FirebaseCollectionName.comments,
        )
        .where(FirebaseFieldName.postId, isEqualTo: request.postId)
        .orderBy(FirebaseFieldName.createdAt, descending: true);

    final limitedCommentsQuery = request.limit != null
        ? commentsQuery.limit(request.limit!)
        : commentsQuery;

    final commentsSub = limitedCommentsQuery.snapshots().listen((snapshot) {
      //if in firebase it changes, in UI must change too
      comments = snapshot.docs
          .where((doc) => !doc.metadata.hasPendingWrites)
          .map(
            (doc) => Comment(
              id: doc.id,
              doc.data(),
            ),
          )
          .toList();
      notify();
    });

    ref.onDispose(() {
      commentsSub.cancel();
      postSub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
