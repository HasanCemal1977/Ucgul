import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kullanıcıları Firebase'den alıp email ve sicilNo ikilisiyle bir liste oluşturuyoruz
  Future<List<Map<String, String>>> getPasswordControlList() async {
    final snapshot = await _firestore.collection('users').get();

    // Firebase'den gelen verilerle passwordControlList oluşturuluyor
    List<Map<String, String>> passwordControlList = [];
    for (var doc in snapshot.docs) {
      passwordControlList.add({
        'email': doc['email'], // Kullanıcı email
        'password': doc['password'], // SicilNo'yu password olarak kullanıyoruz
      });
    }

    return passwordControlList;
  }
}
