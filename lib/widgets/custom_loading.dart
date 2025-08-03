import 'package:flutter/material.dart';

class CustomLoadingWidget extends StatefulWidget {
  final double size;
  final Color? color;

  const CustomLoadingWidget({super.key, this.size = 50.0, this.color});

  @override
  State<CustomLoadingWidget> createState() => _CustomLoadingWidgetState();
}

class _CustomLoadingWidgetState extends State<CustomLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            children: [
              // Outer circle
              Transform.rotate(
                angle: _animation.value * 2 * 3.14159,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: (widget.color ?? const Color(0xFF6B73FF))
                          .withValues(alpha: 0.2),
                      width: 3,
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(widget.size * 0.1),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.color ?? const Color(0xFF6B73FF),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),

              // Inner rotating dots
              ...List.generate(3, (index) {
                return Transform.rotate(
                  angle:
                      (_animation.value * 2 * 3.14159) +
                      (index * 2 * 3.14159 / 3),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: widget.size * 0.05),
                      width: widget.size * 0.1,
                      height: widget.size * 0.1,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.color ?? const Color(0xFF6B73FF),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
