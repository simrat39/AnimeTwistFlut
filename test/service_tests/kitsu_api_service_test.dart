// Package imports:
import 'package:anime_twist_flut/models/KitsuModel.dart';
import 'package:anime_twist_flut/services/KitsuApiService.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:

void main() {
  test('Kitsu API service test', () async {
    KitsuModel kitsuModel = await KitsuApiService.getKitsuModel(43124, false);
    expect(kitsuModel.trailerURL, "rU6HjgMIIBs");
  });
}
