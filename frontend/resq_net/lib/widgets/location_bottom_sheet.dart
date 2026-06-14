import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resq_net/config/theme.dart';
import 'package:resq_net/screens/location_confirm_screen.dart';
import 'package:resq_net/screens/manual_location_screen.dart';
import 'package:resq_net/services/location_service.dart';

class LocationBottomSheet extends StatefulWidget {
  final String token;

  const LocationBottomSheet({super.key, required this.token});

  @override
  State<LocationBottomSheet> createState() => _LocationBottomSheetState();
}

class _LocationBottomSheetState extends State<LocationBottomSheet> {
  bool _isLoading = false;

  Future<void> _handleAllowLocation() async {
    setState(() => _isLoading = true);

    final position = await LocationService.getCurrentLocation();

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (position != null) {
      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => LocationConfirmScreen(
            latitude: position.latitude,
            longitude: position.longitude,
            token: widget.token, // ✅ PASS TOKEN HERE
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Location access is required to find nearby hospitals. Please enable GPS.",
          ),
        ),
      );
    }
  }

  void _handleManualLocation() {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ManualLocationScreen(token: widget.token),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Share Your Location",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.theme.primaryColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 10.h),

            Text(
              "Allow location access to find nearby hospitals or enter it manually.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
            ),

            SizedBox(height: 20.h),

            /// Allow Location Button
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleAllowLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.theme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 22.h,
                        width: 22.w,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        "Allow Location",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            SizedBox(height: 12.h),

            /// Manual Location Button
            TextButton(
              onPressed: _handleManualLocation,
              child: Text(
                "Enter Location Manually",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.theme.primaryColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
