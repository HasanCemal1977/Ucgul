import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BirthdayService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const platform = MethodChannel('com.program.ucgul1/notifications');

  Future<void> initialize() async {
    try {
      final bool result = await platform.invokeMethod('initializeNotifications');
      print('Notification initialization result: $result');
    } on PlatformException catch (e) {
      print('Failed to initialize notifications: ${e.message}');
    }
  }

  Future<List<Map<String, dynamic>>> getUpcomingBirthdays() async {
    final now = DateTime.now();
    final oneWeekLater = now.add(Duration(days: 7));
    
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    List<Map<String, dynamic>> upcomingBirthdays = [];

    for (var doc in snapshot.docs) {
      final userData = doc.data() as Map<String, dynamic>;
      if (userData['dogum'] != null) {
        final birthday = DateFormat('dd.MM.yyyy').parse(userData['dogum']);
        final nextBirthday = DateTime(
          now.year,
          birthday.month,
          birthday.day,
        );

        // Eğer bu yılki doğum günü geçtiyse, gelecek yılınkini kontrol et
        if (nextBirthday.isBefore(now)) {
          nextBirthday.add(Duration(days: 365));
        }

        // Bir hafta içinde olan doğum günlerini kontrol et
        if (nextBirthday.isAfter(now.subtract(Duration(days: 1))) &&
            nextBirthday.isBefore(oneWeekLater)) {
          upcomingBirthdays.add({
            ...userData,
            'nextBirthday': nextBirthday,
            'id': doc.id,
          });
        }
      }
    }

    // Tarihe göre sırala
    upcomingBirthdays.sort((a, b) => 
      (a['nextBirthday'] as DateTime).compareTo(b['nextBirthday'] as DateTime));

    return upcomingBirthdays;
  }

  Future<void> checkAndSendBirthdayNotifications() async {
    final now = DateTime.now();
    QuerySnapshot snapshot = await _firestore.collection('users').get();

    for (var doc in snapshot.docs) {
      final userData = doc.data() as Map<String, dynamic>;
      if (userData['dogum'] != null) {
        final birthday = DateFormat('dd.MM.yyyy').parse(userData['dogum']);
        final nextBirthday = DateTime(
          now.year,
          birthday.month,
          birthday.day,
        );

        // Doğum günü yarın ise
        if (nextBirthday.difference(now).inDays == 1) {
          _showNotification(
            '🎂 Yaklaşan Doğum Günü',
            '${userData['name']} ${userData['surname']}\'in doğum günü yarın!',
          );
        }
        // Doğum günü bugün ise
        else if (birthday.month == now.month && birthday.day == now.day) {
          _showNotification(
            '🎉 Bugün Doğum Günü',
            '${userData['name']} ${userData['surname']}\'in doğum günü bugün!',
          );
        }
      }
    }
  }

  Future<void> _showNotification(String title, String body) async {
    try {
      await platform.invokeMethod('showNotification', {
        'title': title,
        'body': body,
        'id': DateTime.now().millisecondsSinceEpoch.remainder(100000),
      });
    } on PlatformException catch (e) {
      print('Failed to show notification: ${e.message}');
    }
  }
}
