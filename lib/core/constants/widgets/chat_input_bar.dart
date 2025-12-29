import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//! ChatInputBar
class ChatInputBar extends StatefulWidget {
  final Function(String)? onSendMessage; // جعلها اختيارية
  final Function(File)? onImagePicked; // جعلها اختيارية
  final Widget? replyBox;

  const ChatInputBar({
    super.key,
    this.onSendMessage, // اختيارية
    this.onImagePicked, // اختيارية
    this.replyBox,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

//! _ChatInputBarState
class _ChatInputBarState extends State<ChatInputBar>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  bool isTyping = false;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.replyBox != null) widget.replyBox!,
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
          child: Row(
            textDirection: TextDirection.ltr, // تثبيت الاتجاه ليكون LTR دائمًا

            children: [
              SizedBox(width: 8.w),


              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffF7F7FC), // لون الخلفية المطلوب
                    borderRadius: BorderRadius.circular(10.r), // زوايا دائرية
                  ),
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(fontSize: 14.sp),
                    decoration: InputDecoration(
                      hintText: Directionality.of(context) == TextDirection.rtl
                          ? "اكتب رسالتك..."
                          : "Aa",
                      border: InputBorder.none, // إزالة البوردر
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 12.h),
                    ),
                    onChanged: (value) {
                      setState(() {
                        isTyping = value.isNotEmpty;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(width: 8.w),

              GestureDetector(
                onTap: () {
                  if (isTyping && widget.onSendMessage != null) {
                    widget.onSendMessage!(_controller.text);
                    _controller.clear();
                    setState(() {
                      isTyping = false;
                      _animationController?.reverse();
                    });
                  } else if (!isTyping) {}
                },
                child: const Icon(
                  CupertinoIcons.paperplane,
                  color: Color(0xffADB5BD),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
