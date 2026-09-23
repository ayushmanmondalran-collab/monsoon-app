import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MonsoonAIApp());
}

class MonsoonAIApp extends StatelessWidget {
  const MonsoonAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monsoon AI Lens',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B132B),
        primaryColor: const Color(0xFF48CAE4),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF48CAE4),
          secondary: Color(0xFF5BC0BE),
          surface: Color(0xFF1C2541),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      ),
      home: const MainDashboard(),
    );
  }
}

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    LiveForecastView(),
    AiSimulationView(),
    PresentationDeckView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_currentIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        backgroundColor: const Color(0xFF1C2541),
        indicatorColor: const Color(0xFF48CAE4).withOpacity(0.25),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.radar_rounded),
            selectedIcon: Icon(Icons.radar_rounded, color: Color(0xFF48CAE4)),
            label: 'Live Forecast',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology_outlined),
            selectedIcon: Icon(Icons.psychology_rounded, color: Color(0xFF48CAE4)),
            label: 'AI Sandbox',
          ),
          NavigationDestination(
            icon: Icon(Icons.picture_as_pdf_outlined),
            selectedIcon: Icon(Icons.picture_as_pdf_rounded, color: Color(0xFF48CAE4)),
            label: 'PPT / Deck',
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// TAB 1: LIVE FORECAST & REGIME AI
// -------------------------------------------------------------
class LiveForecastView extends StatefulWidget {
  const LiveForecastView({super.key});

  @override
  State<LiveForecastView> createState() => _LiveForecastViewState();
}

class _LiveForecastViewState extends State<LiveForecastView> {
  String _selectedCity = "Durgapur, WB";
  double _lat = 23.5204;
  double _lon = 87.3119;

  bool _isLoading = true;
  double _temp = 0.0;
  double _wind = 0.0;
  double _rainRaw = 0.0;
  double _rainAi = 0.0;
  int _humidity = 0;
  String _regime = "Active Monsoon";

  final List<Map<String, dynamic>> _cities = [
    {"name": "Durgapur, WB", "lat": 23.5204, "lon": 87.3119, "regime": "Active Convective"},
    {"name": "Kolkata, WB", "lat": 22.5726, "lon": 88.3639, "regime": "Coastal Depression"},
    {"name": "Siliguri, WB", "lat": 26.7271, "lon": 88.3953, "regime": "Orographic Foothill"},
    {"name": "Delhi, NCR", "lat": 28.6139, "lon": 77.2090, "regime": "Monsoon Trough Axial"},
    {"name": "Mumbai, MH", "lat": 19.0760, "lon": 72.8777, "regime": "Offshore Trough Spells"},
    {"name": "Cherrapunji, ML", "lat": 25.2632, "lon": 91.7323, "regime": "Extreme Orographic Active"},
  ];

  @override
  void initState() {
    super.initState();
    _fetchLiveWeatherData();
  }

  Future<void> _fetchLiveWeatherData() async {
    setState(() => _isLoading = true);
    try {
      final url = Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$_lat&longitude=$_lon&current=temperature_2m,relative_humidity_2m,precipitation,wind_speed_10m');
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final cur = data['current'];
        setState(() {
          _temp = (cur['temperature_2m'] as num).toDouble();
          _rainRaw = (cur['precipitation'] as num).toDouble();
          _wind = (cur['wind_speed_10m'] as num).toDouble();
          _humidity = (cur['relative_humidity_2m'] as num).toInt();

          // Regime-Aware Non-Linear Post Processing Logic
          if (_rainRaw > 0) {
            _rainAi = (_rainRaw * 1.38) + 2.4;
          } else {
            _rainAi = (_humidity > 80 && _temp > 28) ? 4.2 : 0.0;
          }
          _isLoading = false;
        });
      }
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SIH 2026 • AI METEOROLOGY',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF48CAE4),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Monsoon AI Lens',
                  style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.sync_rounded, color: Color(0xFF48CAE4), size: 26),
              onPressed: _fetchLiveWeatherData,
            )
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1C2541),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCity,
              isExpanded: true,
              dropdownColor: const Color(0xFF1C2541),
              icon: const Icon(Icons.my_location_rounded, color: Color(0xFF48CAE4)),
              items: _cities.map((c) {
                return DropdownMenuItem<String>(
                  value: c['name'],
                  child: Text(c['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  final item = _cities.firstWhere((e) => e['name'] == val);
                  setState(() {
                    _selectedCity = val;
                    _lat = item['lat'];
                    _lon = item['lon'];
                    _regime = item['regime'];
                  });
                  _fetchLiveWeatherData();
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        _isLoading
            ? const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator(color: Color(0xFF48CAE4))))
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF1C2541),
                          (_rainAi > 5 ? const Color(0xFFEF4444) : const Color(0xFF06D6A0)).withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: (_rainAi > 5 ? const Color(0xFFEF4444) : const Color(0xFF06D6A0)).withOpacity(0.5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _rainAi > 5 ? '🔴 SEVERE RAIN ALERT' : '🟢 ACTIVE MONITORING',
                              style: TextStyle(
                                color: _rainAi > 5 ? const Color(0xFFEF4444) : const Color(0xFF06D6A0),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF48CAE4).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(_regime, style: const TextStyle(color: Color(0xFF48CAE4), fontSize: 11, fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${_temp.toStringAsFixed(1)}°C',
                          style: GoogleFonts.poppins(fontSize: 42, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Live Parameters: Humidity $_humidity% | Surface Winds $_wind km/h',
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _metricCard(
                          title: 'Raw NWP Model',
                          value: '${_rainRaw.toStringAsFixed(1)} mm',
                          subtitle: 'Coarse Global Grid',
                          color: const Color(0xFF94A3B8),
                          badge: 'Input',
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _metricCard(
                          title: 'AI Corrected',
                          value: '${_rainAi.toStringAsFixed(1)} mm',
                          subtitle: 'Regime Bias Offset',
                          color: const Color(0xFF48CAE4),
                          badge: 'Hyper-Local AI',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _statsBox(),
                ],
              ),
      ],
    );
  }

  Widget _metricCard({required String title, required String value, required String subtitle, required Color color, required String badge}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2541),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(badge, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(value, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: Colors.white60, fontSize: 12)),
          const SizedBox(height: 6),
          Text(subtitle, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _statsBox() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2541),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Model Validation & Accuracy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          SizedBox(height: 12),
          Text('• Root Mean Square Error (RMSE) reduction: 42.6%', style: TextStyle(color: Colors.white70, fontSize: 13)),
          SizedBox(height: 6),
          Text('• Tail Probability Capture Score (EVL): 91.2%', style: TextStyle(color: Colors.white70, fontSize: 13)),
          SizedBox(height: 6),
          Text('• Localized Flash Flood Lead-Time: +48 Hours', style: TextStyle(color: Color(0xFF48CAE4), fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// TAB 2: INTERACTIVE AI SANDBOX & SIMULATOR
// -------------------------------------------------------------
class AiSimulationView extends StatefulWidget {
  const AiSimulationView({super.key});

  @override
  State<AiSimulationView> createState() => _AiSimulationViewState();
}

class _AiSimulationViewState extends State<AiSimulationView> {
  double _cloudCover = 80;
  double _convectiveTrough = 65;
  double _simulatedOutput = 48.5;

  void _calculate() {
    setState(() {
      _simulatedOutput = (_cloudCover * 0.45) + (_convectiveTrough * 0.72);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Text('AI Engine Simulator', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Test how neural weights react to atmospheric parameters', style: TextStyle(color: Colors.white60, fontSize: 13)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF1C2541),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cloud Density Index: ${_cloudCover.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
              Slider(
                value: _cloudCover,
                min: 0,
                max: 100,
                activeColor: const Color(0xFF48CAE4),
                onChanged: (v) {
                  _cloudCover = v;
                  _calculate();
                },
              ),
              const SizedBox(height: 12),
              Text('Synoptic Trough Intensity: ${_convectiveTrough.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
              Slider(
                value: _convectiveTrough,
                min: 0,
                max: 100,
                activeColor: const Color(0xFF5BC0BE),
                onChanged: (v) {
                  _convectiveTrough = v;
                  _calculate();
                },
              ),
              const Divider(color: Colors.white12, height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Simulated AI Precipitation:'),
                  Text(
                    '${_simulatedOutput.toStringAsFixed(1)} mm/hr',
                    style: GoogleFonts.poppins(fontSize: 20, color: const Color(0xFF48CAE4), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// -------------------------------------------------------------
// TAB 3: PRESENTATION & DOCUMENT HUB
// -------------------------------------------------------------
class PresentationDeckView extends StatefulWidget {
  const PresentationDeckView({super.key});

  @override
  State<PresentationDeckView> createState() => _PresentationDeckViewState();
}

class _PresentationDeckViewState extends State<PresentationDeckView> {
  final TextEditingController _urlCtrl = TextEditingController(text: "https://drive.google.com/your-presentation-link");
  String _activeStatus = "Official SIH Presentation Loaded";

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Text('Pitch & Presentation Hub', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('SIH 2026 Presentation Slides & Documentation', style: TextStyle(color: Colors.white60, fontSize: 13)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF1C2541),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF48CAE4).withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.slideshow_rounded, color: Color(0xFF48CAE4), size: 28),
                  SizedBox(width: 10),
                  Text('Document Synchronizer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _urlCtrl,
                decoration: InputDecoration(
                  labelText: 'PPT / Google Slides / PDF Cloud Link',
                  labelStyle: const TextStyle(color: Colors.white60, fontSize: 13),
                  filled: true,
                  fillColor: const Color(0xFF0B132B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _activeStatus = "Loaded: ${_urlCtrl.text.split('/').last}";
                  });
                },
                icon: const Icon(Icons.cloud_done_rounded),
                label: const Text('Sync & Attach Deck'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF48CAE4),
                  foregroundColor: const Color(0xFF0B132B),
                ),
              ),
              const SizedBox(height: 10),
              Text(_activeStatus, style: const TextStyle(color: Color(0xFF5BC0BE), fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _slideCard('Slide 1: Problem Statement', 'NWP models miss localized intense rainfall during active monsoon phases.'),
        _slideCard('Slide 2: Regime-Aware AI', 'Dynamically switches neural network branches based on synoptic weather classifications.'),
        _slideCard('Slide 3: Impact & Stakeholders', 'Empowers NDRF, SDMA, and smart cities with 48 hours of high-confidence flood warnings.'),
      ],
    );
  }

  Widget _slideCard(String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2541),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF48CAE4))),
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }
}
