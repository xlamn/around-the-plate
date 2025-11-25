import 'dart:async';
import 'dart:io';

import 'package:cloud_sync_api/cloud_sync_api.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;

class GoogleDriveSyncApi implements CloudSyncApi {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      drive
          .DriveApi
          .driveFileScope, // gives access to files created/opened by the app
      drive
          .DriveApi
          .driveAppdataScope, // appDataFolder (recommended for app DBs)
    ],
  );

  drive.DriveApi? _driveApi;
  http.Client? _httpClient;

  static const String _dbFileName = 'isar_db.isar';

  @override
  Future<void> login() async {
    final account =
        await _googleSignIn.signInSilently() ?? await _googleSignIn.signIn();

    if (account == null) throw SyncException('Google Sign-In failed');

    final authHeaders = await account.authHeaders;
    _httpClient = GoogleHttpClient(authHeaders);
    _driveApi = drive.DriveApi(_httpClient!);
  }

  @override
  Future<bool> isSignedIn() async {
    final account = await _googleSignIn.signInSilently();
    return account != null;
  }

  Future<drive.File?> _findRemoteDb() async {
    if (_driveApi == null) throw SyncException('Drive API not initialized');

    final fileList = await _driveApi!.files.list(
      spaces: 'appDataFolder',
      q: "name = '$_dbFileName'",
      $fields: 'files(id,name,modifiedTime,size)', // limit returned fields
    );

    if (fileList.files != null && fileList.files!.isNotEmpty) {
      return fileList.files!.first;
    }
    return null;
  }

  @override
  Future<bool> remoteDatabaseExists() async {
    return (await _findRemoteDb()) != null;
  }

  @override
  Future<void> uploadDatabase({required String localDbPath}) async {
    if (_driveApi == null) throw SyncException('Drive API not initialized');

    final dbFile = File(localDbPath);
    if (!await dbFile.exists()) {
      throw SyncException('Local DB file not found at $localDbPath');
    }

    final remote = await _findRemoteDb();

    final media = drive.Media(dbFile.openRead(), await dbFile.length());

    if (remote == null) {
      // create new file in appDataFolder
      final fileMetadata = drive.File()
        ..name = _dbFileName
        ..parents = ['appDataFolder'];

      await _driveApi!.files.create(
        fileMetadata,
        uploadMedia: media,
        // request specific fields back if you like:
        $fields: 'id,modifiedTime',
      );
    } else {
      // update existing file
      await _driveApi!.files.update(
        drive.File()..name = _dbFileName,
        remote.id!,
        uploadMedia: media,
        $fields: 'id,modifiedTime',
      );
    }
  }

  @override
  Future<void> downloadDatabase({required String localDbPath}) async {
    if (_driveApi == null) throw SyncException('Drive API not initialized');

    final remote = await _findRemoteDb();
    if (remote == null) throw SyncException('Remote DB not found');

    final media = await _driveApi!.files.get(
      remote.id!,
      downloadOptions: drive.DownloadOptions.fullMedia,
    );

    if (media is drive.Media) {
      final stream = media.stream;
      final outFile = File(localDbPath);
      final raf = outFile.openWrite();
      await for (final chunk in stream) {
        raf.add(chunk);
      }
      await raf.close();
    } else {
      throw SyncException('Unexpected media response when downloading DB');
    }
  }

  @override
  Future<DateTime?> getRemoteLastModified() async {
    final remote = await _findRemoteDb();
    if (remote == null) return null;
    // `modifiedTime` is a DateTime in googleapis
    return remote.modifiedTime;
  }

  @override
  Future<DateTime?> getLocalLastModified(String localDbPath) async {
    final file = File(localDbPath);
    if (!await file.exists()) return null;
    return await file.lastModified();
  }

  @override
  Future<SyncResult> sync({required String localDbPath}) async {
    // Basic conflict-resolution by timestamp. You may want to improve this.
    final remoteTime = await getRemoteLastModified();
    final localTime = await getLocalLastModified(localDbPath);

    if (remoteTime == null && localTime == null) {
      return SyncResult(success: true, message: 'Nothing to sync');
    }

    if (remoteTime == null && localTime != null) {
      await uploadDatabase(localDbPath: localDbPath);
      return SyncResult(success: true, direction: SyncDirection.upload);
    }

    if (localTime == null && remoteTime != null) {
      await downloadDatabase(localDbPath: localDbPath);
      return SyncResult(success: true, direction: SyncDirection.download);
    }

    if (localTime!.isAfter(remoteTime!)) {
      await uploadDatabase(localDbPath: localDbPath);
      return SyncResult(success: true, direction: SyncDirection.upload);
    } else {
      await downloadDatabase(localDbPath: localDbPath);
      return SyncResult(success: true, direction: SyncDirection.download);
    }
  }

  @override
  Future<void> logout() async {
    await _googleSignIn.disconnect();
    _httpClient?.close();
    _httpClient = null;
    _driveApi = null;
  }
}

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
  void close() {
    _inner.close();
  }
}
