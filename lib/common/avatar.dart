import 'dart:math';

import 'package:flutter/material.dart';

class Avatar extends StatefulWidget {
  final String? seed;
  final double size;
  final bool deterministic;
  final BorderRadius borderRadius;
  final IconData? icon;
  final Color iconColor;
  final double iconSize;

  const Avatar({
    super.key,
    this.seed,
    this.size = 64,
    this.deterministic = true,
    this.borderRadius = const BorderRadius.all(Radius.circular(9999)),
    this.icon,
    this.iconColor = Colors.white,
    this.iconSize = 24,
  });

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  late Random rnd;
  late List<double> angles;
  late List<Color> palette;

  final List<List<Color>> palettes = [
    // --- TEALS ---
    [
      const Color(0xFF063A38),
      const Color(0xFF0E5753),
      const Color(0xFF2F8A84),
      const Color(0xFFAEE7DF)
    ],
    [
      const Color(0xFF0B2E27),
      const Color(0xFF1C5C50),
      const Color(0xFF2F8775),
      const Color(0xFF9ED8CB)
    ],
    [
      const Color(0xFF083F41),
      const Color(0xFF0E6B6E),
      const Color(0xFF19989C),
      const Color(0xFFB0EAEA)
    ],
    [
      const Color(0xFF0E2A2A),
      const Color(0xFF1E4A49),
      const Color(0xFF2D726E),
      const Color(0xFFA0D7CE)
    ],

    // --- SEA BLUES ---
    [
      const Color(0xFF081F32),
      const Color(0xFF133F66),
      const Color(0xFF326FA1),
      const Color(0xFFAECFE8)
    ],
    [
      const Color(0xFF041522),
      const Color(0xFF0F324E),
      const Color(0xFF2C5680),
      const Color(0xFFA5C3E0)
    ],
    [
      const Color(0xFF0B223A),
      const Color(0xFF174470),
      const Color(0xFF3C73A6),
      const Color(0xFFB3D1EA)
    ],
    [
      const Color(0xFF112233),
      const Color(0xFF2A4867),
      const Color(0xFF3F6E9C),
      const Color(0xFFC5DFF4)
    ],

    // --- AQUA MINTS ---
    [
      const Color(0xFF003F36),
      const Color(0xFF137A6A),
      const Color(0xFF34A393),
      const Color(0xFFC6F3E8)
    ],
    [
      const Color(0xFF004F45),
      const Color(0xFF138C7D),
      const Color(0xFF3DBAA6),
      const Color(0xFFD7F7EF)
    ],
    [
      const Color(0xFF00423D),
      const Color(0xFF157C74),
      const Color(0xFF4CC7BB),
      const Color(0xFFE2FBF7)
    ],

    // --- FOREST GREENS ---
    [
      const Color(0xFF0A2614),
      const Color(0xFF1C4F2B),
      const Color(0xFF3D7A55),
      const Color(0xFFA8D9BB)
    ],
    [
      const Color(0xFF123619),
      const Color(0xFF256A32),
      const Color(0xFF3F9B55),
      const Color(0xFFC1EDCE)
    ],
    [
      const Color(0xFF183F23),
      const Color(0xFF2F7345),
      const Color(0xFF4EA668),
      const Color(0xFFD4F2DB)
    ],

    // --- SLATE & NAVY ---
    [
      const Color(0xFF131A26),
      const Color(0xFF273448),
      const Color(0xFF4D627A),
      const Color(0xFFC8D5E1)
    ],
    [
      const Color(0xFF101B2C),
      const Color(0xFF1E3554),
      const Color(0xFF3A5A80),
      const Color(0xFFA9C1D9)
    ],
    [
      const Color(0xFF1F242A),
      const Color(0xFF374048),
      const Color(0xFF56636D),
      const Color(0xFFBDC8D0)
    ],
    [
      const Color(0xFF0D1A2C),
      const Color(0xFF1B2D47),
      const Color(0xFF3F5677),
      const Color(0xFFCBD6E3)
    ],

    // --- GRAYS & NEUTRAL BLUES ---
    [
      const Color(0xFF1A2028),
      const Color(0xFF2C3A47),
      const Color(0xFF516578),
      const Color(0xFFD0DBE4)
    ],
    [
      const Color(0xFF101820),
      const Color(0xFF1F2F39),
      const Color(0xFF405566),
      const Color(0xFFCCD9E3)
    ],
    [
      const Color(0xFF1D1F22),
      const Color(0xFF323539),
      const Color(0xFF666B70),
      const Color(0xFFDFE2E5)
    ],

    // --- PURPLES ---
    [
      const Color(0xFF1A0F2F),
      const Color(0xFF372864),
      const Color(0xFF5D4B8C),
      const Color(0xFFD0C9E3)
    ],
    [
      const Color(0xFF1F0E33),
      const Color(0xFF463078),
      const Color(0xFF6F58A8),
      const Color(0xFFE2DDF3)
    ],
    [
      const Color(0xFF250E3D),
      const Color(0xFF4B2F79),
      const Color(0xFF7A59AA),
      const Color(0xFFF0E8FF)
    ],

    // --- LILAC & VIOLET ---
    [
      const Color(0xFF2E235C),
      const Color(0xFF433B88),
      const Color(0xFF756CBD),
      const Color(0xFFEDE8FF)
    ],
    [
      const Color(0xFF251A52),
      const Color(0xFF3C3180),
      const Color(0xFF6D60B7),
      const Color(0xFFE4DFFF)
    ],

    // --- EARTHY / BRONZE ---
    [
      const Color(0xFF3A2B14),
      const Color(0xFF6A5127),
      const Color(0xFF9A8044),
      const Color(0xFFE8D9B1)
    ],
    [
      const Color(0xFF2F2512),
      const Color(0xFF5A4725),
      const Color(0xFF8B743A),
      const Color(0xFFE7D9B1)
    ],
    [
      const Color(0xFF44331A),
      const Color(0xFF735628),
      const Color(0xFFB18A43),
      const Color(0xFFF3E5C2)
    ],

    // --- SAND / DESERT ---
    [
      const Color(0xFF4F4022),
      const Color(0xFF806735),
      const Color(0xFFC9A25A),
      const Color(0xFFF7E6C2)
    ],
    [
      const Color(0xFF6A4F1E),
      const Color(0xFF9C7830),
      const Color(0xFFE2BD63),
      const Color(0xFFFFF1CF)
    ],

    // --- PASTEL MIXES ---
    [
      const Color(0xFF123A33),
      const Color(0xFF327A6A),
      const Color(0xFF61B4A2),
      const Color(0xFFDFF6F2)
    ],
    [
      const Color(0xFF103A45),
      const Color(0xFF2F6E81),
      const Color(0xFF60A6BD),
      const Color(0xFFE0F0F5)
    ],
    [
      const Color(0xFF243344),
      const Color(0xFF466080),
      const Color(0xFF89A3C7),
      const Color(0xFFEAF0F8)
    ],

    // --- WARM TONES (for diversity) ---
    [
      const Color(0xFF3C1313),
      const Color(0xFF753333),
      const Color(0xFFBB6060),
      const Color(0xFFF3D6D6)
    ],
    [
      const Color(0xFF402215),
      const Color(0xFF7D442B),
      const Color(0xFFC17C57),
      const Color(0xFFF1D5C2)
    ],
    [
      const Color(0xFF4A2613),
      const Color(0xFF9A4B27),
      const Color(0xFFE58E57),
      const Color(0xFFFFDFC9)
    ],
  ];

  @override
  void initState() {
    super.initState();

    rnd = widget.deterministic && widget.seed != null
        ? Random(widget.seed.hashCode)
        : Random();

    // pick palette only once
    palette = palettes[rnd.nextInt(palettes.length)];

    // generate angles only once
    int sliceCount = 3 + rnd.nextInt(5);
    angles = List.generate(sliceCount, (_) => rnd.nextDouble() * 2 * pi)
      ..sort();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: Stack(
          children: [
            CustomPaint(
              size: Size.square(widget.size),
              painter: _StableCutPainter(
                angles: angles,
                palette: palette,
                darker: widget.icon != null,
              ),
            ),
            if (widget.icon != null)
              Center(
                child: Icon(
                  widget.icon,
                  color: widget.iconColor,
                  size: widget.iconSize,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StableCutPainter extends CustomPainter {
  final List<double> angles;
  final List<Color> palette;
  final bool darker;

  _StableCutPainter({
    required this.angles,
    required this.palette,
    this.darker = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = size.width * .65;

    // background fill
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = palette[0],
    );

    for (int i = 0; i < angles.length; i++) {
      double a1 = angles[i];
      double a2 = angles[(i + 1) % angles.length];

      Color color;
      if (darker) {
        final base = palette[(i + 1) % palette.length];
        final hsl = HSLColor.fromColor(base);

        // darken by 15–35%
        final darker =
            hsl.withLightness((hsl.lightness * 0.65).clamp(0.0, 1.0)).toColor();

        color = darker.withOpacity(0.92);
      } else {
        color = palette[(i + 1) % palette.length];
      }

      final path = Path()
        ..moveTo(cx, cy)
        ..lineTo(cx + radius * cos(a1), cy + radius * sin(a1))
        ..lineTo(cx + radius * cos(a2), cy + radius * sin(a2))
        ..close();

      canvas.drawPath(
        path,
        Paint()..color = color.withOpacity(.92),
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
