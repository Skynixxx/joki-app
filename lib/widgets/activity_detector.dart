import 'package:flutter/material.dart';
import '../services/session_manager.dart';

class ActivityDetector extends StatelessWidget {
  final Widget child;

  const ActivityDetector({super.key, required this.child});

  void _onActivity() {
    SessionManager.resetIdleTimer();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onActivity,
      onPanDown: (_) => _onActivity(),
      onScaleStart: (_) => _onActivity(),
      behavior: HitTestBehavior.translucent,
      child: Listener(
        onPointerDown: (_) => _onActivity(),
        onPointerMove: (_) => _onActivity(),
        onPointerUp: (_) => _onActivity(),
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            _onActivity();
            return false;
          },
          child: child,
        ),
      ),
    );
  }
}
