import 'package:cozy/core/network/local_network.dart';

enum UserMode { requester, host }

class ModeRepo {
  ModeRepo(this.cacheHelper);
  final CacheHelper cacheHelper;

  static const _modeKey = 'share_fetaar_mode';
  static const _nameKey = 'share_fetaar_name';

  Future<UserMode> getMode() async {
    final cached = cacheHelper.getDataString(key: _modeKey);
    return _parseMode(cached);
  }

  Future<void> setMode(UserMode mode) async {
    await cacheHelper.setData(_modeKey, mode.name);
  }

  Future<String> getDisplayName() async {
    return cacheHelper.getDataString(key: _nameKey) ?? 'Guest';
  }

  Future<void> setDisplayName(String name) async {
    await cacheHelper.setData(_nameKey, name);
  }

  UserMode _parseMode(String? value) {
    if (value == 'host') return UserMode.host;
    return UserMode.requester;
  }
}
