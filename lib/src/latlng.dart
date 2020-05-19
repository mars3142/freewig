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
  const LatLng(this._latitude, this._longitude);

  /// formatted latitude
  String latitude() {
    return _format(_latitude, 'NS');
  }

  /// formatted longitude
  String longitude() {
    return _format(_longitude, 'WE');
  }

  String _format(double value, String suffix) {
    while (value < -180.0) {
      value += 360.0;
    }

    while (value > 180.0) {
      value -= 360.0;
    }

    //switch the value to positive
    var _isNegative = value < 0;
    value = value.abs();

    //gets the degree
    var _degrees = value.floor();
    var delta = value - _degrees;

    //gets minutes and seconds
    var seconds = (3600.0 * delta).floor();
    var _seconds = seconds % 60;
    var _minutes = (seconds / 60.0).floor();
    delta = delta * 3600.0 - seconds;

    //gets fractions
    var _milliseconds = (1000.0 * delta).toInt();

    /// N 53° 25.831 E 010° 05.408
    var result = '';
    if (_isNegative) {
      result += suffix.substring(1);
    } else {
      result += suffix.substring(0, 1);
    }
    result +=
        " $_degrees° ${_minutes.toString().padLeft(2, '0')}' ${_seconds.toString().padLeft(2, '0')}\".${_milliseconds.toString().padLeft(3, '0')} ";
    return result;
  }
}
