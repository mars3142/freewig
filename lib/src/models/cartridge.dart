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

import '../../freewig.dart';
import '../binary_reader.dart';
import 'media.dart';

/// A [Cartridge] represents the GWC file
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

  final int _splashScreenId;

  final int _smallIconId;

  final BinaryReader _source;

  final Map<int, int> _references;

  var _lastObject = -1;

  Media? _lastMedia;

  Cartridge._(
    this.cartridgeGuid,
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
    this._references,
    this._source,
  );

  /// Reading the GWC file and create a [Cartridge] or null in case of any
  /// parsing error.
  static Cartridge? create(BinaryReader reader) {
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

      reader.getLong(); // unknown 4

      final completionCode = reader.getASCIIZ();

      return Cartridge._(
        cartridgeGuid,
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
        references,
        reader,
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
          cartridgeGuid == other.cartridgeGuid;

  @override
  int get hashCode => cartridgeGuid.hashCode;

  /// get Media with objectId or null, if not available
  Media? getMedia(int objectId) {
    if (_lastObject == objectId && _lastMedia != null) {
      return _lastMedia!;
    }

    if (_references.containsKey(objectId)) {
      final address = _references[objectId];
      final media = Media.create(_source, objectId, address!);

      if (media != null) {
        if (media.data.length < 128000) {
          _lastObject = objectId;
          _lastMedia = media;
        }

        return media;
      }
    }
    return null;
  }

  /// get the count of attached media
  int get mediaCount => _references.length;

  /// get splash screen media or null if not available
  Media? get splashScreen => getMedia(_splashScreenId);

  /// get small icon media or null if not available
  Media? get smallIcon => getMedia(_smallIconId);

  /// get luac media or null if not available
  Media? get luac => getMedia(0);
}
