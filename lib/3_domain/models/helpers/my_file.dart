import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

import '/constants.dart';

class MyFile {
  final Uint8List fileBytes;
  final String name;
  final String? mimeType;
  final int? size;
  final String? mimeExtension; // statt z.B. image/png = .png

  MyFile({required this.fileBytes, required this.name, this.mimeType, this.size}) : mimeExtension = _convertMimeTypeToExtension(mimeType);

  static String? _convertMimeTypeToExtension(String? mimeType) {
    if (mimeType == null) return null;
    // Findet den letzten Index von '/' und schneidet bis dahin ab
    int slashIndex = mimeType.lastIndexOf('/');
    if (slashIndex != -1 && slashIndex < mimeType.length - 1) {
      // Schneidet den Teil vor dem '/' ab und fügt einen Punkt davor
      return '.${mimeType.substring(slashIndex + 1)}';
    }
    // Rückgabe eines leeren Strings, wenn kein '/' gefunden wurde oder der String leer ist
    return null;
  }

  factory MyFile.empty() {
    return MyFile(fileBytes: Uint8List(0), name: '', mimeType: null, size: null);
  }

  MyFile copyWith({
    Uint8List? fileBytes,
    String? name,
    String? mimeType,
    int? size,
  }) {
    return MyFile(
      fileBytes: fileBytes ?? this.fileBytes,
      name: name ?? this.name,
      mimeType: mimeType ?? this.mimeType,
      size: size ?? this.size,
    );
  }

  @override
  String toString() {
    return 'MyFile(fileBytes: $fileBytes, name: $name, mimeType: $mimeType, size: $size)';
  }
}

Future<MyFile> convertPlatfomFileToMyFile(PlatformFile platformFile) async {
  final name = platformFile.name;
  Uint8List? fileBytes;

  if (platformFile.bytes != null) {
    // Für Web oder wenn Bytes verfügbar sind
    fileBytes = platformFile.bytes;
  } else if (platformFile.path != null) {
    // Für mobile Plattformen
    final file = File(platformFile.path!);
    fileBytes = await file.readAsBytes();
  } else {
    logger.e('Konnte die Datei für ${platformFile.name} nicht lesen');
  }

  final mime = lookupMimeType('', headerBytes: fileBytes);

  return MyFile(name: name, fileBytes: fileBytes!, mimeType: mime);
}

Future<List<MyFile>> convertPlatfomFilesToMyFiles(List<PlatformFile> platformFiles) async {
  final List<MyFile> myFiles = [];

  for (final platformFile in platformFiles) {
    final myFile = await convertPlatfomFileToMyFile(platformFile);

    myFiles.add(myFile);
  }

  return myFiles;
}

Future<MyFile> convertIoFileToMyFile(File file) async {
  final name = file.path;
  final fileBytes = await file.readAsBytes();

  return MyFile(name: name, fileBytes: fileBytes);
}

Future<List<MyFile>> convertIoFilesToMyFiles(List<File> files) async {
  final List<MyFile> myFiles = [];

  for (final file in files) {
    final myFile = await convertIoFileToMyFile(file);

    myFiles.add(myFile);
  }

  return myFiles;
}

Future<MyFile> convertXFileToMyFile(XFile platformFile) async {
  final name = platformFile.name;
  final Uint8List fileBytes = await platformFile.readAsBytes();

  final mime = lookupMimeType('', headerBytes: fileBytes);

  return MyFile(name: name, fileBytes: fileBytes, mimeType: mime);
}

Future<List<MyFile>> convertXFilesToMyFiles(List<XFile> platformFiles) async {
  final List<MyFile> myFiles = [];

  for (final platformFile in platformFiles) {
    final myFile = await convertXFileToMyFile(platformFile);

    myFiles.add(myFile);
  }

  return myFiles;
}
