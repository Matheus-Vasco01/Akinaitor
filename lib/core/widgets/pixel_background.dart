import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class PixelBackground extends StatefulWidget {
  final Widget child;

  const PixelBackground({super.key, required this.child});

  @override
  State<PixelBackground> createState() => _PixelBackgroundState();
}

class _PixelBackgroundState extends State<PixelBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_PixelParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Generate random particles
    for (int i = 0; i < 20; i++) {
      _particles.add(
        _PixelParticle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: (_random.nextInt(3) + 1) * 6.0, // Sizes: 6, 12, 18
          speed: 0.02 + _random.nextDouble() * 0.03,
          opacity: 0.15 + _random.nextDouble() * 0.25,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Particle Background
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Update particles
              for (final particle in _particles) {
                particle.y -= particle.speed * 0.01;
                if (particle.y < -0.05) {
                  particle.y = 1.05;
                  particle.x = _random.nextDouble();
                }
              }
              return CustomPaint(
                painter: _PixelParticlePainter(
                  particles: _particles,
                  color: AppColors.particle,
                ),
                child: Container(),
              );
            },
          ),
          // Content
          widget.child,
        ],
      ),
    );
  }
}

class _PixelParticle {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;

  _PixelParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class _PixelParticlePainter extends CustomPainter {
  final List<_PixelParticle> particles;
  final Color color;

  _PixelParticlePainter({required this.particles, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = color.withValues(alpha: particle.opacity)
        ..style = PaintingStyle.fill;

      // Draw pixel square
      final rect = Rect.fromLTWH(
        particle.x * size.width,
        particle.y * size.height,
        particle.size,
        particle.size,
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
