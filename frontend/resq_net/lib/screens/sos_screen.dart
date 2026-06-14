import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resq_net/config/theme.dart';
import 'package:resq_net/screens/profile.dart';
import 'package:resq_net/widgets/bottom_navbar.dart';
import 'package:resq_net/widgets/location_bottom_sheet.dart';

class SOSScreen extends StatefulWidget {
  final String token;

  const SOSScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(_controller);

    _opacityAnimation = Tween<double>(
      begin: 0.75,
      end: 1.0,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Show Bottom Sheet
  void _showLocationBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => LocationBottomSheet(token: widget.token),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// HEADER
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shield_outlined, color: Colors.white),
                      SizedBox(width: 8.w),
                      Text(
                        "ResQNet",
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: const Icon(Icons.call, color: Colors.white),
                  ),
                ],
              ),
            ),

            const Spacer(),

            /// 🔴 FLASHING SOS BUTTON
            GestureDetector(
              onTap: _showLocationBottomSheet,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _opacityAnimation.value,
                      child: Container(
                        width: 170.w,
                        height: 170.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.redAccent.withOpacity(0.6),
                              blurRadius: 40.r,
                              spreadRadius: 10.r,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                              size: 36.sp,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "SOS",
                              style: Theme.of(context).textTheme.headlineLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 30.h),

            const Text(
              "Send Help Now",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Choose how to share your location so emergency services can reach you quickly.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) return; // already on SOS

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SOSScreen(token: "your_token_here"),
              ),
            );
          }

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SOSScreen(token: "your_token_here"),
              ),
            );
          }

          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          }
        },
      ),
    );
  }
}
