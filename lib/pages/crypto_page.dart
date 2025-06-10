import 'dart:math';

import 'package:flutter/material.dart';

class CryptoPage extends StatefulWidget {
  const CryptoPage({super.key});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;

  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _rotationController = AnimationController(
      duration: Duration(seconds: 20),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(_rotationController);

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D0D0D), Color(0xFF1A0B2E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            _buildBackgroundElements(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    _buildHeaderSection(),
                    Expanded(
                      child: Center(child: _buildCentral3DVisualization()),
                    ),

                    _buildBottomSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Column(
      children: [
        Text(
          'Discover the Future',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 8,
        ),
        ShaderMask(
          shaderCallback: (bounds) =>
              LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5cF6)])
                  .createShader(bounds),
          child: Text(
            'Dwaipayan Biswas',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 24,
        ),
        Text(
          'Experience seamless crypto trading with advanced\nsecurity and intuitive design. Join millions of users\nwho trust our platform for their digital\n investments.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Color(0xFF9CA3AF), height: 1.6),
        ),
        SizedBox(
          height: 40,
        ),
        Row(
          children: [
            Expanded(
                child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context,child) {
                      return Transform.scale(
                        scale: 1 + (_pulseAnimation.value - 1) * 0.08,
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color(0xFF6366F1),
                                Color(0xFF8B5CF6),
                              ]),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF6366F1).withOpacity(.4),
                                    blurRadius: 20,
                                    offset: Offset(0, 8))
                              ]),
                          child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Get Started',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              )),
                        ),
                      );
                    }
                )),
            SizedBox(
              width: 16,
            ),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.1),
                borderRadius: BorderRadius.circular(28),
                border:
                Border.all(color: Colors.white.withOpacity(.2), width: 1),
              ),
              child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 24,
                  )),
            )
          ],
        )
      ],
    );
  }

  Widget _buildCentral3DVisualization() {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value * .1,
          child: SizedBox(
            height: 280,
            width: 280,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Color(0xFF6366F1),
                              Color(0xFF8B5CF6),
                              Color(0xFF1E1B4B),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF6366F1).withValues(alpha: .4),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    );
                  },
                ),

                ...List.generate(8, (index) {
                  final angle = _rotationAnimation.value + (index * pi / 4);

                  return Transform.translate(
                    offset: Offset(cos(angle) * 100, sin(angle) * 100),
                    child: _buildOrbitingCube(index),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrbitingCube(int index) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (_pulseAnimation.value * 0.3),
          child: Container(
            width: 40 + (index % 3) * 8,
            height: 40 + (index % 3) * 8,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,

                colors: [
                  Color.lerp(
                    Color(0xFF6366F1),
                    Color(0xFF8B5CF6),
                    index / 8,
                  )!.withValues(alpha: .8),
                  Color.lerp(
                    Color(0xFF8B5CF6),
                    Color(0xFF6366F1),
                    index / 8,
                  )!.withValues(alpha: .4),
                ],
              ),

              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF6366F1).withValues(alpha: 0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                _getCryptoIcon(index),
                color: Colors.white.withValues(alpha: 0.9),
                size: 16 + (index % 3) * 4,
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getCryptoIcon(int index) {
    final icons = [
      Icons.currency_bitcoin,
      Icons.currency_exchange,
      Icons.trending_up,
      Icons.account_balance,
      Icons.analytics,
      Icons.security,
      Icons.savings,
      Icons.star,
    ];
    return icons[index % icons.length];
  }

  Widget _buildBackgroundElements() {
    return Stack(
      children: [
        ...List.generate(12, (index) {
          return AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              final angle = _rotationAnimation.value + (index * 0.5);
              final double radius = 120 + (index * 20);
              final x =
                  MediaQuery.of(context).size.width / 2 + cos(angle) * radius;
              final y =
                  MediaQuery.of(context).size.height / 2 + sin(angle) * radius;
              return Positioned(
                left: x,
                top: y,
                child: Container(
                  width: 4 + (index % 3) * 2,
                  height: 4 + (index % 3) * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.lerp(
                      Color(0xFF6366F1),
                      Color(0xFF8B5CF6),
                      index / 12,
                    )?.withValues(alpha: .6),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF6366F1).withOpacity(.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF6366F1).withOpacity(.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                Icons.currency_bitcoin,
                color: Colors.white,
                size: 28,
              ),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dwaipayan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Next-gen Trading',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8B5CF6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
