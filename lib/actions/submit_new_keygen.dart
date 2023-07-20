import 'package:mobileapp/models/action.dart';

class SubmitNewKeygen extends Action {
  final int numberOfMembers;
  final int numberOfRequiredSignatures;
  final String walletName;
  final String signerName;
  final bool isHotSigningWallet;

  SubmitNewKeygen(this.numberOfMembers, this.numberOfRequiredSignatures,
      this.walletName, this.signerName, this.isHotSigningWallet);

  @override
  String toString() {
    return "[numberOfMembers=$numberOfMembers,numberOfRequiredSignatures=$numberOfRequiredSignatures,walletName=$walletName,signerName=$signerName,isHotSigningWallet=$isHotSigningWallet]";
  }
}
