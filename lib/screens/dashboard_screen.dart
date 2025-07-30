import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:weather_buddy/model/weather_model.dart';

import 'package:weather_buddy/providers/weather_provider.dart';
import 'package:weather_buddy/widgets/graph_widget.dart';
import 'dart:ui';
import 'dart:developer' as developer;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  final dateFormat = DateFormat("yyyy-MM-dd");
  Map<String, String> chartTypes = {};
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> config = [
    {
      "key": "temperature",
      "label": "Temperature",
      "unit": "°C",
      "icon": Icons.thermostat,
      "color": const Color(0xFFFF5722),
    },
    {
      "key": "humidity",
      "label": "Humidity",
      "unit": "%",
      "icon": Icons.water_drop,
      "color": const Color(0xFF2196F3),
    },
    {
      "key": "windSpeed",
      "label": "Wind Speed",
      "unit": "km/h",
      "icon": Icons.air,
      "color": const Color(0xFF4CAF50),
    },
    {
      "key": "rainfall",
      "label": "Rainfall",
      "unit": "mm",
      "icon": Icons.umbrella,
      "color": const Color(0xFF9C27B0),
    },
    {
      "key": "pressure",
      "label": "Pressure",
      "unit": "hPa",
      "icon": Icons.speed,
      "color": const Color(0xFFFFEB3B),
    },
    {
      "key": "uvRays",
      "label": "UV Index",
      "unit": "",
      "icon": Icons.wb_sunny,
      "color": const Color(0xFF795548),
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.elasticOut,
          ),
        );

    for (var item in config) {
      chartTypes[item['key'] as String] =
          'line'; // Default to line for time-series
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<WeatherProvider>(context, listen: false);
      provider.fetchData(selectedDate: selectedDate);
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E3A8A), Color(0xFF1E40AF), Color(0xFF3B82F6)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(20.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildAppBar(),
                        const SizedBox(height: 24),
                        // _buildWeatherHeader(weather),
                        const SizedBox(height: 24),
                        _buildCalendar(),
                        Consumer<WeatherProvider>(
                          builder: (context, provider, _) {
                            final weather = provider.dataList.isNotEmpty
                                ? provider.dataList.last
                                : null;
                            return provider.isLoading
                                ? const ShimmerLoader()
                                : weather == null
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          color: Colors.white.withOpacity(0.8),
                                          size: 40,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Failed to load weather data. Please try again.',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.8,
                                            ),
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () => provider.fetchData(
                                            selectedDate: selectedDate,
                                          ),
                                          child: const Text('Retry'),
                                        ),
                                      ],
                                    ),
                                  )
                                : _refreshSection(weather);
                          },
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _refreshSection(WeatherData? weather) {
    return Column(
      children: [
        const SizedBox(height: 24),
        _buildSectionTitle("Weather Overview"),
        const SizedBox(height: 16),
        _buildWeatherOverview(weather),
        const SizedBox(height: 32),
        _buildSectionTitle("Charts & Analytics"),
        const SizedBox(height: 16),
        _buildChartsGrid(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 0.5,
          shadows: [
            Shadow(color: Colors.black26, offset: Offset(1, 2), blurRadius: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Weather Buddy",
                  style: TextStyle(
                    fontFamily: 'PermanentMarker',
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.black38,
                        offset: Offset(2, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Stay informed, stay prepared",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withAlpha(230),

                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    Provider.of<WeatherProvider>(
                      context,
                      listen: false,
                    ).fetchData(selectedDate: selectedDate);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TableCalendar(
              focusedDay: selectedDate,
              firstDay: DateTime(2020),
              lastDay: DateTime(2030),
              calendarFormat: CalendarFormat.week,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Colors.white.withOpacity(0.9),
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Colors.white.withOpacity(0.9),
                ),
                titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withAlpha(230),

                  letterSpacing: 0.5,
                ),
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                weekendTextStyle: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
                defaultTextStyle: TextStyle(
                  color: Colors.white.withAlpha(230),

                  fontWeight: FontWeight.w500,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.white.withAlpha(77),

                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),

                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withAlpha(128),

                    width: 2,
                  ),
                ),
                markersMaxCount: 1,
              ),
              onDaySelected: (date, _) {
                setState(() {
                  selectedDate = date;
                });
                Provider.of<WeatherProvider>(
                  context,
                  listen: false,
                ).fetchData(selectedDate: date);
              },
              selectedDayPredicate: (date) => isSameDay(date, selectedDate),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherOverview(WeatherData? weather) {
    final fieldMap = {
      'temperature': weather?.field1 != null
          ? double.tryParse(weather!.field1!)?.toStringAsFixed(1) ?? 'N/A'
          : 'N/A',
      'humidity': weather?.field2 != null
          ? double.tryParse(weather!.field2!)?.toStringAsFixed(1) ?? 'N/A'
          : 'N/A',
      // 'pressure': weather?.field3 != null ? (double.tryParse(weather!.field3!) / 100).toStringAsFixed(1) : 'N/A',
      'pressure': weather?.field3 != null
          ? (double.tryParse(weather!.field3!) != null
                ? (double.tryParse(weather.field3!)! / 100).toStringAsFixed(1)
                : 'N/A')
          : 'N/A',
      'windSpeed': weather?.field4 != null
          ? double.tryParse(weather!.field4!)?.toStringAsFixed(1) ?? 'N/A'
          : 'N/A',
      'rainfall': weather?.field5 != null
          ? double.tryParse(weather!.field5!)?.toStringAsFixed(1) ?? 'N/A'
          : 'N/A',
      'uvRays': weather?.field6 != null
          ? double.tryParse(weather!.field6!)?.toStringAsFixed(1) ?? 'N/A'
          : 'N/A',
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: config.length,
          itemBuilder: (context, index) {
            final item = config[index];
            final key = item['key'] as String;
            final label = item['label'] as String;
            final unit = item['unit'] as String;
            final icon = item['icon'] as IconData;

            return AnimatedContainer(
              duration: Duration(milliseconds: 200 + (index * 100)),
              curve: Curves.easeOutBack,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(26),

                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withAlpha(51),

                        width: 1,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          // Add haptic feedback or action if needed
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(38),

                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  icon,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "${fieldMap[key]}$unit",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                label,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withAlpha(204),

                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChartsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: constraints.maxWidth > 600 ? 2 : 1,
            childAspectRatio: constraints.maxWidth > 600 ? 1.4 : 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: config.length,
          itemBuilder: (context, index) {
            final item = config[index];
            final graphKey = item['key'] as String;
            final label = item['label'] as String;
            final color = item['color'] as Color;
            final chartType = chartTypes[graphKey] ?? 'line';

            return AnimatedContainer(
              duration: Duration(milliseconds: 300 + (index * 100)),
              curve: Curves.easeOutCubic,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(26),

                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withAlpha(51),

                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  label,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white.withAlpha(230),

                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(26),

                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withAlpha(77),
                                  ),
                                ),
                                child: DropdownButton<String>(
                                  value: chartType,
                                  underline: const SizedBox(),
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                  dropdownColor: Colors.blue.shade800,
                                  items: ['pie', 'bar', 'line'].map((type) {
                                    return DropdownMenuItem(
                                      value: type,
                                      child: Text(
                                        type.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 9,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      chartTypes[graphKey] = val!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: Consumer<WeatherProvider>(
                              builder: (context, provider, _) {
                                final graphData =
                                    provider.getGraphDataForDate(
                                      selectedDate,
                                    )[graphKey] ??
                                    <DateTime, double>{};
                                developer.log(
                                  "ChartsGrid: Data for $graphKey on ${dateFormat.format(selectedDate)}: $graphData",
                                  name: 'DashboardScreen',
                                );
                                return GraphWidget(
                                  data: graphData,
                                  chartType: chartType,
                                  color: color,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withAlpha(179)),
      ),
    );
  }
}
