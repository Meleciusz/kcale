import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kcale/products/bloc/bloc.dart';
import 'package:kcale/products/view/product_list_screen.dart';
import 'package:product_repository/service/firestore_service.dart';
import 'authorization/app/bloc_observer.dart';
import 'authorization/app/view/app.dart';
import 'package:provider/provider.dart';


/*
 * Main description:
This is main function, where widgets, observers, blocs and repositories are initialized
 */
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = const AppBlocObserver();

  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        BlocProvider(
        create: (context) {
         final bloc = ProductBloc(productRepository: FirestoreProductService());
        bloc.add(LoadProducts()); // Wywołanie wstępne
        return bloc;
        },
         child: ProductListScreen(),
        )
      ],
      child: const App(),
    ),
  );
}