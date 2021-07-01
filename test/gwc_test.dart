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

import 'dart:async';
import 'dart:io';

import 'package:freewig/freewig.dart';
import 'package:test/test.dart';

Future<Cartridge?> parseFile(File file) async {
  final bytes = await file.readAsBytes();
  final completer = Completer<Cartridge>();
  await Future<Cartridge?>(() => parseData(bytes))
      .then(completer.complete)
      .catchError(completer.completeError);
  return completer.future;
}

void main() {
  group('Cartridge TESTING.GWC', () {
    Cartridge? cartridgeData;

    setUp(() async {
      var file = File("testing.gwc");
      cartridgeData = await parseFile(file);
    });

    test('Cartridge name is "TESTING"', () {
      expect(cartridgeData != null, isTrue);
      expect(cartridgeData!.cartridgeName, "TESTING");
    });

    test('Completion Code is "ABCDEFGHIJKLMNOP"', () {
      expect(cartridgeData != null, isTrue);
      expect(cartridgeData!.completionCode, "ABCDEFGHIJKLMNOP");
    });

    test('Cartridge has 2 objects', () {
      expect(cartridgeData != null, isTrue);
      expect(cartridgeData?.mediaCount, 2);
    });
  });
}
