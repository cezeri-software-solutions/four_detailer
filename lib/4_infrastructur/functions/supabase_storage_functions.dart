import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../3_domain/models/models.dart';
import '../../constants.dart';
import '../../failures/failures.dart';

Future<Either<AbstractFailure, bool>> checkIfBucketExists(String bucketName) async {
  try {
    await supabase.storage.getBucket(bucketName);

    return const Right(true);
  } on StorageException catch (e) {
    if (e.toString().contains('Bucket not found')) {
      return const Right(false);
    } else {
      return Left(GeneralFailure(message: e.toString()));
    }
  }
}

Future<Either<AbstractFailure, Unit>> createNewBucket(String bucketName) async {
  try {
    await supabase.storage.createBucket(bucketName, const BucketOptions(public: true));

    return const Right(unit);
  } on StorageException catch (e) {
    logger.e(e.message);
    return Left(GeneralFailure(message: e.toString()));
  } catch (e) {
    logger.e(e);
    return Left(GeneralFailure(message: e.toString()));
  }
}

Future<Either<AbstractFailure, String>> uploadFileToStorage({
  required String bucketName,
  required String path,
  required MyFile myFile,
  bool useGivenName = true,
}) async {
  final filePath = _getFilePath(path, myFile, useGivenName);

  try {
    final String uploadedFilePath = await supabase.storage.from(bucketName).uploadBinary(filePath, myFile.fileBytes);
    final pathWithoutBucketName = extractPathFromUrl(uploadedFilePath, bucketName);

    final String fileUrl = supabase.storage.from(bucketName).getPublicUrl(pathWithoutBucketName);

    return Right(fileUrl);
  } on StorageException catch (e) {
    logger.e(e);
    return Left(GeneralFailure(message: e.message));
  } catch (e) {
    logger.e('Fehler beim Hochladen der Datei oder Abrufen der URL: $e');
    return Left(GeneralFailure(message: e.toString()));
  }
}

Future<Either<AbstractFailure, Unit>> deleteFilesFromSupabaseStorageByUrl(String bucketName, List<String> fileUrls) async {
  final extractedUrls = fileUrls.map((url) => extractPathFromUrl(url, bucketName)).toList();

  try {
    await supabase.storage.from(bucketName).remove(extractedUrls);

    return const Right(unit);
  } on StorageException catch (e) {
    logger.e(e.message);
    return Left(GeneralFailure(message: e.message));
  } catch (e) {
    logger.e('Dateien konnten nicht gelöscht werden. ERROR: $e');
    return Left(GeneralFailure(message: e.toString()));
  }
}

String _getFilePath(String path, MyFile myFile, bool useGivenName) {
  if (useGivenName) {
    final fileName = sanitizeFileName(basename(myFile.name));
    final filePath = '$path/${generateRandomString(4)}_$fileName}';
    return Uri.encodeFull(filePath);
  }

  if (myFile.mimeType != null && myFile.mimeExtension != null) {
    final filePath = '$path/${generateRandomString(4)}${myFile.mimeExtension}';
    return Uri.encodeFull(filePath);
  }

  final filePath = '$path/${generateRandomString(4)}';
  return Uri.encodeFull(filePath);
}

String generateRandomString(int length) {
  const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
  Random random = Random();

  return String.fromCharCodes(Iterable.generate(
    length,
    (_) => characters.codeUnitAt(random.nextInt(characters.length)),
  ));
}

String sanitizeFileName(String input) {
  // Ersetzt ungültige Zeichen durch Unterstriche
  String sanitized = input.replaceAll(RegExp(r'[^\w\s.-]'), '_');
  // Entfernt Leerzeichen
  return sanitized.replaceAll(' ', '_');
}

String extractPathFromUrl(String url, String path) {
  Uri uri = Uri.parse(url);
  int bucketIndex = uri.pathSegments.indexOf(path) + 1; // Findet den Index des Bucket-Namens und addiert 1
  return uri.pathSegments.sublist(bucketIndex).join('/'); // Extrahiert alles nach 'product-images'
}
