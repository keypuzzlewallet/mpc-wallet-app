import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobileapp/events/signing/signing_request.dart';
import 'package:mobileapp/services/signing_request_database.dart';
import 'package:mobileapp/services/wallet_service.dart';

class SigningService {
  final SigningRequestDatabase _signingRequestDatabase;
  final String key = "signing_request";
  final aOptions = const AndroidOptions(encryptedSharedPreferences: true);
  final iOptions =
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);
  SigningService(this._signingRequestDatabase);

  Future<void> updateSigningRequest(String? owner, SigningRequest signingRequestEntity) async {
    List<SigningRequest> signingRequestEntities = await findAll(owner);
    // replace an item or add
    int index = signingRequestEntities
        .indexWhere((element) => element.id == signingRequestEntity.id);
    if (index == -1) {
      signingRequestEntities.add(signingRequestEntity);
    } else {
      signingRequestEntities[index] = signingRequestEntity;
    }
    await _update(owner, signingRequestEntities);
  }

  Future<void> _update(String? owner, List<SigningRequest> signingRequestEntities) async {
    for (int i = 0; i < signingRequestEntities.length; i++) {
      await _signingRequestDatabase.save(owner ?? WalletService.offlineUserId, signingRequestEntities[i]);
    }
  }

  Future<List<SigningRequest>> findAll(String? owner) async {
    return _signingRequestDatabase.findAll(owner ?? WalletService.offlineUserId);
  }

  Future<SigningRequest?> findById(String id) async {
    return _signingRequestDatabase.findById(id);
  }
}
