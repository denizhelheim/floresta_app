import 'dart:async';
import 'dart:math' as math;
import 'dart:ui'; // Glassmorphism için BackdropFilter

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floresta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1C3D32),
          surface: const Color(0xFFF4FAF7),
          primary: const Color(0xFF1C3D32),
          secondary: const Color(0xFF4CAF50),
        ),
        textTheme: GoogleFonts.quicksandTextTheme(
          ThemeData.light().textTheme,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4FAF7),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xFF1C3D32),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/steps': (context) => const StepsDetailScreen(),
        '/heart': (context) => const HeartDetailScreen(),
        '/sleep': (context) => const SleepDetailScreen(),
        '/stress': (context) => const StressDetailScreen(),
        '/ai_report': (context) => const AIReportScreen(),
        '/bluetooth': (context) => const BluetoothScanScreen(),
      },
    );
  }
}

// ==================== YENİ AÇILIŞ EKRANI ====================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  String greeting = "";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      greeting = "Günaydın 🌿";
    } else if (hour >= 12 && hour < 15) {
      greeting = "Tünaydın ☀️";
    } else if (hour >= 15 && hour < 18) {
      greeting = "İyi günler 🌞";
    } else if (hour >= 18 && hour < 22) {
      greeting = "İyi akşamlar 🌅";
    } else {
      greeting = "İyi geceler 🌙";
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! < -300) {
            _goToHome();
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1C3D32), Color(0xFF2E8B57)],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      greeting,
                      style: GoogleFonts.quicksand(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Floresta'ya hoş geldin",
                      style: GoogleFonts.quicksand(
                        fontSize: 20,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(height: 120),
                    Column(
                      children: [
                        const Icon(Icons.keyboard_arrow_up_rounded, size: 48, color: Colors.white),
                        Text(
                          "Yukarı kaydır",
                          style: GoogleFonts.quicksand(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    )..forward();

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart);
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  "Merhaba,",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 34),
                ),
              ),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  "bugün nasılsın? 🌿",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 34),
                ),
              ),
              const SizedBox(height: 12),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  "Sağlık yolculuğun burada başlıyor",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                ),
              ),

              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(child: _buildMiniMotivationCard()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildWaterTrackerCard()),
                ],
              ),

              const SizedBox(height: 44),

              SizedBox(
                height: 325,
                child: PageView(
                  physics: const BouncingScrollPhysics(),
                  controller: PageController(viewportFraction: 0.88),
                  children: [
                    ScaleTransition(scale: _scaleAnimation, child: _buildStepsCard(context)),
                    ScaleTransition(scale: _scaleAnimation, child: _buildHeartCard(context)),
                    ScaleTransition(scale: _scaleAnimation, child: _buildSleepCard(context)),
                    ScaleTransition(scale: _scaleAnimation, child: _buildStressCard(context)),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              _buildPrimaryGradientButton(
                context,
                label: "Yapay Zeka Raporu Al",
                icon: Icons.auto_awesome,
                onPressed: () => Navigator.pushNamed(context, '/ai_report'),
              ),

              const SizedBox(height: 16),

              _buildSecondaryOutlineButton(
                context,
                label: "Bluetooth Cihazı Tara",
                icon: Icons.bluetooth,
                onPressed: () => Navigator.pushNamed(context, '/bluetooth'),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _glassCard({required Widget child, double? height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.78),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 35,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: child,
        ),
      ),
    );
  }

  Widget _buildStepsCard(BuildContext context) {
    const int steps = 12456;
    const int goal = 15000;
    final progress = steps / goal;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/steps'),
      child: _glassCard(
        height: 310,
        child: Padding(
          padding: const EdgeInsets.all(26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.directions_walk_rounded, size: 42, color: Color(0xFF4CAF50)),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Adım Sayısı",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50)),
                  ),
                ],
              ),
              const Spacer(),
              Center(
                child: SizedBox(
                  width: 210,
                  height: 210,
                  child: Stack(
                    children: [
                      Center(
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 11,
                          backgroundColor: Colors.grey.withOpacity(0.15),
                          valueColor: const AlwaysStoppedAnimation(Color(0xFF4CAF50)),
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    steps.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.'),
                                    style: const TextStyle(fontSize: 31, fontWeight: FontWeight.w700, height: 1),
                                  ),
                                ),
                                Text("hedef $goal", style: const TextStyle(fontSize: 14, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeartCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/heart'),
      child: _glassCard(
        height: 310,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.monitor_heart_rounded, size: 42, color: Color(0xFFEF5350)),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Nabız",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50)),
                  ),
                ],
              ),
              const Spacer(),
              const Text("78 bpm", style: TextStyle(fontSize: 42, fontWeight: FontWeight.w700, color: Color(0xFF2C3E50))),
              const Text("Normal aralıkta", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              SizedBox(
                height: 92,
                child: CustomPaint(
                  size: const Size(double.infinity, 92),
                  painter: HeartRateGraphPainter(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSleepCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/sleep'),
      child: _glassCard(
        height: 310,
        child: Padding(
          padding: const EdgeInsets.all(26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.nightlight_round, size: 42, color: Color(0xFF64B5F6)),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Uyku",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50)),
                  ),
                ],
              ),
              const Spacer(),
              const Text("7s 32dk", style: TextStyle(fontSize: 38, fontWeight: FontWeight.w700, color: Color(0xFF2C3E50))),
              const Text("Kaliteli • %81", style: TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStressCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/stress'),
      child: _glassCard(
        height: 310,
        child: Padding(
          padding: const EdgeInsets.all(26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.spa_rounded, size: 42, color: Color(0xFF26A69A)),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Stres Seviyesi",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50)),
                  ),
                ],
              ),
              const Spacer(),
              const Text("%28", style: TextStyle(fontSize: 42, fontWeight: FontWeight.w700, color: Color(0xFF2C3E50))),
              const Text("Düşük • Rahat", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryGradientButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 74,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          colors: [Color(0xFF1C3D32), Color(0xFF2E8B57)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1C3D32).withOpacity(0.4),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: Colors.white),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryOutlineButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 74),
        side: const BorderSide(color: Color(0xFF1C3D32), width: 2.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        foregroundColor: const Color(0xFF1C3D32),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 14),
          Text(label, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildMiniMotivationCard() {
    return _glassCard(
      height: 100,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bugün harikasın! 💪", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            Text("Küçük adımlar, büyük fark yaratır.", style: TextStyle(fontSize: 13, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterTrackerCard() {
    const double waterProgress = 0.65;
    return _glassCard(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            const Icon(Icons.water_drop_rounded, size: 38, color: Color(0xFF64B5F6)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Su Tüketimi", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: waterProgress,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF64B5F6)),
                    minHeight: 7,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text("${(waterProgress * 100).round()}%", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class HeartRateGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fillPath = Path()..moveTo(0, size.height * 0.65);

    for (int i = 0; i <= 48; i++) {
      final x = i * (size.width / 48);
      final y = size.height * 0.56 + 26 * math.sin(i * 0.38) + 11 * math.sin(i * 0.91);
      fillPath.lineTo(x, y);
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..color = const Color(0xFFEF5350).withOpacity(0.09)
        ..style = PaintingStyle.fill,
    );

    final linePath = Path()..moveTo(0, size.height * 0.65);
    for (int i = 0; i <= 48; i++) {
      final x = i * (size.width / 48);
      final y = size.height * 0.56 + 26 * math.sin(i * 0.38) + 11 * math.sin(i * 0.91);
      linePath.lineTo(x, y);
    }

    canvas.drawPath(
      linePath,
      Paint()
        ..color = const Color(0xFFEF5350)
        ..strokeWidth = 5.2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawPath(
      linePath,
      Paint()
        ..color = const Color(0xFFEF5350).withOpacity(0.22)
        ..strokeWidth = 9.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==================== DETAY EKRANLARI ====================
class StepsDetailScreen extends StatelessWidget {
  const StepsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Adım Detayları")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Hero(
            tag: 'steps_card',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("12.456", style: Theme.of(context).textTheme.displayLarge),
                const Text("adım", style: TextStyle(fontSize: 18, color: Colors.grey)),
                const SizedBox(height: 40),
                const CircularProgressIndicator(
                  value: 0.83,
                  strokeWidth: 14,
                  valueColor: AlwaysStoppedAnimation(Color(0xFF4CAF50)),
                ),
                const SizedBox(height: 24),
                Text("Hedef: 15.000 (%83)", style: Theme.of(context).textTheme.headlineSmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HeartDetailScreen extends StatelessWidget {
  const HeartDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nabız Detayları")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Hero(
            tag: 'heart_card',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("78 bpm", style: Theme.of(context).textTheme.displayLarge),
                const Text("ortalama nabız", style: TextStyle(fontSize: 18, color: Colors.grey)),
                const SizedBox(height: 32),
                SizedBox(
                  height: 220,
                  child: CustomPaint(
                    painter: HeartRateGraphPainter(),
                    size: const Size(double.infinity, 220),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SleepDetailScreen extends StatelessWidget {
  const SleepDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Uyku Detayları")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Hero(
            tag: 'sleep_card',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("7s 32dk", style: Theme.of(context).textTheme.displayLarge),
                const Text("kaliteli uyku • %81", style: TextStyle(fontSize: 20, color: Color(0xFF4CAF50))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StressDetailScreen extends StatelessWidget {
  const StressDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stres Detayları")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Hero(
            tag: 'stress_card',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("%28", style: Theme.of(context).textTheme.displayLarge),
                const Text("Düşük seviye", style: TextStyle(fontSize: 20, color: Color(0xFF26A69A))),
                const SizedBox(height: 32),
                const CircularProgressIndicator(
                  value: 0.28,
                  strokeWidth: 14,
                  valueColor: AlwaysStoppedAnimation(Color(0xFF26A69A)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AIReportScreen extends StatelessWidget {
  const AIReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yapay Zeka Raporu")),
      body: const Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bugün harikasın!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
            SizedBox(height: 12),
            Text(
              "• Adımlar hedefin %83'üne ulaştı\n"
              "• Nabız tamamen normal aralıkta\n"
              "• Uyku kalitesi yüksek\n"
              "• Stres seviyesi çok düşük",
              style: TextStyle(fontSize: 17, height: 1.6),
            ),
            SizedBox(height: 32),
            Text(
              "Öneri: Akşam 20 dakikalık hafif yürüyüş yap, daha derin uyku için ekranı erken kapat.",
              style: TextStyle(fontSize: 17, color: Color(0xFF1C3D32), fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class BluetoothScanScreen extends StatefulWidget {
  const BluetoothScanScreen({super.key});

  @override
  State<BluetoothScanScreen> createState() => _BluetoothScanScreenState();
}

class _BluetoothScanScreenState extends State<BluetoothScanScreen> {
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  StreamSubscription<List<ScanResult>>? _scanSubscription;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    super.dispose();
  }

  void _showMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
    }
  }

  Future<void> _startScan() async {
    if (_isScanning) return;

    setState(() {
      _isScanning = true;
      _scanResults.clear();
    });

    try {
      var bluetoothScanStatus = await Permission.bluetoothScan.request();
      var bluetoothConnectStatus = await Permission.bluetoothConnect.request();
      var locationStatus = await Permission.locationWhenInUse.request();

      if (bluetoothScanStatus.isDenied || bluetoothConnectStatus.isDenied || locationStatus.isDenied) {
        _showMessage("Gerekli izinler reddedildi. Ayarlara gidip izin verin.");
        setState(() => _isScanning = false);
        return;
      }

      if (locationStatus.isPermanentlyDenied) {
        await openAppSettings();
        setState(() => _isScanning = false);
        return;
      }

      if (!await FlutterBluePlus.isSupported) {
        _showMessage("Bluetooth bu cihazda desteklenmiyor.");
        return;
      }

      final adapterState = await FlutterBluePlus.adapterState.first;
      if (adapterState == BluetoothAdapterState.off) {
        await FlutterBluePlus.turnOn();
        await Future.delayed(const Duration(milliseconds: 1400));
      }

      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 12),
        androidScanMode: AndroidScanMode.balanced,
        androidUsesFineLocation: false,
      );

      _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
        final Map<String, ScanResult> unique = {};
        for (final r in results) {
          final key = r.device.remoteId.toString();
          if (!unique.containsKey(key) || r.rssi > unique[key]!.rssi) {
            unique[key] = r;
          }
        }
        if (mounted) {
          setState(() {
            _scanResults = unique.values.toList()..sort((a, b) => b.rssi.compareTo(a.rssi));
          });
        }
      });

      await Future.delayed(const Duration(seconds: 12));
      await FlutterBluePlus.stopScan();
    } catch (e) {
      _showMessage("Tarama hatası: $e");
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    final name = device.platformName.isNotEmpty ? device.platformName : "Bilinmeyen cihaz";
    _showMessage("$name ile bağlanılıyor...");

    try {
      await device.connect(timeout: const Duration(seconds: 28), autoConnect: false);
      final services = await device.discoverServices();
      if (mounted) _showMessage("$name bağlandı! (${services.length} servis)");
    } catch (e) {
      if (mounted) _showMessage("Bağlantı başarısız: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bluetooth Cihazları")),
      body: Column(
        children: [
          if (_isScanning) const LinearProgressIndicator(minHeight: 3),
          Expanded(
            child: _scanResults.isEmpty && !_isScanning
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bluetooth_searching, size: 72, color: Colors.grey),
                        SizedBox(height: 20),
                        Text("Cihaz bulunamadı", style: TextStyle(fontSize: 18)),
                        Text("Yenilemek için butona bas", style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _scanResults.length,
                    itemBuilder: (context, i) {
                      final result = _scanResults[i];
                      final device = result.device;
                      final name = device.platformName.isNotEmpty ? device.platformName : "Bilinmeyen cihaz";

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                        child: ListTile(
                          leading: const Icon(Icons.bluetooth, color: Color(0xFF1C3D32), size: 32),
                          title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(
                            "${device.remoteId}\nRSSI: ${result.rssi} dBm",
                            style: const TextStyle(fontSize: 13),
                          ),
                          trailing: TextButton(
                            onPressed: () => _connectToDevice(device),
                            child: const Text("Bağlan", style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isScanning ? null : _startScan,
        child: Icon(_isScanning ? Icons.stop : Icons.refresh),
      ),
    );
  }
}