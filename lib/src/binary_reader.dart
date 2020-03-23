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

///
class BinaryReader {
  int _index;
  final ByteData _byteData;
  final Endian _endian;

  ///
  BinaryReader._(this._byteData, this._endian) {
    _index = 0;
  }

  ///
  factory BinaryReader(ByteData byteData, Endian endian) {
    return BinaryReader._(byteData, endian);
  }

  ///
  void seek(int offset, SeekOrigin origin) {
    switch (origin) {
      case SeekOrigin.begin:
        _index = offset;
        break;

      case SeekOrigin.current:
        _index += offset;
        break;

      case SeekOrigin.end:
        _index = _byteData.lengthInBytes - offset;
        break;
    }
  }

  ///
  int getByte() {
    var result = _byteData.getUint8(_index);
    _index++;

    return result;
  }

  ///
  int getShort() {
    var result = _byteData.getInt16(_index, _endian);
    _index += 2;

    return result;
  }

  ///
  int getUShort() {
    var result = _byteData.getUint16(_index, _endian);
    _index += 2;

    return result;
  }

  ///
  int getLong() {
    var result = _byteData.getInt32(_index, _endian);
    _index += 4;

    return result;
  }

  ///
  int getULong() {
    var result = _byteData.getUint32(_index, _endian);
    _index += 4;

    return result;
  }

  ///
  double getDouble() {
    var result = _byteData.getFloat32(_index, _endian);
    _index += 8;

    return result;
  }

  ///
  String getASCIIZ() {
    var result = "";
    var byte = -1;

    while (byte != 0) {
      byte = getByte();
      if (byte != 0) {
        result += String.fromCharCode(byte);
      }
    }

    return result;
  }
}

///
enum SeekOrigin {
  ///
  begin,

  ///
  current,

  ///
  end,
}
