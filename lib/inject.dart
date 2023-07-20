import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobileapp/actions/update_hot_wallet.dart';
import 'package:mobileapp/blockchainlibs/blockchain_lib.dart';
import 'package:mobileapp/blockchainlibs/tss_lib.dart';
import 'package:mobileapp/main.dart';
import 'package:mobileapp/models/app_config.dart';
import 'package:mobileapp/services/address_list_service.dart';
import 'package:mobileapp/services/currency_config.dart';
import 'package:mobileapp/services/kbus.dart';
import 'package:mobileapp/services/network_service.dart';
import 'package:mobileapp/services/nonce_database.dart';
import 'package:mobileapp/services/signing_request_database.dart';
import 'package:mobileapp/services/sse_service.dart';
import 'package:mobileapp/services/user_service.dart';
import 'package:mobileapp/services/wallet_database.dart';
import 'package:mobileapp/services/wallet_service.dart';
import 'package:mobileapp/signingserver/signing_server.dart';
import 'package:mobileapp/signingserver/signing_service.dart';
import 'package:mobileapp/states/app_global_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final getIt = GetIt.instance;

Future<void> setup(AppConfig appConfig) async {
  Database database = await openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'puzzlekey_database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) async {
      // Run the CREATE TABLE statement on the database.

      await db.execute(
        'CREATE TABLE wallets( ' // wallets
        'walletId TEXT PRIMARY KEY, '
        'pubkeys TEXT NOT NULL, '
        'name TEXT NOT NULL, '
        'signerName TEXT NOT NULL, '
        'noMembers INTEGER NOT NULL, '
        'threshold INTEGER NOT NULL, '
        'partyId INTEGER NOT NULL, '
        'createdAt INTEGER NOT NULL, '
        'encryptedKeygenResult TEXT NOT NULL, '
        'members TEXT NOT NULL, '
        'owner TEXT NOT NULL, '
        'walletCreationConfig TEXT NOT NULL, '
        'isHotSigningWallet INTEGER NOT NULL, '
        'enabledBlockchains TEXT NOT NULL);',
      );

      await db.execute(
        'CREATE TABLE nonces( ' // wallets
        'pubkey TEXT NOT NULL, '
        'keyScheme TEXT NOT NULL, '
        'nonceStart INTEGER NOT NULL, '
        'nonceSize INTEGER NOT NULL, '
        'currentNonce INTEGER NOT NULL, '
        'updatedAt INTEGER NOT NULL, '
        'createdAt INTEGER NOT NULL, '
        'PRIMARY KEY (pubkey, keyScheme));',
      );

      await db.execute('CREATE TABLE signing_requests( ' // signing_requests
          'id TEXT PRIMARY KEY, '
          'walletId TEXT NOT NULL, '
          'blockchain TEXT NOT NULL, '
          'coin TEXT NOT NULL, '
          'owner TEXT NOT NULL, '
          'keyScheme TEXT NOT NULL, '
          'pubkey TEXT NOT NULL, '
          'fromAddress TEXT NOT NULL, '
          'threshold INTEGER NOT NULL, '
          'requestTransactionType TEXT NOT NULL, '
          'status TEXT NOT NULL, '
          'message TEXT, '
          'signingResult TEXT, '
          'sendRequest TEXT, '
          'sendTokenRequest TEXT, '
          'ethSmartContractRequest TEXT, '
          'signers TEXT NOT NULL, '
          'feeLevel TEXT NOT NULL, '
          'fee TEXT, '
          'version INTEGER NOT NULL, '
          'createdAt INTEGER NOT NULL);');
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());
  const secureStorage = FlutterSecureStorage();
  final KbusClient kbus = KbusClient();
  final signingServer = SigningServer();
  final currencyConfig = CurrencyConfig();
  final signingService = SigningService(SigningRequestDatabase(database));
  final walletService = WalletService(secureStorage, WalletDatabase(database), NonceDatabase(database));
  final addressListService = AddressListService(secureStorage);
  await currencyConfig.init();
  final sseService = SseService(appConfig.backendHost, kbus);
  final tssLib = TssLib();
  final BlockchainLib blockchainLib = BlockchainLib();
  final auth = LocalAuthentication();
  var appGlobalBloc = AppGlobalBloc(kbus, walletService, sseService,
      blockchainLib, signingServer, tssLib, signingService);

  getIt.registerSingleton<NetworkService>(NetworkService());
  getIt.registerSingleton<CurrencyConfig>(currencyConfig);
  getIt.registerSingleton<AppConfig>(appConfig);
  getIt.registerSingleton<KbusClient>(kbus);
  getIt.registerSingleton<SigningServer>(signingServer);
  getIt.registerSingleton<WalletService>(walletService);
  getIt.registerSingleton<AddressListService>(addressListService);
  getIt.registerSingleton<SigningService>(signingService);
  getIt.registerSingleton<SseService>(sseService);
  getIt.registerSingleton<TssLib>(tssLib);
  getIt.registerSingleton<BlockchainLib>(blockchainLib);
  getIt.registerSingleton<LocalAuthentication>(auth);
  getIt.registerSingleton<AppGlobalBloc>(appGlobalBloc);
  getIt.registerSingleton<UserService>(UserService(secureStorage));

  kbus.fireE(StartScreen,
      UpdateHotWallet(appGlobalBloc.state.settingsState.isHotWallet));
}
