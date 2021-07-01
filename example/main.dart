import 'dart:async';
import 'dart:io';

import 'package:freewig/freewig.dart';

Future<Cartridge?> parseFile(File file) async {
  final bytes = await file.readAsBytes();
  final completer = Completer<Cartridge>();
  await Future<Cartridge?>(() => parseData(bytes))
      .then(completer.complete)
      .catchError(completer.completeError);
  return completer.future;
}

void main(List<String> arguments) async {
  var file = File(arguments[0]); // path/incl/cartridge.gwc
  var cartridge = await parseFile(file);

  if (cartridge != null) {
    var export = Directory('export');
    var exists = await export.exists();
    if (exists) {
      await export.delete(recursive: true);
    }
    await export.create(recursive: true);

    var contents = '';
    contents += 'Cartridge-Id: ${cartridge.cartridgeGuid}\n';
    contents += 'Name: ${cartridge.cartridgeName}\n';
    contents += 'Description: ${cartridge.cartridgeDesc}\n';
    contents += 'StartLocation: ${cartridge.startLocationDesc}\n';
    contents += 'Latitude: ${cartridge.latLng.latitude}\n';
    contents += 'Longitude: ${cartridge.latLng.longitude}\n';
    contents += 'Player: ${cartridge.playerName}\n';
    contents += 'Author: ${cartridge.author}\n';
    contents += 'Type: ${cartridge.typeOfCartridge}\n';
    contents += 'Device: ${cartridge.recommendDevice}\n';
    contents += 'Version: ${cartridge.version}\n';
    contents += '\n';
    contents += 'Completion-Code: ${cartridge.completionCode}\n';
    contents += '\n';
    contents += 'ItemCount: ${cartridge.mediaCount}\n';
    var infoFile = File('${export.path}/cartridge_info.txt');
    await infoFile.writeAsString(contents);

    for (var index = 0; index < cartridge.mediaCount; index++) {
      final data = cartridge.getMedia(index);
      if (data != null) {
        var objectFile =
            File('${export.path}/object_$index.${data.objectType}');
        await objectFile.writeAsBytes(data.data);
      }
    }
  } else {
    print("The cartridge is invalid");
  }
}
