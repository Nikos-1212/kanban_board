import 'dart:async';
import 'dart:ui';

class Debouncer {
  final Duration delay;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.delay});

  Future<void> run(VoidCallback action) async{
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
