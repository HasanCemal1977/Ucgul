
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
         // 'usMuhTel': doc['usMuhTel'],
        //  'usMuhMail': doc['usMuhMail'],

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
                // Text.rich(TextSpan(children: <TextSpan>[
                //   const TextSpan(text: 'Üs:. Muh:. Tel: ', style: TextStyle(fontWeight: FontWeight.bold)),
                //   TextSpan(text: '${lodge['usMuhTel']}'),
                // ])),
                // Text.rich(TextSpan(children: <TextSpan>[
                //   const TextSpan(text: 'Üs:. Muh:. eposta: ', style: TextStyle(fontWeight: FontWeight.bold)),
                //   TextSpan(text: '${lodge['usMuhMail']}'),
                // ])),

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
            const Divider(color: Colors.black26, thickness: 1),
          ],
        );

      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.grey.shade200,
        title: const Text('Ankara Vadisi Loca Listesi', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),),
      ),
      body: ListView.builder(
        itemCount: lodges.length,
        itemBuilder: (context, index) {
          var lodge = lodges[index];
          return Column(
            children: [
              ListTile(
                title: Text('${lodge['lodgeId']} ${lodge['lodgeName']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => _viewLodgeDetails(lodge),
                    ),

                    const Divider(color: Colors.black26, thickness: 1),
                  ],

                ),

              ),
              const Divider(color: Colors.black26, thickness: 1),
            ],
          );

        },

      ),

    );


}
}
