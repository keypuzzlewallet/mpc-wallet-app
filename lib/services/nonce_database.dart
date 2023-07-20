import 'package:mobileapp/events/enums/key_scheme.dart';
import 'package:mobileapp/models/nonce_entity.dart';
import 'package:sqflite/sqflite.dart';

class NonceDatabase {
  final Database db;
  final table = "nonces";

  NonceDatabase(this.db);

  Future<void> updateNonce(String pubkey, KeyScheme keyScheme, int nonceStart,
      int nonceSize, int currentNonce) async {
    await await db.insert(table, _toDbRow(NonceEntity(
        pubkey: pubkey,
        keyScheme: keyScheme,
        nonceStart: nonceStart,
        nonceSize: nonceSize,
        currentNonce: currentNonce,
        updatedAt: DateTime.now(),
        createdAt: DateTime.now())),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateNonceIndex(String pubkey, KeyScheme keyScheme, int currentNonce) async {
    return db.update(table, {
      'currentNonce': currentNonce,
    }, where: 'pubkey = ? AND keyScheme = ?', whereArgs: [pubkey, keyScheme.name]);
  }

  Future<NonceEntity?> getNonce(String pubkey, KeyScheme keyScheme) async {
    List<Map<String, dynamic>> nonces = await db.query(table,
        where: 'pubkey = ? AND keyScheme = ?',
        whereArgs: [pubkey, keyScheme.name]);
    if (nonces.isEmpty) {
      return null;
    }
    return _fromDbRow(nonces[0]);
  }

  Map<String, dynamic> _toDbRow(NonceEntity nonce) {
    return {
      'pubkey': nonce.pubkey,
      'keyScheme': nonce.keyScheme.name,
      'nonceStart': nonce.nonceStart,
      'nonceSize': nonce.nonceSize,
      'currentNonce': nonce.currentNonce,
      'updatedAt': nonce.updatedAt.millisecondsSinceEpoch,
      'createdAt': nonce.createdAt.millisecondsSinceEpoch,
    };
  }

  NonceEntity _fromDbRow(Map<String, dynamic> row) {
    return NonceEntity(
      pubkey: row['pubkey'],
      keyScheme: KeyScheme.values
          .where((element) => element.name == row['keyScheme'])
          .first,
      nonceStart: row['nonceStart'],
      nonceSize: row['nonceSize'],
      currentNonce: row['currentNonce'],
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row['updatedAt']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(row['createdAt']),
    );
  }
}
