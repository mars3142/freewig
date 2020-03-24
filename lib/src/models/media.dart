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

import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../freewig.dart';
import '../binary_reader.dart';

/// A [Media] is a representation of any file within the [Cartridge]
@immutable
class Media {
  /// Bytes of the media type
  final Uint8List data;

  /// Human readable object type
  final String objectType;

  Media._(this.objectType, this.data);

  /// Read the object from the [BinaryReader]
  ///
  /// It starts at address (from [SeekOrigin.begin]) and uses the data for
  /// interpret the data as media. If it can be read, the return will be a
  /// [Media] object. In case of an exception the result will be null.
  factory Media(BinaryReader reader, int objectId, int address) {
    try {
      Uint8List data;
      var objectType = 0;
      reader.seek(address, SeekOrigin.begin);
      if (objectId == 0) {
        data = _getData(reader);
      } else {
        if (reader.getByte() != 0) {
          objectType = reader.getLong();
          data = _getData(reader);
        }
      }
      final object = Media._(_getObjectType(objectType), data);
      return object;
    } on Exception catch (_) {
      return null;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Media &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          objectType == other.objectType;

  @override
  int get hashCode => data.hashCode ^ objectType.hashCode;
}

Uint8List _getData(BinaryReader reader) {
  var length = reader.getLong();
  var data = <int>[];
  for (var index = 0; index < length; index++) {
    data.add(reader.getByte());
  }
  return Uint8List.fromList(data);
}

String _getObjectType(int objectType) {
  switch (objectType) {
    case -1:
      return ObjectType.deleted.toShortString();
    case 0:
      return ObjectType.luac.toShortString();
    case 1:
      return ObjectType.bmp.toShortString();
    case 2:
      return ObjectType.png.toShortString();
    case 3:
      return ObjectType.jpg.toShortString();
    case 4:
      return ObjectType.gif.toShortString();
    case 17:
      return ObjectType.wav.toShortString();
    case 18:
      return ObjectType.mp3.toShortString();
    case 19:
      return ObjectType.fdl.toShortString();
    case 20:
      return ObjectType.snd.toShortString();
    case 21:
      return ObjectType.ogg.toShortString();
    case 33:
      return ObjectType.swf.toShortString();
    case 49:
      return ObjectType.txt.toShortString();
    default:
      return "invalid ($objectType)";
  }
}

/// Known object types of [Media]
enum ObjectType {
  /// object is deleted
  deleted,
  /// object is compiled lua code
  luac,
  /// object is a BMP file
  bmp,
  /// object is a PNG file
  png,
  /// object is a JPEG file
  jpg,
  /// object is a GIF file
  gif,
  /// object is a WAV file
  wav,
  /// object is a MP3 file
  mp3,
  /// object is a FDL file
  fdl,
  /// object is a SND file
  snd,
  /// object is a OGG file
  ogg,
  /// object is a SWF file
  swf,
  /// object is a TXT file
  txt
}

extension on ObjectType {
  String toShortString() {
    return toString().split('.').last;
  }
}
