import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http_parser/http_parser.dart';

void navigate({
  required BuildContext context,
  required String route,
  Object? arguments,
  Function(dynamic value)? onNavigateComplete,
}) {
  Navigator.pushNamed(
    context,
    route,
    arguments: arguments,
  ).then((value) {
    if (onNavigateComplete != null) {
      onNavigateComplete(value);
    }
  });
}

void navigateReplacement({
  required BuildContext context,
  required String route,
}) {
  Navigator.pushReplacementNamed(context, route);
}

void navigatepushNamedAndRemoveUntil(
    {required BuildContext context, required String route}) {
  Navigator.pushNamedAndRemoveUntil(
    context,
    route,
    (Route<dynamic> route) => false,
  );
}

void navigatePop({required BuildContext context}) {
  Navigator.pop(context);
}

Future launchCustomUrl(context, String? url) async {
  if (url != null) {
    Uri uri = Uri.parse(url);
    await launchUrl(uri);
  }
}

String? displayDate(DateTime? dateTime) {
  if (dateTime == null) {
    return null;
  }
  return DateFormat('yyyy-MM-dd').format(dateTime);
}

String? displayDateAndTime(DateTime? dateTime) {
  if (dateTime == null) {
    return null;
  }
  return DateFormat('yyyy-MM-dd - hh:mm a').format(dateTime);
}

String? formatTimeOfDay(TimeOfDay? timeOfDay) {
  if (timeOfDay != null) {
    final hours = timeOfDay.hourOfPeriod == 0 ? 12 : timeOfDay.hourOfPeriod;
    final minutes = timeOfDay.minute.toString().padLeft(2, '0');
    final period = timeOfDay.period == DayPeriod.am ? "AM" : "PM";
    return "$hours:$minutes $period";
  }
  return null;
}

//! getHourFromTimeOfDay
getHourFromTimeOfDay(TimeOfDay time) {
  return time.hourOfPeriod;
}

//! getMinuteFromTimeOfDay
getMinuteFromTimeOfDay(TimeOfDay time) {
  return time.minute;
}

//! getPeriodFromTimeOfDay
getPeriodFromTimeOfDay(TimeOfDay time) {
  return time.period == DayPeriod.am ? 'AM' : 'PM';
}

String generateRandomString(int length) {
  const characters =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();

  return List.generate(
      length, (index) => characters[random.nextInt(characters.length)]).join();
}

String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  return DateFormat('dd MMM').format(dateTime);
}

String convertTime(DateTime? date) {
  if (date == null) {
    return '--:--';
  }
  return DateFormat('hh:mm a').format(date);
}

String? formatTime(String? dateTimeString) {
  if (dateTimeString == null) return null;
  try {
    DateTime dateTime =
        DateFormat('dd MMM yyyy, hh:mm a').parse(dateTimeString);
    return DateFormat('hh:mma').format(dateTime);
  } catch (e) {
    return null;
  }
}

Future<MultipartFile> uploadImageToAPI(XFile image) async {

  String? mimeType = lookupMimeType(image.path);

  return MultipartFile.fromFile(
    image.path,
    filename: image.path.split('/').last,
    contentType: MediaType.parse(
        mimeType ?? 'image/jpeg'), // defaulting to image/jpeg if not found
  );
}
