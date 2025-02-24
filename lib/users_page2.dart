import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersPage2 extends StatefulWidget {
  const UsersPage2({super.key});

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage2> {
  List<Map<String, dynamic>> users = [];

  // Yeni kullanıcı formu için TextEditingController'lar
  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _surnameController = TextEditingController();
  // final TextEditingController _phoneController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _matriculNoController = TextEditingController();
  // final TextEditingController _sicilNoController = TextEditingController();
  // final TextEditingController _tekrisController = TextEditingController();
  // final TextEditingController _gecisController = TextEditingController();
  // final TextEditingController _yukselisController = TextEditingController();
  // final TextEditingController _dogumController = TextEditingController();
  // final TextEditingController _meslekController = TextEditingController();
  // final TextEditingController _kangrubuController = TextEditingController();
  // final TextEditingController _esisimController = TextEditingController();
  // final TextEditingController _estelController = TextEditingController();
  // final TextEditingController _esmailController = TextEditingController();
  // final TextEditingController _esmeslekController = TextEditingController();
  // final TextEditingController _esdogumController = TextEditingController();
  // final TextEditingController _eskangrubuController = TextEditingController();

  String selectedUserId = '';  // Seçilen kullanıcının ID'si (güncelleme için)

  @override
  void initState() {
    super.initState();
    _loadUsers();  // Firebase'den kullanıcı verilerini alıyoruz
  }

  // Kullanıcıları Firebase'den alıyoruz
  void _loadUsers() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      users = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'surname': doc['surname'],
          'phone': doc['phone'],
          'email': doc['email'],
          'matriculNo': doc['matriculNo'],
          'sicilNo': doc['sicilNo'],
          'tekris': doc['tekris'],
          'gecis': doc['gecis'],
          'yukselis': doc['yukselis'],
          'dogum': doc['dogum'],
          'meslek': doc['meslek'],
          'kangrubu': doc['kangrubu'],
          'rehber': doc['rehber'],
          'esisim': doc['esisim'],
          'estel': doc['estel'],
          'esmail': doc['esmail'],
          'esmeslek': doc['esmeslek'],
          'esdogum': doc['esdogum'],
          'eskangrubu': doc['eskangrubu'],
        };
      }).toList();

      // Matrükül No'ya göre sıralama
      users.sort((a, b) {
        int matriculNoA = int.tryParse(a['matriculNo'] ?? '0') ?? 0;
        int matriculNoB = int.tryParse(b['matriculNo'] ?? '0') ?? 0;
        return matriculNoA.compareTo(matriculNoB); // Küçükten büyüğe sıralama
      });
    });
  }


  // Yeni kullanıcıyı Firebase'e kaydetme fonksiyonu
  // void _addUser() async {
  //   String name = _nameController.text.trim();
  //   String surname = _surnameController.text.trim();
  //   String phone = _phoneController.text.trim();
  //   String email = _emailController.text.trim();
  //   String matriculNo = _matriculNoController.text.trim();
  //   String sicilNo = _sicilNoController.text.trim();
  //   String tekris = _tekrisController.text.trim();
  //   String gecis = _gecisController.text.trim();
  //   String yukselis = _yukselisController.text.trim();
  //   String dogum = _dogumController.text.trim();
  //   String meslek = _meslekController.text.trim();
  //   String kangrubu = _kangrubuController.text.trim();
  //   String esisim = _esisimController.text.trim();
  //   String estel = _estelController.text.trim();
  //   String esmail = _esmailController.text.trim();
  //   String esmeslek = _esmeslekController.text.trim();
  //   String esdogum = _esdogumController.text.trim();
  //   String eskangrubu = _eskangrubuController.text.trim();



    // Eğer tüm bilgiler girildiyse, Firebase'e ekleyelim
    // if (name.isNotEmpty && surname.isNotEmpty ) {
    //   await FirebaseFirestore.instance.collection('users').add({
    //     'name': name,
    //     'surname': surname,
    //     'phone': phone,
    //     'email': email,
    //     'matriculNo': matriculNo,
    //     'sicilNo': sicilNo,
    //     'tekris': tekris,
    //     'gecis': gecis,
    //     'yukselis': yukselis,
    //     'dogum': dogum,
    //     'meslek': meslek,
    //     'kangrubu': kangrubu,
    //     'esisim': esisim,
    //     'estel': estel,
    //     'esmail': esmail,
    //     'esmeslek': esmeslek,
    //     'esdogum': esdogum,
    //     'eskangrubu': eskangrubu,
    //
    //   });
    //
    //   // Veriler başarılı şekilde kaydedildiğinde mesaj göster
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kullanıcı başarıyla eklendi')));
    //
    //   // Formu temizle
    //   _clearForm();
    //
    //   // Listeyi yeniden yükle
    //   _loadUsers();
    // }
  // }

  // Kullanıcıyı görüntüleme fonksiyonu (Detaylar için)
  void _viewUserDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          //backgroundColor: Colors.grey.shade300,
          title: const Text('Üye Bilgileri'),
          content: SingleChildScrollView(  // Wrap the content in a scrollable view
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(text: 'İsim: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${user['name']}'),
                ])),
                const Divider(color: Colors.black26, thickness: 1, height: 20),  // Divider after each item

                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(text: 'Soyisim: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${user['surname']}'),
                ])),
                const Divider(color: Colors.black26, thickness: 1, height: 20),

                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(text: 'Telefon: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${user['phone']}'),
                ])),
                const Divider(color: Colors.black26, thickness: 1, height: 20),

                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(text: 'E-posta: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${user['email']}'),
                ])),
                const Divider(color: Colors.black26, thickness: 1, height: 20),

                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(text: 'Matrikül No: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${user['matriculNo']}'),
                ])),
                const Divider(color: Colors.black26, thickness: 1, height: 20),

                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(text: 'Tekris: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${user['tekris']}'),
                ])),
                const Divider(color: Colors.black26, thickness: 1, height: 20),

                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(text: 'Geçiş: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${user['gecis']}'),
                ])),
                const Divider(color: Colors.black26, thickness: 1, height: 20),

                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(text: 'Yükseliş: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${user['yukselis']}'),
                ])),
                const Divider(color: Colors.black26, thickness: 1, height: 20),

                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(text: 'Doğum Tarihi: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${user['dogum']}'),
                ])),
                const Divider(color: Colors.black26, thickness: 1, height: 20),

                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(text: 'Meslek: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${user['meslek']}'),
                ])),
                const Divider(color: Colors.black26, thickness: 1, height: 20),

                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(text: 'Kan Grubu: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${user['kangrubu']}'),
                ])),
                const Divider(color: Colors.black26, thickness: 1, height: 20),

                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(text: 'Rehber Üs:.: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${user['rehber']}'),
                ])),
                const Divider(color: Colors.black, thickness: 3, height: 20),

                const SizedBox(height: 30),
                const Text('Eşinin Bilgileri', style: TextStyle(fontSize: 22)),
                const SizedBox(height: 15),
                const Divider(color: Colors.black26, thickness: 1, height: 20),

                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(text: 'İsim: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${user['esisim']}'),
                ])),
                const Divider(color: Colors.black26, thickness: 1, height: 20),

                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(text: 'Telefon: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${user['estel']}'),
                ])),
                const Divider(color: Colors.black26, thickness: 1, height: 20),

                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(text: 'E-posta: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${user['esmail']}'),
                ])),
                const Divider(color: Colors.black26, thickness: 1, height: 20),

                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(text: 'Meslek: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${user['esmeslek']}'),
                ])),
                const Divider(color: Colors.black26, thickness: 1, height: 20),

                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(text: 'Doğum Tarihi: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${user['esdogum']}'),
                ])),
                const Divider(color: Colors.black26, thickness: 1, height: 20),

                Text.rich(TextSpan(children: <TextSpan>[
                  const TextSpan(text: 'Kan Grubu: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '${user['eskangrubu']}'),
                ])),
              ],
            ),
          ),
          actions: [
            SizedBox(height: 30,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Kapat'),
              ),
            ),
          ],
        );
      },
    );
  }




  // Formu temizleme fonksiyonu
  // void _clearForm() {
  //   _nameController.clear();
  //   _surnameController.clear();
  //   _phoneController.clear();
  //   _emailController.clear();
  //   _matriculNoController.clear();
  //   _sicilNoController.clear();
  //   _tekrisController.clear();
  //   _gecisController.clear();
  //   _yukselisController.clear();
  //   _dogumController.clear();
  //   _meslekController.clear();
  //   _kangrubuController.clear();
  //   _esisimController.clear();
  //   _estelController.clear();
  //   _esmailController.clear();
  //   _esmeslekController.clear();
  //   _esdogumController.clear();
  //   _eskangrubuController.clear();
  //
  // }

  // Ayarlar ikonu ile güncelleme popup'ı
  // void _showUpdateUserDialog(String userId) async {
  //   // Seçilen kullanıcının ID'sini kaydet
  //   selectedUserId = userId;
  //
  //   // Firebase'den kullanıcının verilerini alalım
  //   DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  //
  //   // Verileri controller'lara yükleyelim
  //   _nameController.text = doc['name'];
  //   _surnameController.text = doc['surname'];
  //   _phoneController.text = doc['phone'];
  //   _emailController.text = doc['email'];
  //   _matriculNoController.text = doc['matriculNo'] ?? '';
  //   _sicilNoController.text = doc['sicilNo'] ?? '';
  //   _tekrisController.text = doc['tekris'] ?? '';
  //   _gecisController.text = doc['gecis'] ?? '';
  //   _yukselisController.text = doc['yukselis'] ?? '';
  //   _dogumController.text = doc['dogum'] ?? '';
  //   _meslekController.text = doc['meslek'] ?? '';
  //   _kangrubuController.text = doc['kangrubu'] ?? '';
  //   _esisimController.text = doc['esisim'] ?? '';
  //   _estelController.text = doc['estel'] ?? '';
  //   _esmailController.text = doc['esmail'] ?? '';
  //   _esmeslekController.text = doc['esmeslek'] ?? '';
  //   _esdogumController.text = doc['esdogum'] ?? '';
  //   _eskangrubuController.text = doc['eskangrubu'] ?? '';
  //
  //
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.grey.shade200,
          toolbarHeight: 80,

          title: Row(
          children: [
      Expanded(child: Image.asset('assets/images/ucgul.png')),
            const SizedBox(width: 10),
             ],
        ),

      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          var user = users[index];
          return Column(
            children: [
              ListTile(
                title: Text('${user['matriculNo']} - ${user['name']} ${user['surname']}', ),

                // Matrükül No ve İsim

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => _viewUserDetails(user),
                    ),

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

  // Yeni kullanıcı ekleme popup'ı

}
