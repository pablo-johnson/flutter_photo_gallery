import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_gallery/photo_gallery.dart';

import 'utils/generator.dart';

/// Tests the arguments sent to the native side and the handling of empty
/// (null) native responses.
void main() {
  const MethodChannel channel = MethodChannel('photo_gallery');
  final List<MethodCall> calls = <MethodCall>[];
  Map<String, dynamic Function(MethodCall)> responses = {};

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    calls.clear();
    responses = {};
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      calls.add(call);
      return responses[call.method]?.call(call);
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('listAlbums sends medium type and hideIfEmpty only', () async {
    responses['listAlbums'] = (_) => <dynamic>[];
    await PhotoGallery.listAlbums(
      mediumType: MediumType.video,
      hideIfEmpty: false,
    );
    expect(calls.single.method, 'listAlbums');
    expect(calls.single.arguments, {
      'mediumType': 'video',
      'hideIfEmpty': false,
    });
  });

  test('listMedia sends album, ordering and pagination', () async {
    responses['listAlbums'] =
        (_) => Generator.generateAlbumsJson(mediumType: MediumType.image);
    responses['listMedia'] = (call) => Generator.generateMediaPageJson(
          albumId: call.arguments['albumId'],
          mediumType: MediumType.image,
          skip: call.arguments['skip'],
          take: call.arguments['take'],
        );
    final albums = await PhotoGallery.listAlbums(
      mediumType: MediumType.image,
      newest: false,
    );
    await albums.first.listMedia(skip: 2, take: 3, lightWeight: true);
    final call = calls.last;
    expect(call.method, 'listMedia');
    expect(call.arguments['albumId'], albums.first.id);
    expect(call.arguments['mediumType'], 'image');
    expect(call.arguments['newest'], false);
    expect(call.arguments['skip'], 2);
    expect(call.arguments['take'], 3);
    expect(call.arguments['lightWeight'], true);
  });

  test('getThumbnail throws when native returns null', () async {
    expect(PhotoGallery.getThumbnail(mediumId: '1'), throwsA(isA<String>()));
  });

  test('getAlbumThumbnail throws when native returns null', () async {
    expect(
      PhotoGallery.getAlbumThumbnail(albumId: '1'),
      throwsA(isA<String>()),
    );
  });

  test('getFile throws when native returns null', () async {
    expect(PhotoGallery.getFile(mediumId: '1'), throwsA(isA<String>()));
  });
}
