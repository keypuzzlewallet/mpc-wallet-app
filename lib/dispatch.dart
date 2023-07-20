import 'package:mobileapp/events/signing/hot_signing_request.dart';
import 'package:mobileapp/events/signing/get_signing_list_request.dart';
import 'package:mobileapp/events/signing/protected_register_hot_wallet.dart';
import 'package:mobileapp/events/signing/signed_partial_signature_base64.dart';
import 'package:mobileapp/events/signing/signing_state_base64.dart';
import 'package:mobileapp/events/signing/signing_result.dart';
import 'package:mobileapp/events/signing/native_signing_request.dart';
import 'package:mobileapp/events/signing/signing_session_failed.dart';
import 'package:mobileapp/events/signing/get_signing_list_result.dart';
import 'package:mobileapp/events/signing/signing_hash.dart';
import 'package:mobileapp/events/signing/signing_request.dart';
import 'package:mobileapp/events/signing/signature_recid_hex.dart';
import 'package:mobileapp/events/signing/requests/send_request.dart';
import 'package:mobileapp/events/signing/requests/eth_contract_request.dart';
import 'package:mobileapp/events/signing/requests/send_token_request.dart';
import 'package:mobileapp/events/keygenv2/native_keygen_request.dart';
import 'package:mobileapp/events/keygenv2/protected_hot_wallet_generate_nonce_request.dart';
import 'package:mobileapp/events/keygenv2/native_generate_dynamic_nonce_request.dart';
import 'package:mobileapp/events/keygenv2/issue_index_msg.dart';
import 'package:mobileapp/events/keygenv2/protected_update_hot_wallet_nonce.dart';
import 'package:mobileapp/events/keygenv2/keygen_member.dart';
import 'package:mobileapp/events/keygenv2/hot_wallet_generate_nonce_request.dart';
import 'package:mobileapp/events/keygenv2/encrypted_keygen_with_scheme.dart';
import 'package:mobileapp/events/keygenv2/hot_wallet_keygen_request.dart';
import 'package:mobileapp/events/keygenv2/encrypted_local_key.dart';
import 'package:mobileapp/events/keygenv2/keygen_progress.dart';
import 'package:mobileapp/events/keygenv2/issued_unique_idx.dart';
import 'package:mobileapp/events/keygenv2/encrypted_keygen_result.dart';
import 'package:mobileapp/events/pricefeed/coin_price.dart';
import 'package:mobileapp/events/pricefeed/coin_prices.dart';
import 'package:mobileapp/events/pricefeed/coin_price_item.dart';
import 'package:mobileapp/events/pricefeed/fiat_config.dart';
import 'package:mobileapp/events/blockchain/transaction_included.dart';
import 'package:mobileapp/events/blockchain/generate_transaction_error.dart';
import 'package:mobileapp/events/blockchain/generate_transaction_request.dart';
import 'package:mobileapp/events/blockchain/sign_transaction_request.dart';
import 'package:mobileapp/events/blockchain/generate_transaction_response.dart';
import 'package:mobileapp/events/blockchain/estimate_fee_result.dart';
import 'package:mobileapp/events/blockchain/transaction_signed.dart';
import 'package:mobileapp/events/blockchain/unspent_output.dart';
import 'package:mobileapp/events/blockchain/estimate_fee_request.dart';
import 'package:mobileapp/events/blockchain/transaction_broadcasted.dart';
import 'package:mobileapp/events/blockchain/config/blockchain_config.dart';
import 'package:mobileapp/events/blockchain/config/blockchain_coin_config.dart';
import 'package:mobileapp/events/blockchain/config/coin_config.dart';
import 'package:mobileapp/events/blockchain/config/config_for_blockchain.dart';
import 'package:mobileapp/events/blockchain/message/create_transaction_result.dart';
import 'package:mobileapp/events/blockchain/message/create_sign_transaction_request.dart';
import 'package:mobileapp/events/blockchain/message/verify_transaction_request.dart';
import 'package:mobileapp/events/blockchain/message/verify_transaction_result.dart';
import 'package:mobileapp/events/blockchain/message/get_address_result.dart';
import 'package:mobileapp/events/blockchain/message/create_transaction_request.dart';
import 'package:mobileapp/events/blockchain/message/get_address_request.dart';
import 'package:mobileapp/events/blockchain/message/create_sign_transaction_result.dart';
import 'package:mobileapp/events/blockchain/message/params/request_params_eth_legacy.dart';
import 'package:mobileapp/events/blockchain/message/params/request_params_btc.dart';
import 'package:mobileapp/events/blockchain/message/params/request_params_ada.dart';
import 'package:mobileapp/events/blockchain/message/params/request_params_eth_eip1559.dart';
import 'package:mobileapp/events/system/alert.dart';
import 'package:mobileapp/events/emailservice/email_action_request.dart';
import 'package:mobileapp/events/emailservice/protected_email_action_verify.dart';
import 'package:mobileapp/events/bitcoinworker/wallet_balance_update.dart';
import 'package:mobileapp/events/bitcoinworker/send_raw_transaction_request.dart';
import 'package:mobileapp/events/wallet/wallet_creation_config_pubkey.dart';
import 'package:mobileapp/events/wallet/client_wallet_loaded.dart';
import 'package:mobileapp/events/wallet/enabled_blockchain.dart';
import 'package:mobileapp/events/wallet/wallet_creation_config.dart';
import 'package:mobileapp/events/publicapi/user_ping.dart';
import 'dart:convert';
import 'package:event_bus/event_bus.dart';
dispatchToStore(EventBus eventBus, String eventType, String eventData) {
  if (eventType == (HotSigningRequest).runtimeType.toString()) {
    eventBus.fire(HotSigningRequest.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == GetSigningListRequest.name()) {
    eventBus.fire(GetSigningListRequest.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == ProtectedRegisterHotWallet.name()) {
    eventBus.fire(ProtectedRegisterHotWallet.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == SignedPartialSignatureBase64.name()) {
    eventBus.fire(SignedPartialSignatureBase64.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == SigningStateBase64.name()) {
    eventBus.fire(SigningStateBase64.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == SigningResult.name()) {
    eventBus.fire(SigningResult.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == NativeSigningRequest.name()) {
    eventBus.fire(NativeSigningRequest.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == SigningSessionFailed.name()) {
    eventBus.fire(SigningSessionFailed.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == GetSigningListResult.name()) {
    eventBus.fire(GetSigningListResult.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == SigningHash.name()) {
    eventBus.fire(SigningHash.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == SigningRequest.name()) {
    eventBus.fire(SigningRequest.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == SignatureRecidHex.name()) {
    eventBus.fire(SignatureRecidHex.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == SendRequest.name()) {
    eventBus.fire(SendRequest.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == EthContractRequest.name()) {
    eventBus.fire(EthContractRequest.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == SendTokenRequest.name()) {
    eventBus.fire(SendTokenRequest.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == NativeKeygenRequest.name()) {
    eventBus.fire(NativeKeygenRequest.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == ProtectedHotWalletGenerateNonceRequest.name()) {
    eventBus.fire(ProtectedHotWalletGenerateNonceRequest.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == NativeGenerateDynamicNonceRequest.name()) {
    eventBus.fire(NativeGenerateDynamicNonceRequest.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == IssueIndexMsg.name()) {
    eventBus.fire(IssueIndexMsg.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == ProtectedUpdateHotWalletNonce.name()) {
    eventBus.fire(ProtectedUpdateHotWalletNonce.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == KeygenMember.name()) {
    eventBus.fire(KeygenMember.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == HotWalletGenerateNonceRequest.name()) {
    eventBus.fire(HotWalletGenerateNonceRequest.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == EncryptedKeygenWithScheme.name()) {
    eventBus.fire(EncryptedKeygenWithScheme.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == HotWalletKeygenRequest.name()) {
    eventBus.fire(HotWalletKeygenRequest.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == EncryptedLocalKey.name()) {
    eventBus.fire(EncryptedLocalKey.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == KeygenProgress.name()) {
    eventBus.fire(KeygenProgress.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == IssuedUniqueIdx.name()) {
    eventBus.fire(IssuedUniqueIdx.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == EncryptedKeygenResult.name()) {
    eventBus.fire(EncryptedKeygenResult.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == CoinPrice.name()) {
    eventBus.fire(CoinPrice.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == CoinPrices.name()) {
    eventBus.fire(CoinPrices.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == CoinPriceItem.name()) {
    eventBus.fire(CoinPriceItem.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == FiatConfig.name()) {
    eventBus.fire(FiatConfig.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == TransactionIncluded.name()) {
    eventBus.fire(TransactionIncluded.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == GenerateTransactionError.name()) {
    eventBus.fire(GenerateTransactionError.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == GenerateTransactionRequest.name()) {
    eventBus.fire(GenerateTransactionRequest.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == SignTransactionRequest.name()) {
    eventBus.fire(SignTransactionRequest.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == GenerateTransactionResponse.name()) {
    eventBus.fire(GenerateTransactionResponse.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == EstimateFeeResult.name()) {
    eventBus.fire(EstimateFeeResult.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == TransactionSigned.name()) {
    eventBus.fire(TransactionSigned.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == UnspentOutput.name()) {
    eventBus.fire(UnspentOutput.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == EstimateFeeRequest.name()) {
    eventBus.fire(EstimateFeeRequest.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == TransactionBroadcasted.name()) {
    eventBus.fire(TransactionBroadcasted.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == BlockchainConfig.name()) {
    eventBus.fire(BlockchainConfig.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == BlockchainCoinConfig.name()) {
    eventBus.fire(BlockchainCoinConfig.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == CoinConfig.name()) {
    eventBus.fire(CoinConfig.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == ConfigForBlockchain.name()) {
    eventBus.fire(ConfigForBlockchain.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == CreateTransactionResult.name()) {
    eventBus.fire(CreateTransactionResult.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == CreateSignTransactionRequest.name()) {
    eventBus.fire(CreateSignTransactionRequest.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == VerifyTransactionRequest.name()) {
    eventBus.fire(VerifyTransactionRequest.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == VerifyTransactionResult.name()) {
    eventBus.fire(VerifyTransactionResult.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == GetAddressResult.name()) {
    eventBus.fire(GetAddressResult.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == CreateTransactionRequest.name()) {
    eventBus.fire(CreateTransactionRequest.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == GetAddressRequest.name()) {
    eventBus.fire(GetAddressRequest.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == CreateSignTransactionResult.name()) {
    eventBus.fire(CreateSignTransactionResult.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == RequestParamsEthLegacy.name()) {
    eventBus.fire(RequestParamsEthLegacy.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == RequestParamsBtc.name()) {
    eventBus.fire(RequestParamsBtc.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == RequestParamsAda.name()) {
    eventBus.fire(RequestParamsAda.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == RequestParamsEthEip1559.name()) {
    eventBus.fire(RequestParamsEthEip1559.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == Alert.name()) {
    eventBus.fire(Alert.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == EmailActionRequest.name()) {
    eventBus.fire(EmailActionRequest.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == ProtectedEmailActionVerify.name()) {
    eventBus.fire(ProtectedEmailActionVerify.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == WalletBalanceUpdate.name()) {
    eventBus.fire(WalletBalanceUpdate.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == SendRawTransactionRequest.name()) {
    eventBus.fire(SendRawTransactionRequest.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == WalletCreationConfigPubkey.name()) {
    eventBus.fire(WalletCreationConfigPubkey.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == ClientWalletLoaded.name()) {
    eventBus.fire(ClientWalletLoaded.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == EnabledBlockchain.name()) {
    eventBus.fire(EnabledBlockchain.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == WalletCreationConfig.name()) {
    eventBus.fire(WalletCreationConfig.fromJson(jsonDecode(eventData)));
  }
  else if (eventType == UserPing.name()) {
    eventBus.fire(UserPing.fromJson(jsonDecode(eventData)));
  }
}
