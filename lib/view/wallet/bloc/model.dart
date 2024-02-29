// // To parse this JSON data, do
// //
// //     final wallet = walletFromJson(jsonString);

// import 'dart:convert';

// Wallet walletFromJson(String str) => Wallet.fromJson(json.decode(str));

// String walletToJson(Wallet data) => json.encode(data.toJson());

// class Wallet {
//   Wallet({
//     this.status,
//     this.data,
//     this.message,
//   });

//   String status;
//   WalletData data;
//   String message;

//   factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
//         status: json["status"],
//         data: WalletData.fromJson(json["data"]),
//         message: json["message"],
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "data": data.toJson(),
//         "message": message,
//       };
// }

// class WalletData {
//   WalletData({
//     this.wallet,
//   });

//   int wallet;

//   factory WalletData.fromJson(Map<String, dynamic> json) => WalletData(
//         wallet: json["wallet"],
//       );

//   Map<String, dynamic> toJson() => {
//         "wallet": wallet,
//       };
// }
