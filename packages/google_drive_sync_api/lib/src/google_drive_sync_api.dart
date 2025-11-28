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

  static const String _dbFileName = 'isar_db.isar';
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

  Future<void> uploadDatabase(Uint8List bytes) async {
    if (_driveApi == null) throw SyncException('Drive API not initialized');

    final media = drive.Media(Stream.value(bytes), bytes.length);
    final remote = await _findRemoteDb();

    if (remote == null) {
      final metadata = drive.File()
        ..name = _dbFileName
        ..parents = ['root'];
      await _driveApi!.files.create(metadata, uploadMedia: media);
    } else {
      await _driveApi!.files.update(
        drive.File()..name = _dbFileName,
        remote.id!,
        uploadMedia: media,
      );
    }
  }

  Future<Uint8List> downloadDatabase() async {
    if (_driveApi == null) throw SyncException('Drive API not initialized');

    final remote = await _findRemoteDb();
    if (remote == null) throw SyncException('Remote DB not found');

    final media = await _driveApi!.files.get(
      remote.id!,
      downloadOptions: drive.DownloadOptions.fullMedia,
    );

    if (media is! drive.Media) {
      throw SyncException('Unexpected download response');
    }

    final buffer = <int>[];
    await for (final chunk in media.stream) {
      buffer.addAll(chunk);
    }

    return Uint8List.fromList(buffer);
  }

  @override
  Future<SyncResult> sync({
    required Uint8List? localDb,
    required String imageStorageDirectory,
  }) async {
    final remote = await _findRemoteDb();
    final hasLocalDb = localDb != null;

    if (!hasLocalDb && remote != null) {
      final downloadedDb = await downloadDatabase();
      await _downloadAllImages(imageStorageDirectory);
      return SyncResult(
        success: true,
        direction: SyncDirection.download,
        downloadedBytes: downloadedDb,
      );
    }

    if (hasLocalDb) {
      await uploadDatabase(localDb);
      final localImageFiles = Directory(imageStorageDirectory).listSync();
      for (final entity in localImageFiles) {
        if (entity is File) {
          await _uploadImage(entity);
        }
      }
    }
    return SyncResult(success: true, direction: SyncDirection.upload);
  }

  Future<drive.File?> _findRemoteDb() async {
    if (_driveApi == null) throw SyncException('Drive API not initialized');

    final fileList = await _driveApi!.files.list(
      spaces: 'drive',
      q: "name = '$_dbFileName'",
      $fields: 'files(id,name,modifiedTime)',
    );

    return fileList.files?.isNotEmpty == true ? fileList.files!.first : null;
  }

  Future<void> _uploadImage(File file) async {
    final folder = await _getOrCreateImagesFolder();
    final fileName = path.basename(file.path);

    // check if file already exists
    final existing = await _driveApi!.files.list(
      q: "'${folder.id}' in parents and name='$fileName'",
      $fields: "files(id)",
    );

    final media = drive.Media(file.openRead(), await file.length());

    if (existing.files?.isNotEmpty == true) {
      await _driveApi!.files.update(
        drive.File()..name = fileName,
        existing.files!.first.id!,
        uploadMedia: media,
      );
    } else {
      final metadata = drive.File()
        ..name = fileName
        ..parents = [folder.id!];

      await _driveApi!.files.create(metadata, uploadMedia: media);
    }
  }

  Future<void> _downloadAllImages(String localDirPath) async {
    final folder = await _getOrCreateImagesFolder();
    final list = await _driveApi!.files.list(
      q: "'${folder.id}' in parents",
      $fields: "files(id,name)",
    );

    if (list.files == null) return;

    final localDir = Directory(localDirPath);

    for (final f in list.files!) {
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

  Future<drive.File> _getOrCreateImagesFolder() async {
    final list = await _driveApi!.files.list(
      q: "name='$_imagesFolderName' and mimeType='application/vnd.google-apps.folder'",
      spaces: 'drive',
      $fields: 'files(id,name)',
    );

    if (list.files?.isNotEmpty == true) {
      return list.files!.first;
    }

    final folder = drive.File()
      ..name = _imagesFolderName
      ..mimeType = 'application/vnd.google-apps.folder'
      ..parents = ['root'];

    return await _driveApi!.files.create(folder);
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
