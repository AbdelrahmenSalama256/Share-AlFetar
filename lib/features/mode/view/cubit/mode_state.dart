import 'package:cozy/features/mode/data/repo/mode_repo.dart';

class ModeState {
  final UserMode mode;
  final String displayName;
  final bool loading;

  const ModeState({
    required this.mode,
    required this.displayName,
    this.loading = false,
  });

  ModeState copyWith({
    UserMode? mode,
    String? displayName,
    bool? loading,
  }) {
    return ModeState(
      mode: mode ?? this.mode,
      displayName: displayName ?? this.displayName,
      loading: loading ?? this.loading,
    );
  }
}
