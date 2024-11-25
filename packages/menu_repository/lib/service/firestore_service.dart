import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../model/model.dart';


/*
FirestoreService - service to make requests to Firestore
 */
class FirestoreMenuService {
  FirestoreMenuService(){
    _checkInternetConnection();
  }

  //function to check internet connection
  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {

      //if device has internet connection, clear firestore cache
      await clearFirestoreCache();
    }
  }

  //function to clear firestore cache
  Future<void> clearFirestoreCache() async {
    try {
      await FirebaseFirestore.instance.clearPersistence();
    } catch (e) {
      print('Error: $e');
    }
  }

  //reference to menu collection
  final CollectionReference _menuCollection =
  FirebaseFirestore.instance.collection('Menu');


  //function to get menu for today
  Future<List<Menu>> getMenu() async {

    final DateTime now = DateTime.now();
    final DateTime startOfToday = DateTime(now.year, now.month, now.day);

     final querySnapshot = await _menuCollection
        .where('Date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfToday))
        .where('Date', isLessThan: Timestamp.fromDate(startOfToday.add(const Duration(days: 1))))
        // .where('UserID', isEqualTo: userId)
        .get();

    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List<String> names = List<String>.from(data['Names']);
      return Menu(
        id: doc.id,
        userId: data['UserID'],
        Names: names,
        CaloriesSum: data['CaloriesSum'],
        CarbohydrateSum: data['CarbohydrateSum'],
        FatSum: data['FatSum'],
        ProteinSum: data['ProteinSum'],
        SugarSum: data['SugarSum'],
        Date: data['Date'],
      );
    }).toList();
  }

  //function to get menu for today with userId
  Future<List<Menu>> getMenuWithUserID(String userId) async {

    final DateTime now = DateTime.now();
    String nowDate = '${now.year}-${now.month}-${now.day}';

    final querySnapshot = await _menuCollection
        .where('Date', isEqualTo: nowDate)
        //.where('UserID', isEqualTo: userId)
        .get();




    print('----------------------------------------------------------------');
    print(nowDate);
    print(now);
    print(userId);
    for (var doc in querySnapshot.docs) {
      print('Data: ${doc.data()}');
    }


    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List<String> names = List<String>.from(data['Names']);
      return Menu(
        id: doc.id,
        userId: data['UserID'],
        Names: names,
        CaloriesSum: data['CaloriesSum'],
        CarbohydrateSum: data['CarbohydrateSum'],
        FatSum: data['FatSum'],
        ProteinSum: data['ProteinSum'],
        SugarSum: data['SugarSum'],
        Date: data['Date'],
      );
    }).toList();
  }

  //function to get menu with date
  Future<List<Menu>> getMenuWithDate(DateTime date, String userId) async {

    String dateString = '${date.year}-${date.month}-${date.day}';

    final querySnapshot = await _menuCollection
        .where('Date', isEqualTo: dateString)
        .where('UserID', isEqualTo: userId)
        .get();


    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List<String> names = List<String>.from(data['Names']);
      return Menu(
        id: doc.id,
        userId: data['UserID'],
        Names: names,
        CaloriesSum: data['CaloriesSum'],
        CarbohydrateSum: data['CarbohydrateSum'],
        FatSum: data['FatSum'],
        ProteinSum: data['ProteinSum'],
        SugarSum: data['SugarSum'],
        Date: data['Date'],
      );
    }).toList();
  }
}