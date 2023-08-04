import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone/constans/firebase_collection.dart';
import 'package:instagram_clone/constans/firebase_field.dart';
import 'package:instagram_clone/state/posts/typedefs/user_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/user_info/models/user_info_payload.dart';

@immutable
class UserInfoStorage {
  const UserInfoStorage();

  Future<bool> saveUserInfo({
    required UserId userId,
    required String displayName,
    required String? email,
  }) async {
    try {
      //first check if we have this user's info
      final userInfo = await FirebaseFirestore.instance
          .collection(
            FirebaseCollectionName.users,
          )
          .where(FirebaseFieldName.userId, isEqualTo: userId)
          .limit(1)
          .get();

      if (userInfo.docs.isNotEmpty) {
        await userInfo.docs.first.reference.update({
          FirebaseFieldName.displayName: displayName,
          FirebaseFieldName.email: email,
        });
        return true;
      }

      final payload = UserInfoPayLoad(
          userId: userId, displayName: displayName, email: email);
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .add(payload);

      return true;
    } catch (e) {
      return false;
    }
  }
}
