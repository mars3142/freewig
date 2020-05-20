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

/// latitude / longitude class with helper functions for human readable formatting
class LatLng {
  final double _latitude;
  final double _longitude;

  /// main constructor
  const LatLng(double latitude, double longitude)
      : _latitude = latitude,
        _longitude = longitude;

  /// formatted latitude
  String get latitude {
    return _format(_latitude, 'NS');
  }

  /// formatted longitude
  String get longitude {
    return _format(_longitude, 'EW');
  }

  String _format(double value, String suffix) {
    final isNegative = value < 0;
    value = value.abs();

    final degrees = value.floor();
    final minutes = (value - degrees) * 60.0;

    var result = '';
    if (isNegative) {
      result += suffix.substring(1);
    } else {
      result += suffix.substring(0, 1);
    }
    result += ' $degrees° ${minutes.toStringAsFixed(3)}';
    return result;
  }
}
