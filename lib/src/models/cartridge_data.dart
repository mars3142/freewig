/*
 * Copyright (c) 2020 Peter Siegmund
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 */

import 'package:meta/meta.dart';

import '../binary_reader.dart';
import 'object_data.dart';

///
@immutable
class CartridgeData {
  ///
  final double altitude;

  ///
  final String author;

  ///
  final double latitude;

  ///
  final String cartridgeName;

  ///
  final String cartridgeDesc;

  ///
  final String cartridgeGuid;

  ///
  final double longitude;

  ///
  final int splashScreenId;

  ///
  final int smallIconId;

  ///
  final String typeOfCartridge;

  ///
  final String playerName;

  ///
  final String startLocationDesc;

  ///
  final String version;

  ///
  final String company;

  ///
  final String recommendDevice;

  ///
  final String completionCode;

  ///
  final Map<int, ObjectData> objects;

  CartridgeData._(
    this.cartridgeGuid,
    this.objects, {
    this.altitude,
    this.author,
    this.cartridgeDesc,
    this.cartridgeName,
    this.company,
    this.completionCode,
    this.latitude,
    this.longitude,
    this.playerName,
    this.recommendDevice,
    this.smallIconId,
    this.splashScreenId,
    this.startLocationDesc,
    this.typeOfCartridge,
    this.version,
  });

  ///
  factory CartridgeData(BinaryReader reader) {
    var count = reader.getUShort();
    var references = <int, int>{};
    for (var index = 0; index < count; index++) {
      var objectId = reader.getShort();
      var address = reader.getLong();
      references.putIfAbsent(objectId, () => address);
    }

    reader.getLong(); // header length

    var latitude = reader.getDouble();
    var longitude = reader.getDouble();
    var altitude = reader.getDouble();

    reader.getLong(); // unknown 0
    reader.getLong(); // unknown 1

    var splashScreenId = reader.getShort();
    var smallIconId = reader.getShort();

    var typeOfCartridge = reader.getASCIIZ();
    var playerName = reader.getASCIIZ();

    reader.getLong(); // unknown 2
    reader.getLong(); // unknown 3

    var cartridgeName = reader.getASCIIZ();
    var cartridgeGuid = reader.getASCIIZ();
    var cartridgeDesc = reader.getASCIIZ();
    var startLocationDesc = reader.getASCIIZ();
    var version = reader.getASCIIZ();
    var author = reader.getASCIIZ();
    var company = reader.getASCIIZ();
    var recommendedDevice = reader.getASCIIZ();

    reader.getLong(); // unknown 4

    var completionCode = reader.getASCIIZ();

    // initialise objects after cartridge data is loaded
    var objects = <int, ObjectData>{};
    references.forEach((index, address) =>
        {objects.putIfAbsent(index, () => ObjectData(index, address, reader))});

    return CartridgeData._(
      cartridgeGuid,
      objects,
      altitude: altitude,
      author: author,
      cartridgeDesc: cartridgeDesc,
      cartridgeName: cartridgeName,
      company: company,
      completionCode: completionCode,
      latitude: latitude,
      longitude: longitude,
      playerName: playerName,
      recommendDevice: recommendedDevice,
      smallIconId: smallIconId,
      splashScreenId: splashScreenId,
      startLocationDesc: startLocationDesc,
      typeOfCartridge: typeOfCartridge,
      version: version,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartridgeData &&
          runtimeType == other.runtimeType &&
          cartridgeGuid == other.cartridgeGuid &&
          objects == other.objects;

  @override
  int get hashCode => cartridgeGuid.hashCode ^ objects.hashCode;
}
