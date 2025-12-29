import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../complaint_screen.dart';
import '../general_inquiry_screen.dart';
import '../return_request_screen.dart';

//! CustomDrawer
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Flexible(
            flex: 2, // Proportional header size
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 30.r,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.support_agent,
                          size: 30.sp,
                          color: const Color(0xFF2196F3),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Customer Service',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1, // Prevent overflow
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'We\'re here to help',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white70,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3, // More space for ListView
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  Icons.home_outlined,
                  'Home',
                  () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  context,
                  Icons.help_outline,
                  'General Inquiry',
                  () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GeneralInquiryScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.assignment_return,
                  'Return & Refund',
                  () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReturnRequestScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.feedback_outlined,
                  'Complaint & Feedback',
                  () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ComplaintScreen(),
                      ),
                    );
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  Icons.phone_outlined,
                  'Contact Us',
                  () {},
                ),
                _buildDrawerItem(
                  context,
                  Icons.info_outline,
                  'About',
                  () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.grey[700],
        size: 22.sp,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.grey[800],
        ),
        maxLines: 1, // Prevent overflow
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onTap,
    );
  }
}
