import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:intl/intl.dart';

class GraphWidget extends StatelessWidget {
  final Map<DateTime, double> data;
  final String chartType;
  final Color color;

  const GraphWidget({
    super.key,
    required this.data,
    required this.chartType,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    developer.log("GraphWidget data: $data", name: 'GraphWidget');

    if (data.isEmpty) {
      return Center(
        child: Text(
          'No Data Available',
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
        ),
      );
    }

    // Sort data by timestamp
    final sortedEntries = data.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    final values = sortedEntries.map((e) => e.value).toList();
    final timestamps = sortedEntries.map((e) => e.key).toList();

    final maxValue = values.isNotEmpty ? values.reduce((a, b) => a > b ? a : b) : 0.0;
    final minValue = values.isNotEmpty ? values.reduce((a, b) => a < b ? a : b) : 0.0;
    final avgValue = values.isNotEmpty ? values.reduce((a, b) => a + b) / values.length : 0.0;

    return Column(
      children: [
        Expanded(
          child: chartType == 'line'
              ? _buildLineProgress(values, timestamps, maxValue, minValue)
              : chartType == 'bar'
                  ? _buildBarProgress(values, timestamps)
                  : _buildPieProgress(values.last),
        ),
        const SizedBox(height: 12),
        _buildStatsRow(values.isNotEmpty ? values.last : 0.0, maxValue, minValue, avgValue),
      ],
    );
  }

  Widget _buildLineProgress(List<double> values, List<DateTime> timestamps, double maxValue, double minValue) {
    return CustomPaint(
      painter: LineChartPainter(values: values, timestamps: timestamps, color: color),
      child: Container(),
    );
  }

  Widget _buildBarProgress(List<double> values, List<DateTime> timestamps) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(values.length, (index) {
        final value = values[index];
        final normalizedHeight = value / (values.reduce((a, b) => a > b ? a : b) + 0.01);
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 100 * normalizedHeight,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                color: color,
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('HH:mm').format(timestamps[index]),
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPieProgress(double value) {
    return CustomPaint(
      painter: PieChartPainter(value: value, color: color),
      child: Container(),
    );
  }

  Widget _buildStatsRow(double lastValue, double maxValue, double minValue, double avgValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatColumn('Last', lastValue.toStringAsFixed(1)),
        _buildStatColumn('Max', maxValue.toStringAsFixed(1)),
        _buildStatColumn('Min', minValue.toStringAsFixed(1)),
        _buildStatColumn('Avg', avgValue.toStringAsFixed(1)),
      ],
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<double> values;
  final List<DateTime> timestamps;
  final Color color;

  LineChartPainter({required this.values, required this.timestamps, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    developer.log("LineChartPainter rendering ${values.length} points: $values", name: 'LineChartPainter');

    if (values.length < 2 || timestamps.length != values.length || values.any((v) => !v.isFinite)) {
      developer.log("LineChartPainter: Invalid data, skipping paint", name: 'LineChartPainter');
      return;
    }

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final minValue = values.reduce((a, b) => a < b ? a : b);

    for (int i = 0; i < values.length; i++) {
      final x = (i / (values.length - 1)) * size.width;
      final normalizedValue = maxValue == minValue ? 0.5 : (values[i] - minValue) / (maxValue - minValue);
      final y = size.height * (1 - normalizedValue * 0.8); // Scale to 80% of height
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (int i = 0; i < values.length; i++) {
      final x = (i / (values.length - 1)) * size.width;
      final normalizedValue = maxValue == minValue ? 0.5 : (values[i] - minValue) / (maxValue - minValue);
      final y = size.height * (1 - normalizedValue * 0.8);
      canvas.drawCircle(Offset(x, y), 4.0, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PieChartPainter extends CustomPainter {
  final double value;
  final Color color;

  PieChartPainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final sweepAngle = (value / 100) * 2 * 3.14159; // Assuming value is percentage-like

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      sweepAngle,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}