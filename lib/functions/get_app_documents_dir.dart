import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> getAppDocDirFolder(String folderName) async {
  final Directory appDocDir = await getApplicationDocumentsDirectory();
  const String initialFolderName = "AlpacaByteApp";
  final String fullFolderPath =
      '${appDocDir.path}/$initialFolderName/$folderName';

  final Directory appDocDirFolder = Directory(fullFolderPath);

  if (await appDocDirFolder.exists()) {
    return appDocDirFolder.path;
  }

  final Directory appDocDirNewFolder =
      await appDocDirFolder.create(recursive: true);
  return appDocDirNewFolder.path;
}
