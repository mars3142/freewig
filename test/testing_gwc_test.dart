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

import 'package:test/test.dart';
import 'package:freewig/freewig.dart';

void main() {
  group('Cartridge TESTING.GWC', () {
    CartridgeData cartridgeData;

    setUp(() async {
      var file = File("testing.gwc");
      cartridgeData = await parseFile(file);
    });

    test('Cartridge not empty', () {
      expect(cartridgeData != null, isTrue);
    });

    test('Cartridge name is "TESTING"', () {
      expect(cartridgeData.cartridgeName, "TESTING");
    });

    test('Completion Code is "ABCDEFGHIJKLMNOP"', () {
      expect(cartridgeData.completionCode, "ABCDEFGHIJKLMNOP");
    });

    test('Gartridge has 2 objects', () {
      expect(cartridgeData.objects.length, 2);
    });
  });
}
