import 'dart:collection' show MapView;
import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone/constans/firebase_field.dart';
import 'package:instagram_clone/state/posts/typedefs/user_id.dart';

@immutable
class UserInfoPayLoad extends MapView<String, String> {
  UserInfoPayLoad({
    required UserId userId,
    required String? displayName,
    required String? email,
  }) : super({
          //just super is enough to serialization
          FirebaseFieldName.userId: userId,
          FirebaseFieldName.displayName: displayName ?? '',
          FirebaseFieldName.email: email ?? '',
        });
}
