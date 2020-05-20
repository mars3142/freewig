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

/// The [BinaryReader] is a seekable reader of ByteData, where each read updates the
/// pointer to the next byte.
class BinaryReader {
  int _index;
  final ByteData _byteData;
  final Endian _endian;

  BinaryReader._(this._byteData, this._endian) {
    _index = 0;
  }

  /// Initialise the [BinaryReader] with data and endian, so the reader knows how to
  /// interpret the bytes.
  factory BinaryReader(ByteData byteData, Endian endian) {
    return BinaryReader._(byteData, endian);
  }

  /// Reset the internal pointer to a specific offset depending on the [SeekOrigin].
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

  /// Read 1 byte and updates the pointer.
  int getByte() {
    final result = _byteData.getUint8(_index);
    _index++;

    return result;
  }

  /// Read 2 bytes as integer and updates the pointer.
  int getShort() {
    final result = _byteData.getInt16(_index, _endian);
    _index += 2;

    return result;
  }

  /// Read 2 bytes as positive integer and updates the pointer.
  int getUShort() {
    final result = _byteData.getUint16(_index, _endian);
    _index += 2;

    return result;
  }

  /// Read 4 bytes as integer and updates the pointer.
  int getLong() {
    final result = _byteData.getInt32(_index, _endian);
    _index += 4;

    return result;
  }

  /// Read 4 bytes as positive integer and updates the pointer.
  int getULong() {
    final result = _byteData.getUint32(_index, _endian);
    _index += 4;

    return result;
  }

  /// Read 8 bytes as double and updates the pointer.
  double getDouble() {
    final result = _byteData.getFloat64(_index, _endian);
    _index += 8;

    return result;
  }

  /// Read until a null terminator, return the string and updates the pointer.
  String getASCIIZ() {
    var result = '';
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

/// SeekOrigin is used for resetting the [BinaryReader] to a specific offset.
enum SeekOrigin {
  /// Count the offset from the beginning.
  begin,

  /// Add the offset to the current location.
  current,

  /// Set the offset from the end of the byte list.
  end,
}
