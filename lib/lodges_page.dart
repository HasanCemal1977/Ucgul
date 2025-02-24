
//mport 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LodgesPage extends StatefulWidget {
  const LodgesPage({super.key});

  @override
  _LodgesPageState createState() => _LodgesPageState();
}

class _LodgesPageState extends State<LodgesPage> {
  List<Map<String, dynamic>> lodges = [];

  // Yeni kullanıcı formu için TextEditingController'lar
  final TextEditingController _lodgeIdController = TextEditingController();
  final TextEditingController _lodgeNameController = TextEditingController();
  final TextEditingController _lodgeMeetingDaysController = TextEditingController();
  final TextEditingController _usMuhNameController = TextEditingController();
  final TextEditingController _usMuhTelController = TextEditingController();
  final TextEditingController _usMuhMailController = TextEditingController();



  String selectedLodgeId = '';  // Seçilen kullanıcının ID'si (güncelleme için)

  @override
  void initState() {
    super.initState();
    _loadLodges();  // Firebase'den kullanıcı verilerini alıyoruz
  }

  // Kullanıcıları Firebase'den alıyoruz
  void _loadLodges() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('localar').get();
    setState(() {
      lodges = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'lodgeId': doc['lodgeId'],
          'lodgeName': doc['lodgeName'],
          'lodgeMeetingDays': doc['lodgeMeetingDays'],
          'usMuhName': doc['usMuhName'],
          'usMuhTel': doc['usMuhTel'],
          'usMuhMail': doc['usMuhMail'],

        };
      }).toList();

      // Matrükül No'ya göre sıralama
      lodges.sort((a, b) {
        int matriculNoA = int.tryParse(a['lodgeId'] ?? '0') ?? 0;
        int matriculNoB = int.tryParse(b['lodgeId'] ?? '0') ?? 0;
        return matriculNoA.compareTo(matriculNoB); // Küçükten büyüğe sıralama
      });
    });
  }


  // Yeni kullanıcıyı Firebase'e kaydetme fonksiyonu
  void _addLodge() async {
    String lodgeId = _lodgeIdController.text.trim();
    String lodgeName = _lodgeNameController.text.trim();
    String lodgeMeetingDays = _lodgeMeetingDaysController.text.trim();
    String usMuhName = _usMuhNameController.text.trim();
    String usMuhTel = _usMuhTelController.text.trim();
    String usMuhMail = _usMuhMailController.text.trim();



    // Eğer tüm bilgiler girildiyse, Firebase'e ekleyelim
    if (lodgeId .isNotEmpty && lodgeName.isNotEmpty ) {
      await FirebaseFirestore.instance.collection('localar').add({
        'lodgeId': lodgeId,
        'lodgeName': lodgeName,
        'lodgeMeetingDays': lodgeMeetingDays,
        'usMuhName': usMuhName,
        'usMuhTel': usMuhTel ,
        'usMuhMail': usMuhMail ,


      });

      // Veriler başarılı şekilde kaydedildiğinde mesaj göster
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kullanıcı başarıyla eklendi')));

      // Formu temizle
      _clearForm();

      // Listeyi yeniden yükle
      _loadLodges();
    }
  }

  // Kullanıcıyı görüntüleme fonksiyonu (Detaylar için)
  void _viewLodgeDetails(Map<String, dynamic> lodge) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Loca Bilgileri'),
          content: SingleChildScrollView(  // Wrap the content in a scrollable view
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(text: 'Loca Matrikülü: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${lodge['lodgeId']}'),
                ])),
                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(text: 'Loca: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${lodge['lodgeName']}'),
                ])),
                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(text: 'Toplantı Günleri: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${lodge['lodgeMeetingDays']}'),
                ])),
                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(text: 'Üs:. Muh:. : ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${lodge['usMuhName']}'),
                ])),
                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(text: 'Üs:. Muh:. Tel: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${lodge['usMuhTel']}'),
                ])),
                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(text: 'Üs:. Muh:. eposta: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${lodge['usMuhMail']}'),
                ])),

              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Kapat'),
            ),
          ],
        );

      },
    );
  }

  // Kullanıcıyı silme fonksiyonu
  void _deleteLodge(String lodgeId) async {
    bool deleteConfirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Silme Onayı'),
          content: const Text('Bu Locayaı silmek istediğinizden emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // İptal
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Onayla
              },
              child: const Text('Evet'),
            ),
          ],
        );
      },
    );

    if (deleteConfirmed) {
      await FirebaseFirestore.instance.collection('localar').doc(lodgeId).delete();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Loca başarıyla silindi')));
      _loadLodges(); // Kullanıcı listesini yeniden yükle
    }
  }

  // Kullanıcıyı güncelleme fonksiyonu
  void _updateLodge() async {
    String lodgeId = _lodgeIdController.text.trim();
    String lodgeName = _lodgeNameController.text.trim();
    String lodgeMeetingDays = _lodgeMeetingDaysController.text.trim();
    String usMuhName = _usMuhNameController.text.trim();
    String usMuhTel = _usMuhTelController.text.trim();
    String usMuhMail = _usMuhMailController.text.trim();




    if (lodgeId.isNotEmpty && lodgeName.isNotEmpty && usMuhTel.isNotEmpty && usMuhMail.isNotEmpty) {
      await FirebaseFirestore.instance.collection('localar').doc(selectedLodgeId).update({
        'lodgeId': lodgeId,
        'lodgeName': lodgeName,
        'lodgeMeetingDays': lodgeMeetingDays,
        'usMuhName': usMuhName,
        'usMuhTel': usMuhTel,
        'usMuhMail': usMuhMail,

      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Loca bilgileri başarıyla güncellendi')));

      // Formu temizle
      _clearForm();

      // Listeyi yeniden yükle
      _loadLodges();
    }
  }

  // Formu temizleme fonksiyonu
  void _clearForm() {
    _lodgeIdController.clear();
    _lodgeNameController.clear();
    _lodgeMeetingDaysController.clear();
    _usMuhNameController.clear();
    _usMuhTelController.clear();
    _usMuhMailController.clear();

  }

  // Ayarlar ikonu ile güncelleme popup'ı
  void _showUpdateLodgeDialog(String lodgeId) async {
    // Seçilen kullanıcının ID'sini kaydet
    selectedLodgeId = lodgeId;

    // Firebase'den kullanıcının verilerini alalım
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('localar').doc(lodgeId).get();

    // Verileri controller'lara yükleyelim
    _lodgeIdController.text = doc['lodgeId'];
    _lodgeNameController.text = doc['lodgeName'];
    _lodgeMeetingDaysController.text = doc['lodgeMeetingDays'];
    _usMuhNameController.text = doc['usMuhName'];
    _usMuhTelController.text = doc['usMuhTel'] ?? '';
    _usMuhMailController.text = doc['usMuhMail'] ?? '';



    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Locayı Güncelle'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _lodgeIdController,
                  decoration: const InputDecoration(labelText: 'Loca Matrikülü'),
                ),
                TextField(
                  controller: _lodgeNameController,
                  decoration: const InputDecoration(labelText: 'Loca'),
                ),
                TextField(
                  controller: _lodgeMeetingDaysController,
                  decoration: const InputDecoration(labelText: 'Toplantı Tarihleri'),
                ),
                TextField(
                  controller: _usMuhNameController,
                  decoration: const InputDecoration(labelText: 'Üs:. Muh:.'),
                ),
                TextField(
                  controller: _usMuhTelController,
                  decoration: const InputDecoration(labelText: 'Üs:. Muh:. Tel'),
                ),
                TextField(
                  controller: _usMuhMailController,
                  decoration: const InputDecoration(labelText: 'Üs:. Muh:. eposta'),
                ),

              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // İptal et
              },
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateLodge(); // Güncelleme işlemini yap
                Navigator.of(context).pop(); // Kapat
              },
              child: const Text('Güncelle'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.grey.shade200,
        title: const Text('Ankara Vadisi Loca Listesi'),
      ),
      body: ListView.builder(
        itemCount: lodges.length,
        itemBuilder: (context, index) {
          var lodge = lodges[index];
          return ListTile(
            title: Text('${lodge['lodgeId']} ${lodge['lodgeName']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red,),
                  onPressed: () => _deleteLodge(lodge['id']),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _viewLodgeDetails(lodge),
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.green,),
                  onPressed: () => _showUpdateLodgeDialog(lodge['id']),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          backgroundColor: Colors.grey.shade300,
          onPressed: _showAddLodgeDialog,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  // Yeni kullanıcı ekleme popup'ı
  void _showAddLodgeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Yeni Loca Ekle'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _lodgeIdController,
                  decoration: const InputDecoration(labelText: 'Loca Matrikülü'),
                ),
                TextField(
                  controller: _lodgeNameController,
                  decoration: const InputDecoration(labelText: 'Loca'),
                ),
                TextField(
                  controller: _lodgeMeetingDaysController,
                  decoration: const InputDecoration(labelText: 'Toplantı Günleri'),
                ),
                TextField(
                  controller: _usMuhNameController,
                  decoration: const InputDecoration(labelText: 'Üs:. Muh:.'),
                ),
                TextField(
                  controller: _usMuhTelController,
                  decoration: const InputDecoration(labelText: 'Üs:. Muh:. Tel'),
                ),
                TextField(
                  controller: _usMuhMailController,
                  decoration: const InputDecoration(labelText: 'Üs:. Muh:. eposta'),
                ),

              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // İptal et
              },
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                _addLodge(); // Kullanıcıyı ekle
                Navigator.of(context).pop(); // Kapat
              },
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }
}
