import 'package:flutter/material.dart';

class PulsingStatusIndicator extends StatefulWidget {
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final double size;

  const PulsingStatusIndicator({
    super.key,
    required this.isActive,
    required this.activeColor,
    this.inactiveColor = Colors.grey,
    this.size = 18.0,
  });

  @override
  State<PulsingStatusIndicator> createState() => _PulsingStatusIndicatorState();
}

class _PulsingStatusIndicatorState extends State<PulsingStatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    if (widget.isActive) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(PulsingStatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.repeat();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We add a little extra padding so the pulse doesn't clip with neighboring elements
    final double maxSize = widget.size * 2.5;

    if (!widget.isActive) {
      return SizedBox(
        width: maxSize,
        height: maxSize,
        child: Center(
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.inactiveColor,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: maxSize,
      height: maxSize,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer radar pulse
              Container(
                width: widget.size + (maxSize - widget.size) * _controller.value,
                height: widget.size + (maxSize - widget.size) * _controller.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.activeColor.withValues(alpha: 1.0 - _controller.value),
                ),
              ),
              // Inner core
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.activeColor,
                  boxShadow: [
                    BoxShadow(
                      color: widget.activeColor.withValues(alpha: 0.6),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
