import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/product.dart';

class FirestoreProductService {
  FirestoreProductService(){
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

  final CollectionReference _productCollection =
  FirebaseFirestore.instance.collection('Products');

  Future<List<Product>> getProducts() async{
    final querySnapshot = await _productCollection.get();
    return querySnapshot.docs.map((doc){
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Product(
        id:doc.id,
        Name: data['Name'],
        Weight: data['Weight'],
        Calories: data['Calories'],
        Carbohydrates: data['Carbohydrates'],
        Fat: data['Fat'],
        Protein: data['Protein'],
        Sugar: data['Sugar'],
        ModifiedDate: data['ModifiedDate'],
      );
    }).toList();
  }

  Future<void> addProduct(Product product) async{
    try {
      await _productCollection.add({
        'Name': product.Name,
        'Weight': product.Weight,
        'Calories': product.Calories,
        'Carbohydrates': product.Carbohydrates,
        'Fat': product.Fat,
        'Protein': product.Protein,
        'Sugar': product.Sugar,
        'ModifiedDate': product.ModifiedDate,
      });
    } catch (e){
      print('Error adding product: $e');
    }
  }

  Future<void> updateProduct(Product product) async{
    try {
      await _productCollection.doc(product.id).update({
        'Name': product.Name,
        'Weight': product.Weight,
        'Calories': product.Calories,
        'Carbohydrates': product.Carbohydrates,
        'Fat': product.Fat,
        'Protein': product.Protein,
        'Sugar': product.Sugar,
        'ModifiedDate': product.ModifiedDate,
      });
    } catch (e){
      print('Error updating product: $e');
    }
  }

  Future<void> deleteProduct(String productId) async{
    try {
      await _productCollection.doc(productId).delete();
    } catch (e){
      print('Error deleting product: $e');
    }
  }
}