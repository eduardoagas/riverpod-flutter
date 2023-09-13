import 'dart:io';

import 'package:flutter/foundation.dart' show Uint8List, immutable;

import 'file_type.dart';

@immutable
class ThumbnailRequest {
  final File file;
  final Uint8List fileToWeb;
  final FileType fileType;

  const ThumbnailRequest({
    required this.file,
    required this.fileToWeb,
    required this.fileType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThumbnailRequest &&
          runtimeType == other.runtimeType &&
          file == other.file &&
          fileToWeb == other.fileToWeb &&
          fileType == other.fileType;

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        file,
        fileToWeb,
        fileType,
      ]);
}
