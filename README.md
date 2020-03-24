The library freewig will help to use Wherigo caches in Dart or Flutter

## Usage

A simple usage example:

```dart
import 'dart:io';

import 'package:freewig/freewig.dart';

void main(List<String> arguments) async {
  var file = File(arguments[0]);
  var cartridge = await parseFile(file);

  var export = Directory("export");
  var exists = await export.exists();
  if (exists) {
    await export.delete(recursive: true);
  }
  await export.create(recursive: true);

  var contents = "";
  contents += "Name: ${cartridge.cartridgeName}\n";
  contents += "Description: ${cartridge.cartridgeDesc}\n";
  contents += "StartLocation: ${cartridge.startLocationDesc}\n";
  contents += "Longitude: ${cartridge.longitude}\n";
  contents += "Latitude: ${cartridge.latitude}\n";
  contents += "Player: ${cartridge.playerName}\n";
  contents += "Author: ${cartridge.author}\n";
  contents += "Type: ${cartridge.typeOfCartridge}\n";
  contents += "Device: ${cartridge.recommendDevice}\n";
  contents += "Version: ${cartridge.version}\n";
  contents += "Catridge-Id: ${cartridge.cartridgeGuid}\n";
  contents += "\n";
  contents += "Completion-Code: ${cartridge.completionCode}\n";
  contents += "\n";
  contents += "ItemCount: ${cartridge.objects.length}\n";
  contents += "\n";
  var infoFile = File("${export.path}/cartridge_info.txt");
  await infoFile.writeAsString(contents);

  cartridge.objects.forEach((index, data) async {
    var objectFile = File("${export.path}/object_$index.${data.objectType}");
    await objectFile.writeAsBytes(data.data);
  });
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/mars3142/freewig/issues