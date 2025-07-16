import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LodgesPage extends StatefulWidget {
  const LodgesPage({super.key});

  @override
  _LodgesPageState createState() => _LodgesPageState();
}

class _LodgesPageState extends State<LodgesPage> {
  List<Map<String, dynamic>> lodges = [];
  List<Map<String, dynamic>> filteredLodges = [];

  String selectedLodgeId = ''; // Seçilen loca ID'si (detay için)

  // Arama metni için controller
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLodges();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _loadLodges() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('localar').get();
    setState(() {
      lodges = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'lodgeId': doc['lodgeId'],
          'lodgeName': doc['lodgeName'],
          'lodgeMeetingDays': doc['lodgeMeetingDays'],
          'usMuhName': doc['usMuhName'],
          // 'usMuhTel': doc['usMuhTel'],
          // 'usMuhMail': doc['usMuhMail'],
        };
      }).toList();

      // Matrükül No'ya göre sıralama
      lodges.sort((a, b) {
        int matriculNoA = int.tryParse(a['lodgeId'] ?? '0') ?? 0;
        int matriculNoB = int.tryParse(b['lodgeId'] ?? '0') ?? 0;
        return matriculNoA.compareTo(matriculNoB); // Küçükten büyüğe sıralama
      });

      filteredLodges = lodges; // Başlangıçta tüm listeyi göster
    });
  }

  // Arama çubuğunda metin değiştiğinde çağrılır
  void _onSearchChanged() {
    String searchText = _searchController.text.toLowerCase();

    setState(() {
      if (searchText.isEmpty) {
        filteredLodges = lodges;
      } else {
        filteredLodges = lodges.where((lodge) {
          return lodge['lodgeId']
              .toString()
              .toLowerCase()
              .contains(searchText) ||
              lodge['lodgeName'].toLowerCase().contains(searchText);
        }).toList();
      }
    });
  }

  void _viewLodgeDetails(Map<String, dynamic> lodge) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Loca Bilgileri'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(
                      text: 'Loca Matrikülü: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${lodge['lodgeId']}'),
                ])),
                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(
                      text: 'Loca: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${lodge['lodgeName']}'),
                ])),
                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(
                      text: 'Toplantı Günleri: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${lodge['lodgeMeetingDays']}'),
                ])),
                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(
                      text: 'Üs:. Muh:. : ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${lodge['usMuhName']}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: const Text(
          'Ankara Vadisi Loca Listesi',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          // Logo alanı (bozulmadan korundu)
          Container(
            padding: const EdgeInsets.all(16),
            child: Image.asset('assets/images/ucgul.png'),
          ),

          // Buraya arama kutusu eklendi
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Ara...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),

          // Liste kısmı Expanded içine alındı ki ekranı kaplasın
          Expanded(
            child: ListView.builder(
              itemCount: filteredLodges.length,
              itemBuilder: (context, index) {
                var lodge = filteredLodges[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text('${lodge['lodgeId']} ${lodge['lodgeName']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () => _viewLodgeDetails(lodge),
                      ),
                    ),
                    const Divider(color: Colors.black26, thickness: 1),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
