import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          backgroundColor: Colors.transparent,

          selectedItemColor: const Color(0xFF0E3A5B),
          unselectedItemColor: Colors.grey,

          selectedFontSize: width * 0.032,
          unselectedFontSize: width * 0.030,

          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.4,
          ),

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.sos_outlined),
              activeIcon: Icon(Icons.sos),
              label: "SOS",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_hospital_outlined),
              activeIcon: Icon(Icons.local_hospital),
              label: "Hospitals",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon: Icon(Icons.history),
              label: "History",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
