// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import '../../lib/models/KitsuModel.dart';
import '../../lib/services/KitsuApiService.dart';

void main() {
  test('Kitsu API service test', () async {
    KitsuApiService kitsuApiService = KitsuApiService();
    KitsuModel kitsuModel = await kitsuApiService.getKitsuModel(43124, false);
    expect(kitsuModel.trailerURL, "rU6HjgMIIBs");
  });
}
