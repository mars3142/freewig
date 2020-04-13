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

import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'binary_reader.dart';
import 'models/cartridge.dart';

/// Try to parse a file and create a [Cartridge]
///
/// If the file is a valid GWC file, the result will be [Cartridge] or null, if the parser failed.
Future<Cartridge> parseFile(File file) async {
  var receivePort = ReceivePort();
  var message = _ParseData(receivePort.sendPort, file);
  await Isolate.spawn(_parseFile, message);

  return await receivePort.first;
}

void _parseFile(_ParseData message) async {
  final bytes = await message.file.readAsBytes();
  var cartridge = parseData(bytes);

  message.sendPort.send(cartridge);
}

class _ParseData {
  const _ParseData(this.sendPort, this.file);

  final SendPort sendPort;
  final File file;
}

/// Parses a byte list and create a [Cartridge]
///
/// If the byte list is a valid GWC file, the result will be [Cartridge] or null, if the parser failed.
Cartridge parseData(Uint8List bytes) {
  try {
    final header = {0x02, 0x0a, 0x43, 0x41, 0x52, 0x54, 0x00}; // magic header
    final reader = BinaryReader(ByteData.view(bytes.buffer), Endian.little);

    for (var index = 0; index < header.length; index++) {
      if (reader.getByte() != header.elementAt(index)) {
        return null;
      }
    }

    return Cartridge(reader);
  } on Exception catch (_) {
    return null;
  }
}
