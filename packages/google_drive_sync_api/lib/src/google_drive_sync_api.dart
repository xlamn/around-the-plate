import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_sync_api/cloud_sync_api.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class GoogleDriveSyncApi implements CloudSyncApi {
  GoogleDriveSyncApi._internal();

  static GoogleDriveSyncApi instance = GoogleDriveSyncApi._internal();

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      drive.DriveApi.driveFileScope,
      drive.DriveApi.driveAppdataScope,
    ],
  );

  static drive.DriveApi? _driveApi;
  static http.Client? _httpClient;

  static const String _imagesFolderName = 'around_the_plate';

  static Future<void> init() async {
    final account = await _googleSignIn.signInSilently();
    if (account != null) {
      final headers = await account.authHeaders;
      _httpClient = GoogleHttpClient(headers);
      _driveApi = drive.DriveApi(_httpClient!);
    }
  }

  @override
  Future<void> login() async {
    final account = await _googleSignIn.signIn();
    if (account == null) throw SyncException('Google Sign-In failed');

    final authHeaders = await account.authHeaders;
    _httpClient = GoogleHttpClient(authHeaders);
    _driveApi = drive.DriveApi(_httpClient!);
  }

  @override
  Future<void> logout() async {
    await _googleSignIn.disconnect();
    _httpClient?.close();
    _httpClient = null;
    _driveApi = null;
  }

  @override
  bool isSignedIn() => _httpClient != null && _driveApi != null;

  @override
  Future<SyncResult> sync({
    required Map<String, Uint8List?> databases,
    required String imageStorageDirectory,
  }) async {
    if (_driveApi == null) throw SyncException('Drive API not initialized');

    final hasLocalData = databases.values.any((db) => db != null);

    if (!hasLocalData) {
      final downloadedDbs = <String, Uint8List>{};
      for (final fileName in databases.keys) {
        final bytes = await _downloadDb(fileName);
        if (bytes != null) downloadedDbs[fileName] = bytes;
      }

      if (downloadedDbs.isEmpty) {
        return SyncResult(success: true, direction: SyncDirection.none);
      }

      await _downloadAllImages(imageStorageDirectory);
      return SyncResult(
        success: true,
        direction: SyncDirection.download,
        downloadedDbs: downloadedDbs,
      );
    }

    for (final entry in databases.entries) {
      if (entry.value != null) await _uploadDb(entry.key, entry.value!);
    }
    for (final entity in Directory(imageStorageDirectory).listSync()) {
      if (entity is File) await _uploadImage(entity);
    }
    return SyncResult(success: true, direction: SyncDirection.upload);
  }

  Future<drive.File?> _findFileInFolder(String fileName, String folderId) async {
    final fileList = await _driveApi!.files.list(
      q: "'$folderId' in parents and name = '$fileName'",
      $fields: 'files(id,name)',
    );
    return fileList.files?.isNotEmpty == true ? fileList.files!.first : null;
  }

  Future<void> _uploadDb(String fileName, Uint8List bytes) async {
    final folder = await _getOrCreateAppFolder();
    final media = drive.Media(Stream.value(bytes), bytes.length);
    final existing = await _findFileInFolder(fileName, folder.id!);

    if (existing != null) {
      await _driveApi!.files.update(
        drive.File()..name = fileName,
        existing.id!,
        uploadMedia: media,
      );
    } else {
      await _driveApi!.files.create(
        drive.File()
          ..name = fileName
          ..parents = [folder.id!],
        uploadMedia: media,
      );
    }
  }

  Future<Uint8List?> _downloadDb(String fileName) async {
    final folder = await _getOrCreateAppFolder();
    final remote = await _findFileInFolder(fileName, folder.id!);
    if (remote == null) return null;

    final media = await _driveApi!.files.get(
      remote.id!,
      downloadOptions: drive.DownloadOptions.fullMedia,
    );
    if (media is! drive.Media) return null;

    final buffer = <int>[];
    await for (final chunk in media.stream) {
      buffer.addAll(chunk);
    }
    return Uint8List.fromList(buffer);
  }

  Future<void> _uploadImage(File file) async {
    final folder = await _getOrCreateAppFolder();
    final fileName = path.basename(file.path);

    final existing = await _driveApi!.files.list(
      q: "'${folder.id}' in parents and name='$fileName'",
      $fields: 'files(id)',
    );

    final media = drive.Media(file.openRead(), await file.length());

    if (existing.files?.isNotEmpty == true) {
      await _driveApi!.files.update(
        drive.File()..name = fileName,
        existing.files!.first.id!,
        uploadMedia: media,
      );
    } else {
      await _driveApi!.files.create(
        drive.File()
          ..name = fileName
          ..parents = [folder.id!],
        uploadMedia: media,
      );
    }
  }

  Future<void> _downloadAllImages(String localDirPath) async {
    final folder = await _getOrCreateAppFolder();
    final list = await _driveApi!.files.list(
      q: "'${folder.id}' in parents",
      $fields: 'files(id,name)',
    );

    if (list.files == null) return;

    final localDir = Directory(localDirPath);
    for (final f in list.files!) {
      if (f.name!.endsWith('.isar')) continue;
      final media = await _driveApi!.files.get(
        f.id!,
        downloadOptions: drive.DownloadOptions.fullMedia,
      );
      if (media is drive.Media) {
        final file = File(path.join(localDir.path, f.name!));
        final sink = file.openWrite();
        await for (final chunk in media.stream) {
          sink.add(chunk);
        }
        await sink.close();
      }
    }
  }

  Future<drive.File> _getOrCreateAppFolder() async {
    final list = await _driveApi!.files.list(
      q: "name='$_imagesFolderName' and mimeType='application/vnd.google-apps.folder'",
      spaces: 'drive',
      $fields: 'files(id,name)',
    );

    if (list.files?.isNotEmpty == true) return list.files!.first;

    return await _driveApi!.files.create(
      drive.File()
        ..name = _imagesFolderName
        ..mimeType = 'application/vnd.google-apps.folder'
        ..parents = ['root'],
    );
  }
}

/// Simple HTTP client that attaches Google auth headers
class GoogleHttpClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _inner = http.Client();

  GoogleHttpClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _inner.send(request);
  }

  @override
  void close() => _inner.close();
}
