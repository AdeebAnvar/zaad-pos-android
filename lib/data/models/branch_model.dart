// To parse this JSON data, do
//
//     final branchModel = branchModelFromJson(jsonString);

import 'dart:convert';

BranchModel branchModelFromJson(String str) => BranchModel.fromJson(json.decode(str));

String branchModelToJson(BranchModel data) => json.encode(data.toJson());

class BranchModel {
  int? id;
  String? name;
  String? image;
  String? invPrefix;
  String? location;
  String? contactNumber;
  String? email;
  String? socialMedia;
  String? vat;
  int? vatPercent;
  String? trnNumber;
  DateTime? installationDate;
  DateTime? expiryDate;

  BranchModel({
    this.id,
    this.name,
    this.image,
    this.invPrefix,
    this.location,
    this.contactNumber,
    this.email,
    this.socialMedia,
    this.vat,
    this.vatPercent,
    this.trnNumber,
    this.installationDate,
    this.expiryDate,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        invPrefix: json["inv_prefix"],
        location: json["location"],
        contactNumber: json["contact_number"],
        email: json["email"],
        socialMedia: json["social_media"],
        vat: json["vat"],
        vatPercent: json["vat_percent"],
        trnNumber: json["trn_number"],
        installationDate: json["installation_date"] == null ? null : DateTime.parse(json["installation_date"]),
        expiryDate: json["expiry_date"] == null ? null : DateTime.parse(json["expiry_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "inv_prefix": invPrefix,
        "location": location,
        "contact_number": contactNumber,
        "email": email,
        "social_media": socialMedia,
        "vat": vat,
        "vat_percent": vatPercent,
        "trn_number": trnNumber,
        "installation_date":
            "${installationDate!.year.toString().padLeft(4, '0')}-${installationDate!.month.toString().padLeft(2, '0')}-${installationDate!.day.toString().padLeft(2, '0')}",
        "expiry_date": "${expiryDate!.year.toString().padLeft(4, '0')}-${expiryDate!.month.toString().padLeft(2, '0')}-${expiryDate!.day.toString().padLeft(2, '0')}",
      };
}
