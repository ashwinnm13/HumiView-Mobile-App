import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/sensor_reading.dart';

class LiveLineChart extends StatefulWidget {
  const LiveLineChart({
    super.key,
    required this.data,
    required this.title,
    required this.unit,
    required this.color,
    required this.minY,
    required this.maxY,
    required this.valueMapper,
    this.showLiveIndicator = true,
  });

  final List<SensorReading> data;
  final String title;
  final String unit;
  final Color color;
  final double minY;
  final double maxY;
  final double Function(SensorReading) valueMapper;
  final bool showLiveIndicator;

  @override
  State<LiveLineChart> createState() => _LiveLineChartState();
}

class _LiveLineChartState extends State<LiveLineChart> {
  /// Max data points visible in the viewport at once.
  static const int _maxVisible = 15;

  /// Start index of the current viewport window.
  int _viewStart = 0;

  /// Whether the chart is auto-following the latest data.
  bool _trackingLatest = true;

  @override
  void didUpdateWidget(LiveLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When new data arrives and we're tracking the latest, keep viewport pinned to end
    if (widget.data.length > oldWidget.data.length && _trackingLatest) {
      _viewStart = (widget.data.length - _maxVisible).clamp(0, widget.data.length);
    }
  }

  void _onHorizontalDrag(DragUpdateDetails details) {
    if (widget.data.length <= _maxVisible) return;
    setState(() {
      // Drag right (positive dx) → go earlier; drag left (negative dx) → go later
      final sensitivity = (widget.data.length / 200.0).clamp(0.3, 3.0);
      final delta = (-details.delta.dx * sensitivity).round();
      final maxStart = widget.data.length - _maxVisible;
      _viewStart = (_viewStart + delta).clamp(0, maxStart);
      _trackingLatest = _viewStart >= maxStart;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    // Determine visible slice
    final int totalPoints = widget.data.length;
    final int visibleCount = totalPoints < _maxVisible ? totalPoints : _maxVisible;
    final int start = totalPoints <= _maxVisible ? 0 : _viewStart.clamp(0, totalPoints - visibleCount);
    final int end = (start + visibleCount).clamp(0, totalPoints);
    final visibleData = widget.data.sublist(start, end);

    final spots = visibleData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), widget.valueMapper(entry.value));
    }).toList();

    // Dynamically adjust Y bounds so real data isn't clipped
    final dataMinY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final dataMaxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);

    double actualMinY = dataMinY < widget.minY ? dataMinY - (dataMinY.abs() * 0.05) : widget.minY;
    double actualMaxY = dataMaxY > widget.maxY ? dataMaxY + (dataMaxY.abs() * 0.05) : widget.maxY;
    if (actualMinY == actualMaxY) {
      actualMinY -= 5;
      actualMaxY += 5;
    }

    final intervalY = (actualMaxY - actualMinY) / 4;
    final safeIntervalY = intervalY <= 0 ? 1.0 : intervalY;

    // X-axis: show ~4 evenly-spaced labels to prevent overlap
    final xInterval = (visibleData.length > 4 ? visibleData.length / 4 : 1).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  widget.title,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textPrimary,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.showLiveIndicator) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'LIVE',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          backgroundColor: AppColors.surface,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(widget.title, style: AppTypography.headlineSmall),
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () => Navigator.of(context).pop(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Expanded(
                                    child: LiveLineChart(
                                      data: widget.data,
                                      title: '',
                                      unit: widget.unit,
                                      color: widget.color,
                                      minY: widget.minY,
                                      maxY: widget.maxY,
                                      valueMapper: widget.valueMapper,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.zoom_out_map, color: AppColors.textSecondary, size: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Scroll position indicator bar
          if (totalPoints > _maxVisible)
            Padding(
              padding: const EdgeInsets.only(left: 40, bottom: 8),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxStart = totalPoints - _maxVisible;
                  final fraction = maxStart > 0 ? start / maxStart : 0.0;
                  final thumbWidth = (constraints.maxWidth * 0.3).clamp(30.0, 80.0);
                  final trackWidth = constraints.maxWidth - thumbWidth;
                  return Stack(
                    children: [
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Positioned(
                        left: trackWidth * fraction,
                        child: Container(
                          width: thumbWidth,
                          height: 4,
                          decoration: BoxDecoration(
                            color: widget.color.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
        Expanded(
          child: GestureDetector(
            onHorizontalDragUpdate: _onHorizontalDrag,
            behavior: HitTestBehavior.translucent,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: safeIntervalY,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.divider,
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: xInterval,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= visibleData.length) {
                          return const SizedBox.shrink();
                        }
                        
                        // Prevent overlapping: if this is the very last label and it is NOT a multiple of xInterval,
                        // and it's too close to the previous interval, hide it.
                        // Wait, fl_chart forces a label at minX and maxX if minX/maxX is not a multiple of interval.
                        if (index == visibleData.length - 1 && (index % xInterval) > 0) {
                          final prevInterval = (index ~/ xInterval) * xInterval;
                          if (index - prevInterval < xInterval * 0.7) {
                            return const SizedBox.shrink();
                          }
                        }

                        final time = visibleData[index].timestamp;
                        final formatter = DateFormat('HH:mm');
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            formatter.format(time),
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: safeIntervalY,
                      reservedSize: 36,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(0),
                          style: AppTypography.caption,
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: visibleData.length > 1 ? (visibleData.length - 1).toDouble() : 1.0,
                minY: actualMinY,
                maxY: actualMaxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: widget.color,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: visibleData.length == 1,
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          widget.color.withValues(alpha: 0.3),
                          widget.color.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => AppColors.textPrimary,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final dataIndex = spot.spotIndex;
                        if (dataIndex < 0 || dataIndex >= visibleData.length) {
                          return null;
                        }
                        return LineTooltipItem(
                          '${spot.y.toStringAsFixed(1)}${widget.unit}\n',
                          AppTypography.labelMedium.copyWith(color: AppColors.surface, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: DateFormat('HH:mm:ss').format(visibleData[dataIndex].timestamp),
                              style: AppTypography.labelSmall.copyWith(color: AppColors.surface.withValues(alpha: 0.7)),
                            ),
                          ],
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
