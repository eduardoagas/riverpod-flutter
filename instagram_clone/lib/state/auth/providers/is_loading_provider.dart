import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'auth_state_providers.dart';

final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.isLoading;
});
