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

import '../binary_reader.dart';

///
@immutable
class ObjectData {
  ///
  final Uint8List data;

  ///
  final String objectType;

  ObjectData._(this.objectType, this.data);

  ///
  factory ObjectData(int objectId, int address, BinaryReader reader) {
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
    final object = ObjectData._(_getObjectType(objectType), data);
    return object;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ObjectData &&
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
      return "DELETED";
    case 0:
      return "LUAC";
    case 1:
      return "BMP";
    case 2:
      return "PNG";
    case 3:
      return "JPG";
    case 4:
      return "GIF";
    case 17:
      return "WAV";
    case 18:
      return "MP3";
    case 19:
      return "FDL";
    case 20:
      return "SND";
    case 21:
      return "OGG";
    case 33:
      return "SWF";
    case 49:
      return "TXT";
    default:
      return "invalid ($objectType)";
  }
}
