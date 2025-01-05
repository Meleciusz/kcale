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



  //function to get menu for today with userId
  Future<List<Menu>> getMenuWithUserID(String userId) async {

    final DateTime now = DateTime.now();
    String year = '${now.year}';
    String month = now.month.toString().padLeft(2, '0');
    String day = now.day.toString().padLeft(2, '0');

    String formattedDate = '$year$month$day';

    num dateNum = int.parse(formattedDate);

    final querySnapshot = await _menuCollection
        .where('Date', isEqualTo: dateNum)
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

  //function to get menu with date
  Future<List<Menu>> getMenuWithDate(DateTime date, String userId) async {

    String year = '${date.year}';
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');

    String formattedDate = '$year$month$day';

    num dateNum = int.parse(formattedDate);

    final querySnapshot = await _menuCollection
        .where('Date', isEqualTo: dateNum)
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

  //function to get menu with time| time = 0, when stats from today, 7 when from week, and 30 when from month
  Future<List<Menu>> getMenuWithTime(String userId, int time) async {

    DateTime now = DateTime.now();
    now = now.subtract(Duration(days: time));


    String year = '${now.year}';
    String month = now.month.toString().padLeft(2, '0');
    String day = now.day.toString().padLeft(2, '0');

    String formattedDate = '$year$month$day';

    num dateNum = int.parse(formattedDate);


    final querySnapshot = await _menuCollection
        .where('UserID', isEqualTo: userId)
        .where('Date', isGreaterThanOrEqualTo: dateNum)
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

  Future<void> addMenu(Menu menu) async {
    try {
      await _menuCollection.add({
        'UserID': menu.userId,
        'Names': menu.Names,
        'CaloriesSum': menu.CaloriesSum,
        'CarbohydrateSum': menu.CarbohydrateSum,
        'FatSum': menu.FatSum,
        'ProteinSum': menu.ProteinSum,
        'SugarSum': menu.SugarSum,
        'Date': menu.Date,
      });
      print("Menu successfully added!");
    } catch (e) {
      print("Error adding menu: $e");
    }
  }

  Future<void> updateMenu(Menu menu) async {
    try {
      await _menuCollection.doc(menu.id).update({
        'Names': menu.Names,
        'CaloriesSum': menu.CaloriesSum,
        'CarbohydrateSum': menu.CarbohydrateSum,
        'FatSum': menu.FatSum,
        'ProteinSum': menu.ProteinSum,
        'SugarSum': menu.SugarSum,
      });
      print("Menu successfully updated!");
    } catch (e) {
      print("Error updating menu: $e");
    }
  }

  Future<void> removeProductFromMenu(String menuId, String productName) async {
    try {
      final menuDoc = FirebaseFirestore.instance.collection('menus').doc(menuId);

      final menuSnapshot = await menuDoc.get();
      if (menuSnapshot.exists) {
        final data = menuSnapshot.data();
        if (data != null) {
          List<dynamic> names = data['Names'] ?? [];

          if (names.contains(productName)) {
            names.remove(productName);

            await menuDoc.update({
              'Names': names,
            });
          }
        }
      }
    } catch (e) {
      print('Error removing product from menu: $e');
    }
  }

  Future<Menu?> getMenuForDateAndUser(int date, String userId) async {
    final querySnapshot = await _menuCollection
        .where('Date', isEqualTo: date)
        .where('UserID', isEqualTo: userId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;
      return Menu(
        id: doc.id,
        userId: data['UserID'],
        Names: List<String>.from(data['Names']),
        CaloriesSum: data['CaloriesSum'],
        CarbohydrateSum: data['CarbohydrateSum'],
        FatSum: data['FatSum'],
        ProteinSum: data['ProteinSum'],
        SugarSum: data['SugarSum'],
        Date: data['Date'],
      );
    }
    return null;
  }
}