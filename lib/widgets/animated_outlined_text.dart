import 'package:flutter/material.dart';

int _globalAnimationCounter = 0;

Widget buildOutlinedText(
  String text, {
  double fontSize = 60,
  double strokeWidthRatio = 0.25,
  Color strokeColor = Colors.black,
  Color fillColor = Colors.white,
}) {
  final strokeWidth = fontSize * strokeWidthRatio;

  return Stack(
    children: [
      Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          height: 1.3,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..color = strokeColor
            ..strokeJoin = StrokeJoin.round,
        ),
      ),
      Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          height: 1.3,
          color: fillColor,
        ),
      ),
    ],
  );
}

Widget buildAnimatedOutlinedText(
  String text, {
  double fontSize = 60,
  double strokeWidthRatio = 0.25,
  Color strokeColor = Colors.black,
  Color fillColor = Colors.white,
  bool enableAnimation = false,
  bool enhancedGlow = false,
  Color glowColor = Colors.yellow,
  bool forceAnimation = false,
  int? displayTimeSeconds,
}) {
  if (!enableAnimation) {
    return buildOutlinedText(
      text,
      fontSize: fontSize,
      strokeWidthRatio: strokeWidthRatio,
      strokeColor: strokeColor,
      fillColor: fillColor,
    );
  }

  final uniqueKey = forceAnimation
      ? ValueKey(
          '${text}_${++_globalAnimationCounter}_${DateTime.now().millisecondsSinceEpoch}',
        )
      : ValueKey(text);

  return FadeAnimatedText(
    text: text,
    fontSize: fontSize,
    strokeWidthRatio: strokeWidthRatio,
    strokeColor: strokeColor,
    fillColor: fillColor,
    enhancedGlow: enhancedGlow,
    glowColor: glowColor,
    displayTimeSeconds: displayTimeSeconds, // ส่งเวลาต่อ
    key: uniqueKey,
  );
}

class FadeAnimatedText extends StatefulWidget {
  final String text;
  final double fontSize;
  final double strokeWidthRatio;
  final Color strokeColor;
  final Color fillColor;
  final bool enhancedGlow;
  final Color glowColor;
  final int? displayTimeSeconds;

  const FadeAnimatedText({
    super.key,
    required this.text,
    this.fontSize = 60,
    this.strokeWidthRatio = 0.25,
    this.strokeColor = Colors.black,
    this.fillColor = Colors.white,
    this.enhancedGlow = false,
    this.glowColor = Colors.yellow,
    this.displayTimeSeconds, // รับค่าเวลา
  });

  @override
  State<FadeAnimatedText> createState() => _FadeAnimatedTextState();
}

class _FadeAnimatedTextState extends State<FadeAnimatedText>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOutSine),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playFadeAnimation();
    });
  }

  void _playFadeAnimation() async {
    try {
      // Fade In ช้า ๆ (1.2 วินาที)
      await _fadeController.forward();

      // หยุดแสดงตามเวลาที่ตั้งค่า (ถ้าไม่มีให้ใช้ 2 วินาที)
      final displayTime = widget.displayTimeSeconds ?? 2;
      await Future.delayed(Duration(seconds: displayTime));

      // Fade Out ช้า ๆ (1.2 วินาที)
      if (mounted) {
        await _fadeController.reverse();
      }
    } catch (e) {
      debugPrint('Fade animation error: $e');
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _fadeAnimation, child: _buildTextContent());
  }

  Widget _buildTextContent() {
    final strokeWidth = widget.fontSize * widget.strokeWidthRatio;

    return Stack(
      children: [
        if (widget.enhancedGlow) ..._buildStrokeGlowLayers(strokeWidth),

        Text(
          widget.text,
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.bold,
            height: 1.3,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = widget.strokeColor
              ..strokeJoin = StrokeJoin.round,
          ),
        ),

        Text(
          widget.text,
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.bold,
            height: 1.3,
            color: widget.fillColor,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildStrokeGlowLayers(double strokeWidth) {
    final glowColor = widget.glowColor;

    return [
      Text(
        widget.text,
        style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.bold,
          height: 1.3,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth + 60
            ..color = glowColor.withAlpha((255.0 * 0.08).round())
            ..strokeJoin = StrokeJoin.round
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60),
        ),
      ),

      Text(
        widget.text,
        style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.bold,
          height: 1.3,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth + 45
            ..color = glowColor.withAlpha((255.0 * 0.12).round())
            ..strokeJoin = StrokeJoin.round
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50),
        ),
      ),

      Text(
        widget.text,
        style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.bold,
          height: 1.3,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth + 30
            ..color = glowColor.withAlpha((255.0 * 0.16).round())
            ..strokeJoin = StrokeJoin.round
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40),
        ),
      ),

      Text(
        widget.text,
        style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.bold,
          height: 1.3,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth + 20
            ..color = glowColor.withAlpha((255.0 * 0.22).round())
            ..strokeJoin = StrokeJoin.round
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
        ),
      ),

      Text(
        widget.text,
        style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.bold,
          height: 1.3,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth + 10
            ..color = glowColor.withAlpha((255.0 * 0.28).round())
            ..strokeJoin = StrokeJoin.round
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
        ),
      ),

      Text(
        widget.text,
        style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.bold,
          height: 1.3,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth + 5
            ..color = glowColor.withAlpha((255.0 * 0.35).round())
            ..strokeJoin = StrokeJoin.round
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
        ),
      ),
    ];
  }
}

// Fade Effect พร้อม Neon Glow
Widget flashCardTextWithGlow(
  String text, {
  double fontSize = 160,
  Color strokeColor = Colors.black,
  Color fillColor = Colors.white,
  Color glowColor = Colors.yellow,
  int? displayTimeSeconds,
}) {
  return buildAnimatedOutlinedText(
    text,
    fontSize: fontSize,
    strokeColor: strokeColor,
    fillColor: fillColor,
    enableAnimation: true,
    enhancedGlow: true,
    glowColor: glowColor,
    forceAnimation: true,
    displayTimeSeconds: displayTimeSeconds,
  );
}

Widget flashCardText(
  String text, {
  double fontSize = 160,
  Color strokeColor = Colors.black,
  Color fillColor = Colors.white,
  int? displayTimeSeconds,
}) {
  return buildAnimatedOutlinedText(
    text,
    fontSize: fontSize,
    strokeColor: strokeColor,
    fillColor: fillColor,
    enableAnimation: true,
    enhancedGlow: false,
    forceAnimation: true,
    displayTimeSeconds: displayTimeSeconds,
  );
}

// Show All mode
Widget normalbuildOutlinedText(
  String text, {
  double fontSize = 60,
  Color strokeColor = Colors.black,
  Color fillColor = Colors.white,
}) {
  return buildOutlinedText(
    text,
    fontSize: fontSize,
    strokeColor: strokeColor,
    fillColor: fillColor,
  );
}
