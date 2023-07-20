import 'dart:async';

import 'package:big_decimal/big_decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobileapp/actions/clear_estimated_fee.dart';
import 'package:mobileapp/actions/controller_fetch_data.dart';
import 'package:mobileapp/blockchainlibs/blockchain_lib.dart';
import 'package:mobileapp/events/blockchain/estimate_fee_request.dart';
import 'package:mobileapp/events/blockchain/estimate_fee_result.dart';
import 'package:mobileapp/events/blockchain/message/get_address_request.dart';
import 'package:mobileapp/events/enums/alert_level.dart';
import 'package:mobileapp/events/enums/coin.dart';
import 'package:mobileapp/events/enums/fee_level.dart';
import 'package:mobileapp/events/enums/fiat.dart';
import 'package:mobileapp/events/enums/key_scheme.dart';
import 'package:mobileapp/events/enums/request_transaction_type.dart';
import 'package:mobileapp/events/enums/signing_status.dart';
import 'package:mobileapp/events/keygenv2/keygen_member.dart';
import 'package:mobileapp/events/pricefeed/coin_price.dart';
import 'package:mobileapp/events/pricefeed/fiat_config.dart';
import 'package:mobileapp/events/signing/requests/eth_contract_request.dart';
import 'package:mobileapp/events/signing/requests/send_request.dart';
import 'package:mobileapp/events/signing/requests/send_token_request.dart';
import 'package:mobileapp/events/signing/signing_request.dart';
import 'package:mobileapp/events/system/alert.dart';
import 'package:mobileapp/events/wallet/wallet_creation_config.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/models/address_list_item.dart';
import 'package:mobileapp/models/blockchain_coin_item.dart';
import 'package:mobileapp/models/wallet_entity.dart';
import 'package:mobileapp/screens/v1/views/qr_scan_screen.dart';
import 'package:mobileapp/screens/v1/views/wait_signing_screen.dart';
import 'package:mobileapp/services/address_list_service.dart';
import 'package:mobileapp/services/currency_config.dart';
import 'package:mobileapp/services/kbus.dart';
import 'package:mobileapp/services/utils.dart';
import 'package:mobileapp/states/app_global_bloc.dart';

class CreateNewSigningController extends FxController {
  EthContractRequest? ethContractRequestDefault;

  BlockchainCoinItem blockchainCoinItem;
  bool isOnlyWhitelisted;
  List<KeygenMember> signers = [];
  TextEditingController toAddressController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  List<AddressListItem> addressList = [];
  String? smartContractMethod;
  RequestTransactionType? type;
  AddressListItem? selectedAddressListItem;
  FeeLevel feeLevel = FeeLevel.MEDIUM;
  static Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  CreateNewSigningController(
      {required this.blockchainCoinItem,
      required this.isOnlyWhitelisted,
      this.ethContractRequestDefault});

  @override
  void initState() async {
    super.initState();
    addressList = (await getIt<AddressListService>().findAll())
        .where((element) =>
            element.blockchain ==
                blockchainCoinItem.blockchainConfig.blockchain &&
            element.coin == blockchainCoinItem.coinConfig.coin &&
            (isOnlyWhitelisted ? element.isWhiteListed : true))
        .toList();

    if (ethContractRequestDefault != null) {
      toAddressController.text = ethContractRequestDefault!.toAddress;
      amountController.text =
          ethContractRequestDefault!.amount.toDouble().toString();
      // eg. 0x332dd1ae
      smartContractMethod = ethContractRequestDefault!.data.substring(0, 10);
      type = RequestTransactionType.ETH_SMART_CONTRACT_CALL;
    } else {
      type = RequestTransactionType.SEND;
    }
    getIt<KbusClient>().fireE(this, ControllerLoaded(context, getTag()));
    if (addressList.isNotEmpty) {
      update();
    }

    getIt<KbusClient>().action(this, ClearEstimatedFee());
    estimateFee();
    if (timer != null) {
      timer!.cancel();
      timer = Timer.periodic(const Duration(seconds: 30), (timer) {
        estimateFee();
      });
    } else {
      timer = Timer.periodic(const Duration(seconds: 30), (timer) {
        estimateFee();
      });
    }
  }

  void estimateFee() {
    WalletEntity wallet =
        getIt<AppGlobalBloc>().state.walletsState.defaultWallet!;
    KeyScheme keyScheme = blockchainCoinItem.blockchainConfig.keyScheme;
    var fromAddress = getIt<BlockchainLib>()
        .getAddress(GetAddressRequest(
            blockchain: blockchainCoinItem.blockchainConfig.blockchain,
            coin: blockchainCoinItem.coinConfig.coin,
            walletConfig: WalletCreationConfig(
                pubkeys: wallet.pubkeys,
                isMainnet: wallet.walletCreationConfig.isMainnet,
                isSegwit: wallet.walletCreationConfig.isSegwit)))
        .address;
    getIt<KbusClient>().action(
        this,
        EstimateFeeRequest(
            signingRequest: SigningRequest(
          requestTransactionType: type == RequestTransactionType.SEND &&
                  blockchainCoinItem.coinConfig.contractAddress != null
              ? RequestTransactionType.SEND_TOKEN
              : type!,
          blockchain: blockchainCoinItem.blockchainConfig.blockchain,
          coin: blockchainCoinItem.coinConfig.coin,
          walletId: wallet.walletId,
          keyScheme: keyScheme,
          createdAt: DateTime.now().toIso8601String(),
          feeLevel: feeLevel,
          status: SigningStatus.SIGNING_SESSION_CREATED,
          id: generateId("SI"),
          threshold: wallet.threshold,
          pubkey: wallet.pubkeys
              .firstWhere((element) => element.keyScheme == keyScheme)
              .pubkey,
          fromAddress: fromAddress,
          sendRequest: type == RequestTransactionType.SEND
              ? SendRequest(
                  amount: BigDecimal.parse("0"), toAddress: fromAddress)
              : null,
          sendTokenRequest: type == RequestTransactionType.SEND &&
                  blockchainCoinItem.coinConfig.contractAddress != null
              ? SendTokenRequest(
                  amount: BigDecimal.parse("0"),
                  toAddress: fromAddress,
                  decimals: blockchainCoinItem.coinConfig.decimals,
                  tokenContractAddress:
                      blockchainCoinItem.coinConfig.contractAddress!)
              : null,
          ethSmartContractRequest:
              type == RequestTransactionType.ETH_SMART_CONTRACT_CALL
                  ? EthContractRequest(
                      amount: BigDecimal.parse("0"),
                      data: ethContractRequestDefault!.data,
                      gasLimit: ethContractRequestDefault!.gasLimit,
                      toAddress: fromAddress)
                  : null,
          version: 0,
          signers: signers.map((e) => e.party_id).toList(),
        )));
  }

  @override
  String getTag() {
    return "create_new_signing_controller";
  }

  void goBack() {
    Navigator.pop(context);
  }

  submit(WalletEntity wallet, bool isOnlyWhitelist) async {
    // include all members without selection if it requires all members to sign
    if (wallet.threshold + 1 == wallet.noMembers) {
      signers = wallet.members;
    }
    if (type == RequestTransactionType.SEND && amountController.text == "") {
      getIt<KbusClient>().action(
          this,
          Alert(
              level: AlertLevel.ERROR,
              message: "Please enter an amount to send"));
      return;
    }
    if (signers.length != wallet.threshold + 1) {
      getIt<KbusClient>().action(
          this,
          Alert(
              level: AlertLevel.ERROR,
              message:
                  "Please select ${wallet.threshold + 1} signers to create a signing session"));
      return;
    }
    // check if address is in address list and whitelisted
    if (isOnlyWhitelist &&
        !(await isAddressInWhiteListed(toAddressController.text))) {
      getIt<KbusClient>().action(
          this,
          Alert(
              level: AlertLevel.ERROR,
              message: "Please select a whitelisted address to send to"));
      return;
    }
    if (type == RequestTransactionType.ETH_SMART_CONTRACT_CALL &&
        ethContractRequestDefault?.data == null) {
      getIt<KbusClient>().action(
          this,
          Alert(
              level: AlertLevel.ERROR,
              message: "Smart contract data is empty"));
      return;
    }

    bool authenticated = await getIt<LocalAuthentication>().authenticate(
      localizedReason: 'Scan your biometric to authenticate',
    );
    if (wallet.pubkeys.indexWhere((element) =>
            element.keyScheme ==
            blockchainCoinItem.blockchainConfig.keyScheme) ==
        -1) {
      getIt<KbusClient>().action(
          this,
          Alert(
              level: AlertLevel.ERROR,
              message:
                  "Wallet does not have a ${blockchainCoinItem.blockchainConfig.keyScheme} key"));
      return;
    }
    if (authenticated) {
      var keyScheme = blockchainCoinItem.blockchainConfig.keyScheme;
      getIt<KbusClient>().action(
        this,
        SigningRequest(
          requestTransactionType: type == RequestTransactionType.SEND &&
                  blockchainCoinItem.coinConfig.contractAddress != null
              ? RequestTransactionType.SEND_TOKEN
              : type!,
          blockchain: blockchainCoinItem.blockchainConfig.blockchain,
          coin: blockchainCoinItem.coinConfig.coin,
          walletId: wallet.walletId,
          keyScheme: keyScheme,
          createdAt: DateTime.now().toIso8601String(),
          feeLevel: feeLevel,
          status: SigningStatus.SIGNING_SESSION_CREATED,
          id: generateId("SI"),
          threshold: wallet.threshold,
          pubkey: wallet.pubkeys
              .firstWhere((element) => element.keyScheme == keyScheme)
              .pubkey,
          fromAddress: getIt<BlockchainLib>()
              .getAddress(GetAddressRequest(
                  blockchain: blockchainCoinItem.blockchainConfig.blockchain,
                  coin: blockchainCoinItem.coinConfig.coin,
                  walletConfig: WalletCreationConfig(
                      pubkeys: wallet.pubkeys,
                      isMainnet: wallet.walletCreationConfig.isMainnet,
                      isSegwit: wallet.walletCreationConfig.isSegwit)))
              .address,
          sendRequest: type == RequestTransactionType.SEND
              ? SendRequest(
                  amount: BigDecimal.parse(amountController.text),
                  toAddress: toAddressController.text)
              : null,
          sendTokenRequest: type == RequestTransactionType.SEND &&
                  blockchainCoinItem.coinConfig.contractAddress != null
              ? SendTokenRequest(
                  amount: BigDecimal.parse(amountController.text),
                  toAddress: toAddressController.text,
                  decimals: blockchainCoinItem.coinConfig.decimals,
                  tokenContractAddress:
                      blockchainCoinItem.coinConfig.contractAddress!)
              : null,
          ethSmartContractRequest:
              type == RequestTransactionType.ETH_SMART_CONTRACT_CALL
                  ? EthContractRequest(
                      amount: BigDecimal.parse(amountController.text),
                      data: ethContractRequestDefault!.data,
                      gasLimit: ethContractRequestDefault!.gasLimit,
                      toAddress: toAddressController.text)
                  : null,
          version: 0,
          signers: signers.map((e) => e.party_id).toList(),
        ),
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const WaitSigningScreen(),
        ),
      );
    }
  }

  addSigner(KeygenMember signer) {
    if (!signers.contains(signer)) {
      signers.add(signer);
    }
  }

  removeSigner(KeygenMember signer) {
    signers.remove(signer);
  }

  signerSelected(KeygenMember signer) {
    if (signers.contains(signer)) {
      removeSigner(signer);
    } else {
      addSigner(signer);
    }
  }

  scanQrCode() async {
    toAddressController.text = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const QrScanScreen(),
      ),
    );
  }

  setAddressListItem(AddressListItem? value) {
    selectedAddressListItem = value;
    toAddressController.text = value?.address ?? "";
  }

  copyToAddress() async {
    await Clipboard.setData(ClipboardData(text: toAddressController.text));
    getIt<KbusClient>().action(this,
        Alert(level: AlertLevel.INFO, message: "Address copied to clipboard"));
  }

  Future<bool> isAddressInWhiteListed(String address) async {
    return (await getIt<AddressListService>().findAll()).any((element) =>
        element.blockchain == blockchainCoinItem.blockchainConfig.blockchain &&
        element.coin == blockchainCoinItem.coinConfig.coin &&
        element.address == address &&
        element.isWhiteListed);
  }

  setFeeLevel(FeeLevel value) {
    feeLevel = value;
  }

  getFee(EstimateFeeResult estimatedFee) {
    if (feeLevel == FeeLevel.LOW) {
      return estimatedFee.lowEstimatedFee;
    } else if (feeLevel == FeeLevel.MEDIUM) {
      return estimatedFee.mediumEstimatedFee;
    } else if (feeLevel == FeeLevel.HIGH) {
      return estimatedFee.highEstimatedFee;
    }
  }

  convertToFiat(
      EstimateFeeResult estimatedFee, List<CoinPrice>? prices, Coin coin) {
    if (prices == null) {
      return "";
    }
    FiatConfig fiat = getIt<CurrencyConfig>().fiatConfigs[Fiat.USD]!;
    BigDecimal fee;
    if (feeLevel == FeeLevel.LOW) {
      fee = estimatedFee.lowEstimatedFee;
    } else if (feeLevel == FeeLevel.MEDIUM) {
      fee = estimatedFee.mediumEstimatedFee;
    } else {
      fee = estimatedFee.highEstimatedFee;
    }
    BigDecimal price = prices
        .firstWhere((element) => element.coin == coin)
        .coinPriceItems
        .firstWhere((element) => element.fiat == Fiat.USD)
        .price;
    return "~ ${fiat.symbol}${formatNumber(fee * price, size: 2)}";
  }
}
