import 'package:supercharged/supercharged.dart';

/// Infinitely retry a future till we get a response
///
/// Infinitely retries [future] till a response is recieved. If there is an
/// exception, a delay of [delay] milliseconds takes place after which the
/// future is ran again.
Future infinityRetry({
  Future Function() future,
  int delay = 500,
}) async {
  while (true) {
    try {
      return await future();
    } catch (e) {
      Future.delayed(delay.milliseconds);
    }
  }
}
