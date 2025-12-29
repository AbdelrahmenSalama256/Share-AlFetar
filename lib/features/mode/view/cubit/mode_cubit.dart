import 'package:bloc/bloc.dart';
import 'package:cozy/features/mode/data/repo/mode_repo.dart';

import 'mode_state.dart';

class ModeCubit extends Cubit<ModeState> {
  ModeCubit(this._repo)
      : super(const ModeState(mode: UserMode.requester, displayName: 'Guest'));

  final ModeRepo _repo;

  Future<void> loadMode() async {
    emit(state.copyWith(loading: true));
    final mode = await _repo.getMode();
    final name = await _repo.getDisplayName();
    emit(ModeState(mode: mode, displayName: name));
  }

  Future<void> setMode(UserMode mode) async {
    await _repo.setMode(mode);
    emit(state.copyWith(mode: mode));
  }

  Future<void> setDisplayName(String name) async {
    await _repo.setDisplayName(name);
    emit(state.copyWith(displayName: name));
  }
}
