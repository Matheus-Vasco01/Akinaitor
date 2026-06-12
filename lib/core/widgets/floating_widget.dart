import 'package:flutter/material.dart';

class FloatingWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offset;

  const FloatingWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.offset = 12.0,
  });

  @override
  State<FloatingWidget> createState() => _FloatingWidgetState();
}

class _FloatingWidgetState extends State<FloatingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -widget.offset / 2, end: widget.offset / 2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
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
        return Transform.translate(
          offset: Offset(0.0, _animation.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
