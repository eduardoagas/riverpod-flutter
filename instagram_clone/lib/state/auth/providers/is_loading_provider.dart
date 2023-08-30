import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../image_upload/providers/image_uploader_provider.dart';
import 'auth_state_providers.dart';

final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  final isUploadingImage = ref.watch(imageUploadProvider);
  return authState.isLoading || isUploadingImage;
});
