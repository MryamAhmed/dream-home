import 'package:pocketbase/pocketbase.dart';

import 'shared_prefs.dart';

/// [PocketBaseInstance] is used to get the instance of [PocketBase]
/// use [instance] getter to get the instance of [PocketBase]
class PocketBaseInstance {
  static PocketBase? _pocketBase;

  /// returns the instance of [PocketBase] if it is not null
  /// and if it is null then it will create a new instance of [PocketBase]
  static Future<PocketBase> get instance async {
    if (_pocketBase == null) {
      final prefs = await SharedPrefs.instance;

      // ─── Store and Retrieve the Auth Token in or from the shared preferences ─────────────────────
      final store = AsyncAuthStore(
        save: (String data) async => prefs.setString('pb_auth', data),
        initial: prefs.getString('pb_auth'),
      );

      _pocketBase = PocketBase('http://127.0.0.1:8090', authStore: store);
    }
    return _pocketBase!;
  }
}
