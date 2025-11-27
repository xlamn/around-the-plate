import 'dart:async';
import 'dart:typed_data';

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
  Future<SyncResult> sync({required Uint8List? localDb}) async {
    final remote = await _findRemoteDb();

    // Case: no local db -> Download remote db
    if (localDb == null && remote != null) {
      final downloaded = await downloadDatabase();
      return SyncResult(
        success: true,
        direction: SyncDirection.download,
        downloadedBytes: downloaded,
      );
    }

    await uploadDatabase(localDb!);
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
