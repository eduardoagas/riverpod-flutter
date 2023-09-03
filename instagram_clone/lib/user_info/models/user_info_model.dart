import 'dart:collection';

import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone/constants/firebase_field.dart';

import '../../state/posts/typedefs/user_id.dart';

@immutable
class UserInfoModel extends MapView<String, String?> {
  final UserId userId;
  final String displayName;
  final String? email;

  UserInfoModel({
    required this.userId,
    required this.displayName,
    required this.email,
  }) : super({
          FirebaseFieldName.userId: userId,
          FirebaseFieldName.displayName: displayName,
          FirebaseFieldName.email: email
        });

  UserInfoModel.fromJson(
    Map<String, dynamic> json, {
    required UserId userId,
  }) : this(
          userId: userId,
          displayName: json[FirebaseFieldName.displayName] ??
              '', //?? = "if you can't find it, then"
          email: json[FirebaseFieldName.email],
        );
}
