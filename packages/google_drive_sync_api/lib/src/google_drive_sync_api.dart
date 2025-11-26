import 'dart:async';
import 'dart:io';

import 'package:cloud_sync_api/cloud_sync_api.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;

class GoogleDriveSyncApi implements CloudSyncApi {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      drive.DriveApi.driveFileScope,
      drive.DriveApi.driveAppdataScope,
    ],
  );

  // TODO: requires to login every time to be set
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
  Future<void> logout() async {
    await _googleSignIn.disconnect();
    _httpClient?.close();
    _httpClient = null;
    _driveApi = null;
  }

  @override
  Future<bool> isSignedIn() async {
    final account = await _googleSignIn.signInSilently();
    return account != null;
  }

  Future<void> uploadDatabase({required String localDbPath}) async {
    if (_driveApi == null) throw SyncException('Drive API not initialized');

    final dbFile = File(localDbPath);
    if (!await dbFile.exists()) throw SyncException('Local DB file not found');

    final bytes = await dbFile.readAsBytes();
    final remote = await _findRemoteDb();
    final media = drive.Media(Stream.value(bytes), bytes.length);

    if (remote == null) {
      final fileMetadata = drive.File()
        ..name = _dbFileName
        ..parents = ['appDataFolder'];
      await _driveApi!.files.create(
        fileMetadata,
        uploadMedia: media,
        $fields: 'id,modifiedTime',
      );
    } else {
      await _driveApi!.files.update(
        drive.File()..name = _dbFileName,
        remote.id!,
        uploadMedia: media,
        $fields: 'id,modifiedTime',
      );
    }
  }

  Future<void> downloadDatabase({required String localDbPath}) async {
    if (_driveApi == null) throw SyncException('Drive API not initialized');

    final remote = await _findRemoteDb();
    if (remote == null) throw SyncException('Remote DB not found');

    final media = await _driveApi!.files.get(
      remote.id!,
      downloadOptions: drive.DownloadOptions.fullMedia,
    );

    if (media is drive.Media) {
      final bytes = <int>[];
      await for (final chunk in media.stream) {
        bytes.addAll(chunk);
      }
      await File(localDbPath).writeAsBytes(bytes, flush: true);
    } else {
      throw SyncException('Unexpected media response when downloading DB');
    }
  }

  @override
  Future<SyncResult> sync({required String localDbPath}) async {
    final remoteTime = await getRemoteLastModified();
    final localFile = File(localDbPath);
    if (!await localFile.exists()) {
      throw SyncException('Local DB file not found at $localDbPath');
    }
    final localTime = await localFile.lastModified();

    if (remoteTime == null) {
      await uploadDatabase(localDbPath: localDbPath);
      return SyncResult(success: true, direction: SyncDirection.upload);
    }

    if (localTime.isAfter(remoteTime)) {
      await uploadDatabase(localDbPath: localDbPath);
      return SyncResult(success: true, direction: SyncDirection.upload);
    } else {
      await downloadDatabase(localDbPath: localDbPath);
      return SyncResult(success: true, direction: SyncDirection.download);
    }
  }

  Future<DateTime?> getRemoteLastModified() async {
    final remote = await _findRemoteDb();
    return remote?.modifiedTime;
  }

  Future<drive.File?> _findRemoteDb() async {
    if (_driveApi == null) throw SyncException('Drive API not initialized');

    final fileList = await _driveApi!.files.list(
      spaces: 'appDataFolder',
      q: "name = '$_dbFileName'",
      $fields: 'files(id,name,modifiedTime)',
    );

    return fileList.files?.isNotEmpty == true ? fileList.files!.first : null;
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
