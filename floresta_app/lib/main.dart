import 'dart:async';
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
      title: 'Floresta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1C3D32),
          surface: const Color(0xFFF4FAF7),
          primary: const Color(0xFF1C3D32),
          secondary: const Color(0xFF4CAF50),
          tertiary: const Color(0xFF26A69A),
        ),
        textTheme: GoogleFonts.quicksandTextTheme(
          ThemeData.light().textTheme,
        ).copyWith(
          headlineLarge: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            height: 1.05,
          ),
          titleLarge: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4FAF7),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xFF1C3D32),
          foregroundColor: Colors.white,
          centerTitle: true,
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

// Ortak Hero geçiş animasyonu (Android'de daha stabil)
Widget _heroFlightShuttleBuilder(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  return Material(
    color: Colors.transparent,
    child: fromHeroContext.widget,
  );
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
      duration: const Duration(milliseconds: 950),
      vsync: this,
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
    );

    _scaleAnimation = Tween<double>(begin: 0.96, end: 1.0).animate(
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
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  "bugün nasılsın? 🌿",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const SizedBox(height: 8),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  "Sağlık yolculuğun burada başlıyor",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ),

              const SizedBox(height: 48),

              SizedBox(
                height: 310,
                child: PageView(
                  physics: const BouncingScrollPhysics(),
                  controller: PageController(viewportFraction: 0.88, initialPage: 0),
                  children: [
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildStepsCard(context),
                      ),
                    ),
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildHeartCard(context),
                      ),
                    ),
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildSleepCard(context),
                      ),
                    ),
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildStressCard(context),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 52),

              // AI Raporu Butonu
              _buildActionButton(
                context,
                icon: Icons.auto_awesome,
                label: "Yapay Zeka Raporu Al",
                onPressed: () => Navigator.pushNamed(context, '/ai_report'),
              ),

              const SizedBox(height: 16),

              // Bluetooth Butonu
              _buildActionButton(
                context,
                icon: Icons.bluetooth,
                label: "Bluetooth Cihazı Tara",
                onPressed: () => Navigator.pushNamed(context, '/bluetooth'),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1C3D32).withOpacity(0.28),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1C3D32),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 14),
            Text(
              label,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Ortak metrik kartı (kod tekrarı sıfırlandı)
  Widget _buildMetricCard({
    required BuildContext context,
    required String tag,
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
    Widget? extraChild,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: tag,
        flightShuttleBuilder: _heroFlightShuttleBuilder,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.88),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.055),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: extraChild ??
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Icon(
                      icon,
                      size: 54,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          value,
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: const Color(0xFF2C3E50),
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }

  Widget _buildStepsCard(BuildContext context) => _buildMetricCard(
        context: context,
        tag: 'steps_card',
        title: "Adım Sayısı",
        value: "12.456",
        subtitle: "hedef 15.000",
        icon: Icons.directions_walk_rounded,
        iconColor: const Color(0xFF4CAF50),
        bgColor: const Color(0xFFE8F5E9),
        onTap: () => Navigator.pushNamed(context, '/steps'),
      );

  Widget _buildHeartCard(BuildContext context) => _buildMetricCard(
        context: context,
        tag: 'heart_card',
        title: "Nabız",
        value: "78 bpm",
        subtitle: "Normal aralıkta",
        icon: Icons.monitor_heart_rounded,
        iconColor: const Color(0xFFEF5350),
        bgColor: const Color(0xFFFFEBEE),
        onTap: () => Navigator.pushNamed(context, '/heart'),
        extraChild: Column(
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
                    size: 48,
                    color: Color(0xFFEF5350),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nabız",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      "78 bpm",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: const Color(0xFF2C3E50),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 118,
              child: CustomPaint(
                size: const Size(double.infinity, 118),
                painter: HeartRateGraphPainter(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("08:00", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[500])),
                Text("Şimdi", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[500])),
              ],
            ),
          ],
        ),
      );

  Widget _buildSleepCard(BuildContext context) => _buildMetricCard(
        context: context,
        tag: 'sleep_card',
        title: "Uyku",
        value: "7s 32dk",
        subtitle: "Kaliteli • %81",
        icon: Icons.nightlight_round,
        iconColor: const Color(0xFF64B5F6),
        bgColor: const Color(0xFFE3F2FD),
        onTap: () => Navigator.pushNamed(context, '/sleep'),
      );

  Widget _buildStressCard(BuildContext context) => _buildMetricCard(
        context: context,
        tag: 'stress_card',
        title: "Stres Seviyesi",
        value: "%28",
        subtitle: "Düşük • Rahat",
        icon: Icons.spa_rounded,
        iconColor: const Color(0xFF26A69A),
        bgColor: const Color(0xFFE0F2F1),
        onTap: () => Navigator.pushNamed(context, '/stress'),
      );
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

// Detay ekranları (Hero + temiz tema kullanımı)
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

// Android'de en stabil Bluetooth tarama (tüm iyileştirmeler burada)
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
      if (!await FlutterBluePlus.isSupported) {
        _showMessage("Bluetooth bu cihazda desteklenmiyor.");
        return;
      }

      // Android için en stabil akış
      final adapterState = await FlutterBluePlus.adapterState.first;
      if (adapterState == BluetoothAdapterState.off) {
        await FlutterBluePlus.turnOn();
        await Future.delayed(const Duration(milliseconds: 1400));
      }

      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 12),
        androidScanMode: AndroidScanMode.balanced,
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
            _scanResults = unique.values.toList()
              ..sort((a, b) => b.rssi.compareTo(a.rssi));
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

      if (mounted) {
        _showMessage("$name bağlandı! (${services.length} servis keşfedildi)");
      }
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