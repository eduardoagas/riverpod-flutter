import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/image_upload/typedefs/is_loading.dart';
import 'package:instagram_clone/state/posts/notifiers/delete_posts_state_notifier.dart';

final deletePostProvider =
    StateNotifierProvider<DeletePostStateNotifier, IsLoading>(
        (_) => DeletePostStateNotifier());
