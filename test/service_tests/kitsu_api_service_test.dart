import '../../lib/services/KitsuApiService.dart';
import '../../lib/models/KitsuModel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Kitsu API service test', () async {
    KitsuApiService kitsuApiService = KitsuApiService();
    KitsuModel kitsuModel = await kitsuApiService.getKitsuModel(43124);
    expect(kitsuModel.trailerURL, "rU6HjgMIIBs");
  });
}
