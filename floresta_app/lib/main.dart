import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floresta App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4FAF7),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(color: Colors.white),
        ),
      ),
      home: const HomeScreen(),
      routes: {
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.98, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
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
                  style: GoogleFonts.quicksand(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2C3E50),
                    height: 1.05,
                  ),
                ),
              ),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  "bugün nasılsın?",
                  style: GoogleFonts.quicksand(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2C3E50),
                    height: 1.05,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  "Günlük sağlık yolculuğun burada başlıyor 🌿",
                  style: GoogleFonts.quicksand(
                    fontSize: 15,
                    color: Colors.grey[600],
                  ),
                ),
              ),

              const SizedBox(height: 48),

              SizedBox(
                height: 300,
                child: PageView(
                  controller: PageController(viewportFraction: 0.9),
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/steps'),
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: _buildStepsCard(),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/heart'),
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: _buildHeartCard(),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/sleep'),
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: _buildSleepCard(),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/stress'),
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: _buildStressCard(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 52),

              ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    width: double.infinity,
                    height: 72,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1C3D32).withValues(alpha: 0.35),
                          blurRadius: 25,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/ai_report');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C3D32),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.auto_awesome, size: 28),
                          const SizedBox(width: 14),
                          Text(
                            "Yapay Zeka Raporu Al",
                            style: GoogleFonts.quicksand(
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    width: double.infinity,
                    height: 72,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1C3D32).withValues(alpha: 0.35),
                          blurRadius: 25,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/bluetooth');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C3D32),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.bluetooth, size: 28),
                          const SizedBox(width: 14),
                          Text(
                            "Bluetooth Cihazı Ara",
                            style: GoogleFonts.quicksand(
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepsCard() {
    const int steps = 12456;
    const int goal = 15000;

    return Hero(
      tag: 'steps_card',
      flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
        return Material(
          color: Colors.transparent,
          child: fromHeroContext.widget,
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.directions_walk_rounded,
                size: 52,
                color: Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Adım Sayısı",
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    steps.toString().replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]}.'),
                    style: GoogleFonts.quicksand(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2C3E50),
                      height: 1,
                    ),
                  ),
                  Text(
                    "hedef $goal",
                    style: GoogleFonts.quicksand(
                      fontSize: 15,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeartCard() {
    return Hero(
      tag: 'heart_card',
      flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
        return Material(
          color: Colors.transparent,
          child: fromHeroContext.widget,
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.monitor_heart_rounded,
                    size: 46,
                    color: Color(0xFFEF5350),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nabız",
                      style: GoogleFonts.quicksand(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      "78 bpm",
                      style: GoogleFonts.quicksand(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2C3E50),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: CustomPaint(
                size: const Size(double.infinity, 120),
                painter: HeartRateGraphPainter(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "08:00",
                  style: GoogleFonts.quicksand(
                      fontSize: 13, color: Colors.grey[500]),
                ),
                Text(
                  "Şimdi",
                  style: GoogleFonts.quicksand(
                      fontSize: 13, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepCard() {
    return Hero(
      tag: 'sleep_card',
      flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
        return Material(
          color: Colors.transparent,
          child: fromHeroContext.widget,
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.nightlight_round,
                size: 52,
                color: Color(0xFF64B5F6),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Uyku",
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "7s 32dk",
                    style: GoogleFonts.quicksand(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 18, color: Color(0xFFFFD700)),
                      const SizedBox(width: 6),
                      Text(
                        "Kaliteli uyku • %81",
                        style: GoogleFonts.quicksand(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStressCard() {
    const int stress = 28;

    return Hero(
      tag: 'stress_card',
      flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
        return Material(
          color: Colors.transparent,
          child: fromHeroContext.widget,
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2F1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.spa_rounded,
                size: 52,
                color: Color(0xFF26A69A),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Stres Seviyesi",
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$stress%",
                    style: GoogleFonts.quicksand(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2C3E50),
                      height: 1,
                    ),
                  ),
                  Text(
                    "Düşük • Rahat",
                    style: GoogleFonts.quicksand(
                      fontSize: 15,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeartRateGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fillPath = Path();
    fillPath.moveTo(0, size.height * 0.62);

    for (int i = 0; i <= 42; i++) {
      final x = i * (size.width / 42);
      final y = size.height * 0.55 +
          28 * math.sin(i * 0.42) +
          12 * math.sin(i * 0.85);
      fillPath.lineTo(x, y);
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..color = const Color(0xFFEF5350).withValues(alpha: 0.09)
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = const Color(0xFFEF5350)
      ..strokeWidth = 5.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final linePath = Path();
    linePath.moveTo(0, size.height * 0.62);

    for (int i = 0; i <= 42; i++) {
      final x = i * (size.width / 42);
      final y = size.height * 0.55 +
          28 * math.sin(i * 0.42) +
          12 * math.sin(i * 0.85);
      linePath.lineTo(x, y);
    }

    canvas.drawPath(linePath, linePaint);

    final glowPaint = Paint()
      ..color = const Color(0xFFEF5350).withValues(alpha: 0.25)
      ..strokeWidth = 9
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(linePath, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StepsDetailScreen extends StatelessWidget {
  const StepsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const int steps = 12456;
    const int goal = 15000;
    const double progress = steps / goal;

    return Scaffold(
      appBar: AppBar(
        title: Text("Adım Sayısı Detayları", style: GoogleFonts.quicksand()),
        backgroundColor: const Color(0xFF1C3D32),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Hero(
            tag: 'steps_card',
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Bugünkü Adımlar: $steps",
                  style: GoogleFonts.quicksand(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 12,
                  valueColor: AlwaysStoppedAnimation(Color(0xFF4CAF50)),
                ),
                const SizedBox(height: 16),
                Text(
                  "Hedef: $goal (%${(progress * 100).round()})",
                  style: GoogleFonts.quicksand(fontSize: 24),
                ),
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
      appBar: AppBar(
        title: Text("Nabız Detayları", style: GoogleFonts.quicksand()),
        backgroundColor: const Color(0xFF1C3D32),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Hero(
            tag: 'heart_card',
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Ortalama Nabız: 78 bpm",
                  style: GoogleFonts.quicksand(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 200,
                  child: CustomPaint(
                    painter: HeartRateGraphPainter(),
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
      appBar: AppBar(
        title: Text("Uyku Detayları", style: GoogleFonts.quicksand()),
        backgroundColor: const Color(0xFF1C3D32),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Hero(
            tag: 'sleep_card',
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Uyku Süresi: 7s 32dk",
                  style: GoogleFonts.quicksand(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  "Kalite: %81 (Kaliteli)",
                  style: GoogleFonts.quicksand(fontSize: 24),
                ),
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
    const int stress = 28;
    const double progress = stress / 100.0;

    return Scaffold(
      appBar: AppBar(
        title: Text("Stres Detayları", style: GoogleFonts.quicksand()),
        backgroundColor: const Color(0xFF1C3D32),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Hero(
            tag: 'stress_card',
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Stres Seviyesi: $stress%",
                  style: GoogleFonts.quicksand(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 12,
                  valueColor: AlwaysStoppedAnimation(Color(0xFF26A69A)),
                ),
                const SizedBox(height: 16),
                Text(
                  "Durum: Düşük • Rahat",
                  style: GoogleFonts.quicksand(fontSize: 24),
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
      appBar: AppBar(
        title: Text("Yapay Zeka Sağlık Raporu", style: GoogleFonts.quicksand()),
        backgroundColor: const Color(0xFF1C3D32),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Genel Özet:",
              style: GoogleFonts.quicksand(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              "Adımlar: 12.456 / 15.000 (%83)\n"
              "Nabız: 78 bpm (Normal)\n"
              "Uyku: 7s 32dk (%81 kaliteli)\n"
              "Stres: %28 (Düşük)",
              style: GoogleFonts.quicksand(fontSize: 18),
            ),
            const SizedBox(height: 24),
            Text(
              "Öneriler: Daha fazla adım atın, stres düşük seviyede tutun. 🌿",
              style: GoogleFonts.quicksand(fontSize: 18, color: Colors.green[700]),
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

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() async {
    setState(() {
      _isScanning = true;
      _scanResults.clear();
    });

    bool isSupported = await FlutterBluePlus.isSupported;
    if (!isSupported) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bluetooth desteklenmiyor.")),
      );
      setState(() {
        _isScanning = false;
      });
      return;
    }

    // Adapter state'i dinle ve on olana kadar bekle
    await for (var state in FlutterBluePlus.adapterState) {
      if (state == BluetoothAdapterState.on) {
        break;
      } else if (state == BluetoothAdapterState.off) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Bluetooth'u açın.")),
          );
        }
        setState(() {
          _isScanning = false;
        });
        return;
      }
    }

    // Tarama başlat
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

    // Scan sonuçlarını dinle
    final subscription = FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        _scanResults = results;
      });
    });

    // Tarama bitince durdur
    await Future.delayed(const Duration(seconds: 10));
    await FlutterBluePlus.stopScan();
    subscription.cancel();
    setState(() {
      _isScanning = false;
    });
  }

  void _connectToDevice(BluetoothDevice device) async {
    // Bağlantı durumunu dinle
    final connSubscription = device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.connected) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${device.platformName} bağlandı! Veri çekiliyor...")),
          );
        }
      } else if (state == BluetoothConnectionState.disconnected) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${device.platformName} bağlantısı kesildi.")),
          );
        }
      }
    });

    try {
      await device.connect(
        timeout: const Duration(seconds: 35),
        autoConnect: false,
      );

      List<BluetoothService> services = await device.discoverServices();

      for (var service in services) {
        print("Bulunan servis: ${service.uuid.toString()}");
        for (var characteristic in service.characteristics) {
          print("  → Characteristic: ${characteristic.uuid.toString()}");
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Bağlantı başarılı – servisler keşfedildi")),
        );
      }
    } catch (e) {
      print("Bağlantı hatası: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bağlantı başarısız: $e")),
        );
      }
    } finally {
      connSubscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bluetooth Cihazları Ara", style: GoogleFonts.quicksand()),
        backgroundColor: const Color(0xFF1C3D32),
      ),
      body: Column(
        children: [
          if (_isScanning)
            const Center(child: CircularProgressIndicator()),
          Expanded(
            child: ListView.builder(
              itemCount: _scanResults.length,
              itemBuilder: (context, index) {
                ScanResult result = _scanResults[index];
                BluetoothDevice device = result.device;
                return ListTile(
                  title: Text(device.platformName.isEmpty ? "Bilinmeyen Cihaz" : device.platformName),
                  subtitle: Text(device.remoteId.toString()),
                  trailing: ElevatedButton(
                    onPressed: () => _connectToDevice(device),
                    child: const Text("Bağlan"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isScanning ? null : _startScan,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}