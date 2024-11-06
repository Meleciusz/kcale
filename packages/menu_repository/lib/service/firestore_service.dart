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

  //function to get menu
  Future<List<Menu>> getMenu() async {
    final querySnapshot = await _menuCollection.get();
    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List<String> names = List<String>.from(data['Names']);
      return Menu(
        id: doc.id,
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