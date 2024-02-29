import 'package:flutter/material.dart';

import '../../../helper/user_data.dart';

class WalletEvent {}

class StartWalletEvent extends WalletEvent {
  Map<String, dynamic> get body => {};

  StartWalletEvent();
}

class StartRefundEvent extends WalletEvent {
  late TextEditingController clientName, banckName, accountNumber, iban, bankBranch;
  Map<String, dynamic> get body => {
        "client_name": clientName.text,
        "bank_name": banckName.text,
        "bank_branch": bankBranch.text,
        "account_number": accountNumber.text,
        "iban_number": iban.text,
      };

  StartRefundEvent() {
    clientName = TextEditingController(text: UserHelper.userDatum.userName);
    banckName = TextEditingController();
    accountNumber = TextEditingController();
    iban = TextEditingController();
    bankBranch = TextEditingController();
  }
}
