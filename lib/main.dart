import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF38BDF8),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF38BDF8),
          secondary: Color(0xFF818CF8),
          surface: Color(0xFF1E293B),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    ForecastDashboardTab(),
    AiArchitectureTab(),
    ProjectPitchTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _screens[_selectedIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: const Color(0xFF1E293B),
        indicatorColor: const Color(0xFF38BDF8).withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.cloud_queue_rounded),
            selectedIcon: Icon(Icons.cloud_rounded, color: Color(0xFF38BDF8)),
            label: 'Forecast',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology_outlined),
            selectedIcon: Icon(Icons.psychology_rounded, color: Color(0xFF38BDF8)),
            label: 'AI Model',
          ),
          NavigationDestination(
            icon: Icon(Icons.slideshow_outlined),
            selectedIcon: Icon(Icons.slideshow_rounded, color: Color(0xFF38BDF8)),
            label: 'Pitch & PPT',
          ),
        ],
      ),
    );
  }
}

class ForecastDashboardTab extends StatelessWidget {
  const ForecastDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SIH 2026 Innovation',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF38BDF8),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Monsoon AI Forecast',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E).withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF22C55E)),
              ),
              child: const Row(
                children: [
                  CircleAvatar(radius: 4, backgroundColor: Color(0xFF22C55E)),
                  SizedBox(width: 6),
                  Text('Active Regime', style: TextStyle(color: Color(0xFF22C55E), fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEF4444).withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.4)),
          ),
          child: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 30),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Extreme Event Alert', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold, fontSize: 15)),
                    SizedBox(height: 2),
                    Text('High risk of localized intense spells (+65mm/day) over Central India.', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text('Bias Correction Engine', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Raw NWP Model',
                value: '48.2 mm',
                subtitle: 'Significant Dry Bias',
                color: const Color(0xFF94A3B8),
                badge: 'Input',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                title: 'AI Corrected',
                value: '72.6 mm',
                subtitle: '89.4% Accuracy',
                color: const Color(0xFF38BDF8),
                badge: 'Regime-Aware',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildStatSection(),
      ],
    );
  }

  static Widget _buildMetricCard({required String title, required String value, required String subtitle, required Color color, required String badge}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(badge, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
              Icon(Icons.insights, color: color, size: 18),
            ],
          ),
          const SizedBox(height: 14),
          Text(value, style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 13, color: Colors.white60)),
          const SizedBox(height: 6),
          Text(subtitle, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  static Widget _buildStatSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Verification Metrics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 16),
          _buildProgressRow('RMSE Reduction', '41.8%', 0.75, const Color(0xFF22C55E)),
          const SizedBox(height: 12),
          _buildProgressRow('Spatial Correlation', '0.88', 0.88, const Color(0xFF38BDF8)),
          const SizedBox(height: 12),
          _buildProgressRow('False Alarm Reduction', '34.0%', 0.65, const Color(0xFFF59E0B)),
        ],
      ),
    );
  }

  static Widget _buildProgressRow(String label, String value, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, color: Colors.white70)),
            Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white10,
          color: color,
          minHeight: 6,
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }
}

class AiArchitectureTab extends StatelessWidget {
  const AiArchitectureTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Workflow & Pipeline', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Regime-Aware Post-Processing Pipeline', style: TextStyle(color: Colors.white60, fontSize: 13)),
        const SizedBox(height: 20),
        _buildPipelineStep('1. Synoptic Classifier', 'Classifies weather dynamics into Active, Break, or Cyclonic patterns using clustering.', Icons.hub_rounded),
        _buildPipelineStep('2. Non-linear Bias Correction', 'Uses attention-based residual networks customized for the active monsoon regime.', Icons.tune_rounded),
        _buildPipelineStep('3. Extreme Tail Modeling', 'Applies Extreme Value Loss (EVL) to capture heavy precipitation events without smoothing.', Icons.water_drop_rounded),
        _buildPipelineStep('4. Decision-Ready Output', 'Pours probabilistic risk scores and high-resolution spatial maps to users.', Icons.done_all_rounded),
      ],
    );
  }

  static Widget _buildPipelineStep(String title, String desc, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF38BDF8).withOpacity(0.15),
            foregroundColor: const Color(0xFF38BDF8),
            child: Icon(icon, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectPitchTab extends StatelessWidget {
  const ProjectPitchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Pitch Summary & PPT', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Smart India Hackathon 2026 Presentation Points', style: TextStyle(color: Colors.white60, fontSize: 13)),
        const SizedBox(height: 20),
        _buildPitchCard(
          'Problem Statement',
          'Standard Numerical Weather Prediction (NWP) models suffer from severe systematic errors, failing to predict localized flash floods and active-break transitions during monsoons.',
          Icons.report_problem_outlined,
        ),
        _buildPitchCard(
          'Our Novel Solution',
          'Instead of applying a single blanket AI filter, our model identifies the prevailing atmospheric regime first and routes data to specialized neural weights.',
          Icons.lightbulb_outline,
        ),
        _buildPitchCard(
          'Impact & Beneficiaries',
          'Provides disaster management authorities (NDRF/SDMA) with 48 hours of actionable lead-time, preventing crop failure and urban infrastructure losses.',
          Icons.public_rounded,
        ),
      ],
    );
  }

  static Widget _buildPitchCard(String heading, String body, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF38BDF8), size: 20),
              const SizedBox(width: 10),
              Text(heading, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF38BDF8))),
            ],
          ),
          const SizedBox(height: 8),
          Text(body, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
        ],
      ),
    );
  }
}
