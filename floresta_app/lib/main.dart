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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
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
    );

    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1C3D32),
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.quicksandTextTheme(
        ThemeData.dark().textTheme,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFF1C3D32),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
    );

    return MaterialApp(
      title: 'Floresta',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
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

  // arrow bounce
  late AnimationController _arrowController;
  late Animation<Offset> _arrowOffset;

  String greeting = "";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _arrowController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    _arrowOffset = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.15))
        .animate(CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut));

    _setGreeting();
  }

  void _setGreeting() {
    final hour = DateTime.now().hour;
    greeting = switch (hour) {
      >= 5 && < 12 => "Günaydın 🌿",
      >= 12 && < 15 => "Tünaydın ☀️",
      >= 15 && < 18 => "İyi günler 🌞",
      >= 18 && < 22 => "İyi akşamlar 🌅",
      _ => "İyi geceler 🌙",
    };
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
    final screenHeight = MediaQuery.of(context).size.height;
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
                      style: TextStyle(
                        fontSize: screenHeight * 0.06,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.1,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      "Floresta'ya hoş geldin",
                      style: TextStyle(
                        fontSize: screenHeight * 0.025,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                      maxLines: 1,
                    ),
                    SizedBox(height: screenHeight * 0.15),
                    Column(
                      children: [
                        SlideTransition(
                      position: _arrowOffset,
                      child: const Icon(Icons.keyboard_arrow_up_rounded, size: 48, color: Colors.white),
                    ),
                    SlideTransition(
                      position: _arrowOffset,
                      child: Text(
                        "Yukarı kaydır",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.8),
                          letterSpacing: 1.5,
                        ),
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
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..forward();

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardHeight = screenSize.height * 0.38; // Responsive yükseklik
    final miniCardHeight = screenSize.height * 0.12;
    final buttonHeight = screenSize.height * 0.09;
    final pageViewHeight = cardHeight + 15;

    final onSurface = Theme.of(context).colorScheme.onSurface;
    final onSurface70 = onSurface.withOpacity(0.7);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.06, vertical: screenSize.height * 0.04),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Merhaba,",
                        style: TextStyle(
                          fontSize: screenSize.width * 0.07,
                          fontWeight: FontWeight.w700,
                          color: onSurface,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        MyApp.of(context)?.toggleTheme();
                      },
                      icon: Icon(
                        Theme.of(context).brightness == Brightness.dark
                            ? Icons.wb_sunny
                            : Icons.nights_stay,
                        color: onSurface,
                      ),
                      tooltip: "Karanlık/aydınlık modu",
                    ),
                  ],
                ),
                Text(
                  "bugün nasılsın? 🌿",
                  style: TextStyle(
                    fontSize: screenSize.width * 0.07,
                    fontWeight: FontWeight.w700,
                    color: onSurface,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: screenSize.height * 0.015),
                Text(
                  "Sağlık yolculuğun burada başlıyor",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: onSurface70),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: screenSize.height * 0.04),

                Row(
                  children: [
                    Expanded(child: _buildMiniMotivationCard(miniCardHeight, context)),
                    SizedBox(width: screenSize.width * 0.03),
                    Expanded(child: _buildWaterTrackerCard(miniCardHeight, context)),
                  ],
                ),

                SizedBox(height: screenSize.height * 0.055),

                SizedBox(
                  height: pageViewHeight,
                  child: PageView(
                    physics: const ClampingScrollPhysics(), // Optimized from BouncingScrollPhysics
                    controller: PageController(viewportFraction: 0.88),
                    children: [
                      RepaintBoundary(child: ScaleTransition(scale: _scaleAnimation, child: _buildStepsCard(context, cardHeight))),
                      RepaintBoundary(child: ScaleTransition(scale: _scaleAnimation, child: _buildHeartCard(context, cardHeight))),
                      RepaintBoundary(child: ScaleTransition(scale: _scaleAnimation, child: _buildSleepCard(context, cardHeight))),
                      RepaintBoundary(child: ScaleTransition(scale: _scaleAnimation, child: _buildStressCard(context, cardHeight))),
                    ],
                  ),
                ),

                SizedBox(height: screenSize.height * 0.06),

                // bluetooth is now the primary action on the home screen
                _buildSecondaryOutlineButton(
                  context,
                  label: "Bluetooth Cihazı Tara",
                  icon: Icons.bluetooth,
                  onPressed: () => Navigator.pushNamed(context, '/bluetooth'),
                  height: buttonHeight,
                ),

                SizedBox(height: screenSize.height * 0.02),

                _buildPrimaryGradientButton(
                  context,
                  label: "Yapay Zeka Raporu Al",
                  icon: Icons.auto_awesome,
                  onPressed: () => Navigator.pushNamed(context, '/ai_report'),
                  height: buttonHeight,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA726)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),

                SizedBox(height: screenSize.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _glassCard({
    required Widget child,
    required double height,
    required BuildContext context,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF2A2A2A).withValues(alpha: 0.6)
        : Colors.white.withValues(alpha: 0.35);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 45,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      child: RepaintBoundary(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6), // Blur optimized
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildStepsCard(BuildContext context, double height) {
    const int steps = 12456;
    const int goal = 15000;
    const progress = steps / goal;

    // mimic other cards: large text + subtitle with chart underneath
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/steps'),
      child: _glassCard(
        height: height,
        context: context,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = MediaQuery.of(context).size.width;
              final maxRingSize = math.min(constraints.maxHeight * 0.45, 180.0);
              final ringSize = math.min(maxRingSize, screenWidth * 0.45);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(Icons.directions_walk_rounded, size: 38, color: Color(0xFF4CAF50)),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          "Adım Sayısı",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    steps.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.'),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "hedef $goal (%${(progress * 100).round()})",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: SizedBox(
                      width: ringSize,
                      height: ringSize,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: math.max(5.5, ringSize * 0.05),
                        backgroundColor: Colors.grey.withValues(alpha: 0.15),
                        valueColor: const AlwaysStoppedAnimation(Color(0xFF4CAF50)),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeartCard(BuildContext context, double height) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/heart'),
      child: _glassCard(
        height: height,
        context: context,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.monitor_heart_rounded, size: 38, color: Color(0xFFEF5350)),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      "Nabız",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface, height: 1.2),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text("78 bpm", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface)),

              Text("Normal aralıkta", style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), height: 1.2)),


              const SizedBox(height: 14),
              SizedBox(
                height: 80,
                child: RepaintBoundary(
                  child: CustomPaint(
                    size: const Size(double.infinity, 80),
                    painter: HeartRateGraphPainter(
                      tickColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.35),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSleepCard(BuildContext context, double height) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/sleep'),
      child: _glassCard(
        height: height,
        context: context,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.nightlight_round, size: 38, color: Color(0xFF64B5F6)),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      "Uyku",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface, height: 1.2),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text("7s 32dk", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface)),

              const Text("Kaliteli • %81", style: TextStyle(fontSize: 14, color: Color(0xFF4CAF50), fontWeight: FontWeight.w600, height: 1.2)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStressCard(BuildContext context, double height) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/stress'),
      child: _glassCard(
        height: height,
        context: context,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F1),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.spa_rounded, size: 38, color: Color(0xFF26A69A)),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      "Stres",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface, height: 1.2),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text("%28", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface)),

              Text("Düşük • Rahat", style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), height: 1.2)),

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
    required double height,
    Gradient? gradient,
  }) {
    final defaultGradient = const LinearGradient(
      colors: [Color(0xFF1C3D32), Color(0xFF2E8B57)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: gradient ?? defaultGradient,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1C3D32).withValues(alpha: 0.3),
            blurRadius: 45,
            offset: const Offset(0, 24),
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
            Flexible(
              child: Text(
                label,
                style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
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
    required double height,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(double.infinity, height),
        side: const BorderSide(color: Color(0xFF1C3D32), width: 2.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        foregroundColor: const Color(0xFF1C3D32),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 14),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMotivationCard(double height, BuildContext context) {
    return _glassCard(
      height: height,
      context: context,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 140;
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // break title and emoji so the icon never gets clipped
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Bugün harikasın!",
                            style: TextStyle(
                              fontSize: isNarrow ? 13 : 15,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "💪",
                          style: TextStyle(fontSize: isNarrow ? 13 : 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Küçük adımlar,\nbüyük fark yaratır.",
                      style: TextStyle(
                        fontSize: isNarrow ? 11 : 13,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // little leaf in the top-right corner for visual balance
              Positioned(
                top: 8,
                right: 8,
                child: Text(
                  '🌿',
                  style: TextStyle(fontSize: isNarrow ? 14 : 16),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWaterTrackerCard(double height, BuildContext context) {
    const double waterProgress = 0.65;
    return _glassCard(
      height: height,
      context: context,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 180;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: isNarrow
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.water_drop_rounded, size: 32, color: Color(0xFF64B5F6)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Su Tüketimi",
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ShaderMask(
                        shaderCallback: (rect) {
                          return const LinearGradient(
                            colors: [Color(0xFF64B5F6), Color(0xFF81D4FA)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(rect);
                        },
                        child: LinearProgressIndicator(
                          value: waterProgress,
                          backgroundColor: Colors.grey.withValues(alpha: 0.2),
                          valueColor: const AlwaysStoppedAnimation(Colors.white),
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "${(waterProgress * 100).round()}%",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      const Icon(Icons.water_drop_rounded, size: 38, color: Color(0xFF64B5F6)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Su Tüketimi",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            // gradient-filled progress bar for a more dynamic look
                            ShaderMask(
                              shaderCallback: (rect) {
                                return const LinearGradient(
                                  colors: [Color(0xFF64B5F6), Color(0xFF81D4FA)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(rect);
                              },
                              child: LinearProgressIndicator(
                                value: waterProgress,
                                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                                valueColor: const AlwaysStoppedAnimation(Colors.white),
                                minHeight: 7,
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${(waterProgress * 100).round()}%",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class HeartRateGraphPainter extends CustomPainter {
  final Color tickColor;

  HeartRateGraphPainter({required this.tickColor});

  static const int _pointCount = 48;
  static const double _baseY = 0.56;
  static const double _amp1 = 26.0;
  static const double _freq1 = 0.38;
  static const double _amp2 = 11.0;
  static const double _freq2 = 0.91;
  
  static final List<Offset> _cachedPoints = [];
  static double _lastWidth = -1;
  
  void _generateCache(double width, double height) {
    if (_lastWidth == width && _cachedPoints.isNotEmpty) return;
    
    _cachedPoints.clear();
    _lastWidth = width;
    
    for (int i = 0; i <= _pointCount; i++) {
      final x = i * (width / _pointCount);
      final y = height * _baseY + _amp1 * math.sin(i * _freq1) + _amp2 * math.sin(i * _freq2);
      _cachedPoints.add(Offset(x, y));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    _generateCache(size.width, size.height);
    
    // Gradient background path
    final fillPath = Path()..moveTo(0, size.height * _baseY);
    for (final point in _cachedPoints) {
      fillPath.lineTo(point.dx, point.dy);
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..color = const Color(0xFFEF5350).withValues(alpha: 0.08)
        ..style = PaintingStyle.fill,
    );

    // Main line path
    final linePath = Path()..moveTo(0, size.height * _baseY);
    for (final point in _cachedPoints) {
      linePath.lineTo(point.dx, point.dy);
    }

    // draw very thin hour tick markers under baseline
    final tickPaint = Paint()
      ..color = tickColor
      ..strokeWidth = 1;
    final tickY = size.height * _baseY + 6;
    const tickCount = 24;
    for (int i = 0; i <= tickCount; i++) {
      final x = i * (size.width / tickCount);
      canvas.drawLine(Offset(x, tickY), Offset(x, tickY + 4), tickPaint);
    }

    // Glow effect
    canvas.drawPath(
      linePath,
      Paint()
        ..color = const Color(0xFFEF5350).withValues(alpha: 0.18)
        ..strokeWidth = 8.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Main line
    canvas.drawPath(
      linePath,
      Paint()
        ..color = const Color(0xFFEF5350)
        ..strokeWidth = 4.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // live-data glowing point at the end
    if (_cachedPoints.isNotEmpty) {
      final last = _cachedPoints.last;
      // outer glow
      canvas.drawCircle(
        last,
        8,
        Paint()
          ..color = const Color(0xFFFFEBEE).withOpacity(0.6)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
      // inner solid
      canvas.drawCircle(
        last,
        4,
        Paint()..color = const Color(0xFFEF5350),
      );
    }
  }

  @override
  bool shouldRepaint(HeartRateGraphPainter oldDelegate) => false;
}

// ==================== DETAY EKRANLARI ====================
class StepsDetailScreen extends StatelessWidget {
  const StepsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Adım Detayları")),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "12.456",
                  style: TextStyle(
                    fontSize: screenSize.width * 0.12,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text("adım", style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
                SizedBox(height: screenSize.height * 0.05),
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
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Nabız Detayları")),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "78 bpm",
                  style: TextStyle(
                    fontSize: screenSize.width * 0.12,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text("ortalama nabız", style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
                const SizedBox(height: 32),
                SizedBox(
                  height: screenSize.height * 0.25,
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: HeartRateGraphPainter(
                        tickColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.35),
                      ),
                      size: Size(double.infinity, screenSize.height * 0.25),
                    ),
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
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Uyku Detayları")),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "7s 32dk",
                  style: TextStyle(
                    fontSize: screenSize.width * 0.12,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
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
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Stres Detayları")),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "%28",
                  style: TextStyle(
                    fontSize: screenSize.width * 0.12,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
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
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Yapay Zeka Raporu")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenSize.width * 0.07),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bugün harikasın!",
              style: TextStyle(fontSize: screenSize.width * 0.07, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: screenSize.height * 0.02),
            Text(
              "• Adımlar hedefin %83'üne ulaştı\n"
              "• Nabız tamamen normal aralıkta\n"
              "• Uyku kalitesi yüksek\n"
              "• Stres seviyesi çok düşük",
              style: TextStyle(fontSize: 16, height: 1.8, color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: screenSize.height * 0.04),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Theme.of(context).colorScheme.secondary.withOpacity(0.3), width: 1.5),
              ),
              child: Text(
                "💡 Öneri: Akşam 20 dakikalık hafif yürüyüş yap, daha derin uyku için ekranı erken kapat.",
                style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w500, height: 1.6),
              ),
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
        timeout: const Duration(seconds: 10),
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

      await Future.delayed(const Duration(seconds: 10));
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
      await device.connect(timeout: const Duration(seconds: 15));
      final services = await device.discoverServices();
      if (mounted) _showMessage("$name bağlandı! (${services.length} servis)");
    } catch (e) {
      if (mounted) _showMessage("Bağlantı başarısız: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Bluetooth Cihazları")),
      body: Column(
        children: [
          if (_isScanning) const LinearProgressIndicator(minHeight: 3),
          Expanded(
            child: _scanResults.isEmpty && !_isScanning
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bluetooth_searching, size: 72, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),

                        SizedBox(height: 20),
                        Text("Cihaz bulunamadı", style: TextStyle(fontSize: 18)),
                        Text("Yenilemek için butona bas", style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(screenSize.width * 0.03),
                    itemCount: _scanResults.length,
                    itemBuilder: (context, i) {
                      final result = _scanResults[i];
                      final device = result.device;
                      final name = device.platformName.isNotEmpty ? device.platformName : "Bilinmeyen cihaz";

                      return Card(
                        margin: EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.008,
                          horizontal: screenSize.width * 0.02,
                        ),
                        elevation: 2,
                        child: ListTile(
                          leading: Icon(Icons.bluetooth, color: Theme.of(context).colorScheme.onSurface, size: 28),
                          title: Text(
                            name,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            "${device.remoteId}\nRSSI: ${result.rssi} dBm",
                            style: const TextStyle(fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: SizedBox(
                            width: 90,
                            child: TextButton(
                              onPressed: () => _connectToDevice(device),
                              style: TextButton.styleFrom(
                                foregroundColor: Theme.of(context).colorScheme.onSurface,
                              ),
                              child: const Text("Bağlan", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.04, vertical: 8),
                          dense: true,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isScanning ? null : _startScan,
        icon: Icon(_isScanning ? Icons.stop : Icons.refresh),
        label: Text(_isScanning ? "Tarama Durduruluyor" : "Yeniden Tara"),
      ),
    );
  }
}