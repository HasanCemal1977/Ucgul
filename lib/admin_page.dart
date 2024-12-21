import 'package:firestoredeneme/users_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart'; // HomePage import

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();

  List<String> wednesdays = []; // Çarşambalar
  String selectedDate = ''; // Seçilen tarih
  String documentId = ''; // Firebase document ID'si

  // Aylar listesi
  List<String> months = [
    'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
  ];

  // 2., 4. ve 5. Çarşambaları hesaplayan fonksiyon
  void _calculateWednesdays() {
    DateTime startDate = DateTime(2025, 1, 1);
    DateTime endDate = DateTime(2050, 12, 31);

    List<String> tempWednesdays = [];

    for (int year = 2024; year <= 2050; year++) {
      for (int month = 1; month <= 12; month++) {
        DateTime firstDayOfMonth = DateTime(year, month, 1);
        int daysToAdd = (DateTime.wednesday - firstDayOfMonth.weekday + 7) % 7;
        DateTime firstWednesday = firstDayOfMonth.add(Duration(days: daysToAdd));

        for (int i = 1; i <= 5; i++) {
          DateTime wednesday = firstWednesday.add(Duration(days: 7 * (i - 1)));
          if (wednesday.month == month && wednesday.year == year) {
            if (i == 2 || i == 4 || i == 5) {
              String formattedDate = '${wednesday.day} ${months[wednesday.month - 1]} ${wednesday.year}';
              tempWednesdays.add(formattedDate); // Format: 14 Ocak 2025
            }
          }
        }
      }
    }

    setState(() {
      wednesdays = tempWednesdays;
    });

    // İlk Çarşambayı seç
    if (wednesdays.isNotEmpty) {
      selectedDate = wednesdays[0];
      _loadData(selectedDate);  // İlk tarihe karşılık gelen verileri yükle
    }
  }

  @override
  void initState() {
    super.initState();
    _calculateWednesdays();  // Çarşambaları hesapla
  }

  // Firebase'den veri çekme ve inputlara yükleme fonksiyonu
  void _loadData(String date) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('texts')
        .where('date', isEqualTo: date)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs.first;
      setState(() {
        selectedDate = date;
        documentId = doc.id; // Firebase'deki dokümanın ID'sini alıyoruz
        _controller1.text = doc['first_text'];
        _controller2.text = doc['second_text'];
        _controller3.text = doc['third_text'];
        _controller4.text = doc['fourth_text'];
      });
    } else {
      // Eğer veriler yoksa alanları boş bırak
      setState(() {
        selectedDate = date;
        documentId = ''; // Firebase'deki doküman ID'sini sıfırla
        _controller1.clear();
        _controller2.clear();
        _controller3.clear();
        _controller4.clear();
      });
    }
  }

  // Firebase'e veri kaydetme fonksiyonu
  void _saveData() async {
    String text1 = _controller1.text.isNotEmpty ? _controller1.text : "";
    String text2 = _controller2.text.isNotEmpty ? _controller2.text : "";
    String text3 = _controller3.text.isNotEmpty ? _controller3.text : "";
    String text4 = _controller4.text.isNotEmpty ? _controller4.text : "";

    if (selectedDate.isNotEmpty) {
      if (documentId.isEmpty) {
        // Yeni veri ekliyoruz
        await FirebaseFirestore.instance.collection('texts').add({
          'date': selectedDate,
          'first_text': text1,
          'second_text': text2,
          'third_text': text3,
          'fourth_text': text4,
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veri başarıyla kaydedildi')));
      } else {
        // Mevcut veriyi güncelliyoruz
        await FirebaseFirestore.instance.collection('texts').doc(documentId).update({
          'date': selectedDate,
          'first_text': text1,
          'second_text': text2,
          'third_text': text3,
          'fourth_text': text4,
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veri başarıyla güncellendi')));
      }
      _clearFields(); // Alanları temizle
    }
  }

  // Alanları temizleme fonksiyonu
  void _clearFields() {
    _controller1.clear();
    _controller2.clear();
    _controller3.clear();
    _controller4.clear();
    setState(() {
      selectedDate = '';
      documentId = '';
    });
  }

  // Veriyi silme fonksiyonu
  void _deleteData() async {
    if (documentId.isNotEmpty) {
      await FirebaseFirestore.instance.collection('texts').doc(documentId).delete();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veri başarıyla silindi')));
      _clearFields(); // Alanları temizle
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.grey.shade600,
       // automaticallyImplyLeading: false,
        title: const Text('Yönetici Paneli', style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(color: Colors.orangeAccent,
            icon: const Icon(Icons.home),
            onPressed: () {
              // HomePage'e gitmek için yönlendiriyoruz
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          IconButton(color: Colors.orangeAccent,
            icon: const Icon(Icons.group),
            onPressed: () {
              // HomePage'e gitmek için yönlendiriyoruz
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UsersPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Dört adet metin kutusu ekliyoruz
              TextField(
                controller: _controller1,
                decoration: const InputDecoration(labelText: 'I. D:. Çalışması'),
              ),
              TextField(
                controller: _controller2,
                decoration: const InputDecoration(labelText: 'II. D:. Çalışması'),
              ),
              TextField(
                controller: _controller3,
                decoration: const InputDecoration(labelText: 'III. D:. Çalışması'),
              ),
              TextField(
                controller: _controller4,
                decoration: const InputDecoration(labelText: 'Kardeş Sofrası'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveData,
                child: const Text('Tamam'),
              ),
              const SizedBox(height: 100),

              // CupertinoPicker ekliyoruz
              SizedBox(
                height: 180,
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(),
                  itemExtent: 40,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedDate = wednesdays[index]; // Seçilen tarihi kaydediyoruz
                    });
                    _loadData(selectedDate); // Veriyi yükle
                  },
                  children: wednesdays.map((wednesday) {
                    return Text(
                      wednesday, // Format: 14 Ocak 2025
                      style: const TextStyle(fontSize: 18),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true, // Klavye açıldığında ekranın yeniden düzenlenmesini sağlıyoruz
    );
  }
}
