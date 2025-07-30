import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_spacing.dart';

/// Audio waveform widget that displays waveform visualization
/// and allows seeking through audio content by tapping on the waveform
class AudioWaveform extends ConsumerStatefulWidget {
  final List<double> waveformData;
  final Duration? duration;
  final Duration currentPosition;
  final Function(Duration)? onSeek;
  final bool isLoading;

  const AudioWaveform({
    super.key,
    required this.waveformData,
    this.duration,
    required this.currentPosition,
    this.onSeek,
    this.isLoading = false,
  });

  @override
  ConsumerState<AudioWaveform> createState() => _AudioWaveformState();
}

class _AudioWaveformState extends ConsumerState<AudioWaveform> {
  bool _isDragging = false;
  double _dragValue = 0.0;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0
        ? "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds"
        : "$twoDigitMinutes:$twoDigitSeconds";
  }

  void _handleSeek(double position) {
    if (widget.duration != null && widget.onSeek != null) {
      final seekPosition = Duration(
        milliseconds: (position * widget.duration!.inMilliseconds).round(),
      );
      widget.onSeek!(seekPosition);
    }
  }

  void _handleDragStart(double position) {
    setState(() {
      _isDragging = true;
      _dragValue = position;
    });
  }

  void _handleDragUpdate(double position) {
    setState(() {
      _dragValue = position.clamp(0.0, 1.0);
    });
  }

  void _handleDragEnd() {
    _handleSeek(_dragValue);
    setState(() {
      _isDragging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (widget.isLoading || widget.waveformData.isEmpty || widget.duration == null) {
      return _buildLoadingWaveform(context);
    }

    // Calculate progress value, ensuring we handle division by zero
    final progressValue = widget.duration!.inMilliseconds > 0
        ? _isDragging
            ? _dragValue
            : widget.currentPosition.inMilliseconds / widget.duration!.inMilliseconds
        : 0.0;

    return Column(
      children: [
        Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
          child: GestureDetector(
            onTapDown: (details) {
              final RenderBox box = context.findRenderObject() as RenderBox;
              final localPosition = box.globalToLocal(details.globalPosition);
              final position = (localPosition.dx / box.size.width).clamp(0.0, 1.0);
              _handleDragStart(position);
              _handleSeek(position);
            },
            onPanStart: (details) {
              final RenderBox box = context.findRenderObject() as RenderBox;
              final localPosition = box.globalToLocal(details.globalPosition);
              final position = (localPosition.dx / box.size.width).clamp(0.0, 1.0);
              _handleDragStart(position);
            },
            onPanUpdate: (details) {
              final RenderBox box = context.findRenderObject() as RenderBox;
              final localPosition = box.globalToLocal(details.globalPosition);
              final position = (localPosition.dx / box.size.width).clamp(0.0, 1.0);
              _handleDragUpdate(position);
            },
            onPanEnd: (details) {
              _handleDragEnd();
            },
            child: CustomPaint(
              size: const Size(double.infinity, 80),
              painter: WaveformPainter(
                waveformData: widget.waveformData,
                progressValue: progressValue.clamp(0.0, 1.0),
                inactiveColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                activeColor: colorScheme.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.medium),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isDragging && widget.duration != null
                    ? _formatDuration(Duration(milliseconds: (_dragValue * widget.duration!.inMilliseconds).round()))
                    : _formatDuration(widget.currentPosition),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                widget.duration != null 
                    ? _formatDuration(widget.duration!)
                    : '--:--',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingWaveform(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(
              50,
              (index) => Container(
                width: 3.0,
                height: 20.0 + (index % 4) * 15.0,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.medium),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '--:--',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '--:--',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Custom painter for drawing waveform visualization
class WaveformPainter extends CustomPainter {
  final List<double> waveformData;
  final double progressValue;
  final Color inactiveColor;
  final Color activeColor;

  WaveformPainter({
    required this.waveformData,
    required this.progressValue,
    required this.inactiveColor,
    required this.activeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (waveformData.isEmpty) return;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final barWidth = size.width / waveformData.length;
    final centerY = size.height / 2;
    final progressX = size.width * progressValue;

    for (int i = 0; i < waveformData.length; i++) {
      final x = i * barWidth;
      final amplitude = waveformData[i];
      final barHeight = amplitude * size.height * 0.8;
      
      paint.color = x <= progressX ? activeColor : inactiveColor;
      
      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x + barWidth / 2, centerY),
          width: barWidth * 0.8,
          height: barHeight,
        ),
        const Radius.circular(1.5),
      );
      
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    // Only repaint if there's a meaningful difference in progress
    const double threshold = 0.001;
    return (oldDelegate.progressValue - progressValue).abs() > threshold ||
           oldDelegate.waveformData != waveformData ||
           oldDelegate.activeColor != activeColor ||
           oldDelegate.inactiveColor != inactiveColor;
  }
}