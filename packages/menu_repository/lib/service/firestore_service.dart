import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:product_repository/models/product.dart';
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
      List<ProductWeight> products = (data['Names'] as List)
          .map((item) => ProductWeight.fromMap(item))
          .toList();
      return Menu(
        id: doc.id,
        userId: data['UserID'],
        products: products,
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
      List<ProductWeight> products = (data['Names'] as List)
          .map((item) => ProductWeight.fromMap(item))
          .toList();
      return Menu(
        id: doc.id,
        userId: data['UserID'],
        products: products,
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
      List<ProductWeight> products = (data['Names'] as List)
          .map((item) => ProductWeight.fromMap(item))
          .toList();
      return Menu(
        id: doc.id,
        userId: data['UserID'],
        products: products,
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
        'Names': menu.products.map((product) => product.toMap()).toList(),
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
        'Names': menu.products.map((product) => product.toMap()).toList(),
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
  Future<void> removeProductFromMenu(String menuId, String productId) async {
    try {
      final menuDoc = FirebaseFirestore.instance.collection('Menu').doc(menuId);
      final menuSnapshot = await menuDoc.get();

      if (menuSnapshot.exists) {
        final data = menuSnapshot.data();
        if (data != null) {
          List<dynamic> products = data['products'] ?? [];

          products.removeWhere((item) => item['id'] == productId);

          await menuDoc.update({'products': products});

          final removedProductSnapshot = await FirebaseFirestore.instance
              .collection('Products')
              .doc(productId)
              .get();

          if (removedProductSnapshot.exists) {
            final removedProduct = removedProductSnapshot.data();
            final weight = removedProduct?['weight'] ?? 0.0;
            final factor = weight / 100;

            await menuDoc.update({
              'CaloriesSum': FieldValue.increment(-removedProduct?['Calories'] * factor),
              'CarbohydrateSum': FieldValue.increment(-removedProduct?['Carbohydrates'] * factor),
              'FatSum': FieldValue.increment(-removedProduct?['Fat'] * factor),
              'ProteinSum': FieldValue.increment(-removedProduct?['Protein'] * factor),
              'SugarSum': FieldValue.increment(-removedProduct?['Sugar'] * factor),
            });
          }
        }
      }
    } catch (e) {
      print('Error removing product from menu: $e');
    }
  }


  Future<Product?> getProductByName(String productName) async {
    try {
      final productSnapshot = await FirebaseFirestore.instance
          .collection('Products')
          .where('Name', isEqualTo: productName)
          .limit(1)
          .get();

      if (productSnapshot.docs.isNotEmpty) {
        final doc = productSnapshot.docs.first;
        return Product.fromJson(doc.data());
      }
    } catch (e) {
      print('Error fetching product: $e');
    }
    return null;
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

      List<ProductWeight> products = (data['Names'] as List)
          .map((item) => ProductWeight.fromMap(item))
          .toList();

      return Menu(
        id: doc.id,
        userId: data['UserID'],
        products: products,
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