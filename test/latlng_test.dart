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

import 'package:test/test.dart';
import 'package:freewig/freewig.dart';

void main() {
  group('LatLng testing', () {
    test('Hamburg', () {
      var location = const LatLng(53.5584902, 9.7877407);
      expect('N 53° 33.509', location.latitude);
      expect('E 9° 47.264', location.longitude);
    });

    test('New York', () {
      var location = const LatLng(40.6974034, -74.1197633);
      expect('N 40° 41.844', location.latitude);
      expect('W 74° 7.186', location.longitude);
    });

    test('Sydney', () {
      final location = const LatLng(-33.847927, 150.651794);
      expect('S 33° 50.876', location.latitude);
      expect('E 150° 39.108', location.longitude);
    });
  });
}
