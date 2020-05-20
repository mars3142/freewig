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

import '../../freewig.dart';
import '../binary_reader.dart';
import 'media.dart';

/// A [Cartridge] represents the GWC file
@immutable
class Cartridge {
  /// The altitude of the start coordinate
  final double altitude;

  /// The [Cartridge] author
  final String author;

  /// The latitude/longitude of the start coordinate
  final LatLng latLng;

  /// The [Cartridge] name
  final String cartridgeName;

  /// The [Cartridge] description
  final String cartridgeDesc;

  /// A unique [Cartridge] guid
  final String cartridgeGuid;

  /// Type of the [Cartridge]
  final String typeOfCartridge;

  /// Player name
  final String playerName;

  /// The start coordination description
  final String startLocationDesc;

  /// The [Cartridge] version
  final String version;

  /// Creating company
  final String company;

  /// Recommended device for the [Cartridge]
  final String recommendDevice;

  /// Completion code (can be encrypted with lua)
  final String completionCode;

  /// Map of all [Media] objects
  final Map<int, Media> mediaObjects;

  final int _splashScreenId;

  final int _smallIconId;

  Cartridge._(
    this.cartridgeGuid,
    this.mediaObjects,
    this.altitude,
    this.author,
    this.cartridgeDesc,
    this.cartridgeName,
    this.company,
    this.completionCode,
    this.latLng,
    this.playerName,
    this.recommendDevice,
    this._smallIconId,
    this._splashScreenId,
    this.startLocationDesc,
    this.typeOfCartridge,
    this.version,
  );

  /// Reading the GWC file and create a [Cartridge] or null in case of any
  /// parsing error.
  factory Cartridge(BinaryReader reader) {
    try {
      final count = reader.getUShort();
      final references = <int, int>{};
      for (var index = 0; index < count; index++) {
        final objectId = reader.getShort();
        final address = reader.getLong();
        references.putIfAbsent(objectId, () => address);
      }

      reader.getLong(); // header length

      final latitude = reader.getDouble();
      final longitude = reader.getDouble();
      final altitude = reader.getDouble();

      reader.getLong(); // unknown 0
      reader.getLong(); // unknown 1

      final splashScreenId = reader.getShort();
      final smallIconId = reader.getShort();

      final typeOfCartridge = reader.getASCIIZ();
      final playerName = reader.getASCIIZ();

      reader.getLong(); // unknown 2
      reader.getLong(); // unknown 3

      final cartridgeName = reader.getASCIIZ();
      final cartridgeGuid = reader.getASCIIZ();
      final cartridgeDesc = reader.getASCIIZ();
      final startLocationDesc = reader.getASCIIZ();
      final version = reader.getASCIIZ();
      final author = reader.getASCIIZ();
      final company = reader.getASCIIZ();
      final recommendedDevice = reader.getASCIIZ();

      final unknown4 = reader.getLong(); // unknown 4

      final completionCode = reader.getASCIIZ();

      // initialise objects after cartridge data is loaded
      final objects = <int, Media>{};
      references.forEach((index, address) =>
          {objects.putIfAbsent(index, () => Media(reader, index, address))});

      return Cartridge._(
        cartridgeGuid,
        objects,
        altitude,
        author,
        cartridgeDesc,
        cartridgeName,
        company,
        completionCode,
        LatLng(
          latitude,
          longitude,
        ),
        playerName,
        recommendedDevice,
        smallIconId,
        splashScreenId,
        startLocationDesc,
        typeOfCartridge,
        version,
      );
    } on Exception catch (ex) {
      print('Exception: $ex');
      return null;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cartridge &&
          runtimeType == other.runtimeType &&
          cartridgeGuid == other.cartridgeGuid &&
          mediaObjects == other.mediaObjects;

  @override
  int get hashCode => cartridgeGuid.hashCode ^ mediaObjects.hashCode;

  /// get splash screen media or null if not available
  Media get splashScreen => mediaObjects.containsKey(_splashScreenId)
      ? mediaObjects[_splashScreenId]
      : null;

  /// get small icon media or null if not available
  Media get smallIcon => mediaObjects.containsKey(_smallIconId)
      ? mediaObjects[_smallIconId]
      : null;

  /// get luac media or null if not available
  Media get luac => mediaObjects.containsKey(0) ? mediaObjects[0] : null;
}
