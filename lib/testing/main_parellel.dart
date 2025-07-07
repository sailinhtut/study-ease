// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:in_app_purchase_android/billing_client_wrappers.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';
// import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
// import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

// class SecondApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: MainPage());
//   }
// }

// class MainPage extends StatefulWidget {
//   const MainPage({super.key});

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   final appPurchase = InAppPurchase.instance;
//   bool isAvailable = false;
//   List<ProductDetails> availableProducts = [];
//   List<PurchaseDetails> boughtProuducts = [];

//   Future<void> init() async {
//     isAvailable = await appPurchase.isAvailable();

//     if (isAvailable) {
//       final productResponse = await appPurchase
//           .queryProductDetails({"task_pen", "soak_pen", "sliver"});
//       availableProducts = productResponse.productDetails;
//       print(
//           "output : Response Products ${productResponse.productDetails.length}");

//       appPurchase.purchaseStream.listen((data) {
//         boughtProuducts = data;

//         setState(() {});
//       });
//     }

//     setState(() {});
//   }

//   Future<void> useConsume(PurchaseDetails purchase) async {
//     if (Platform.isAndroid) {
//       final response = await appPurchase
//           .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>()
//           .consumePurchase(purchase);
//       print("output : Debug Message ${response.debugMessage}");
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     init();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Premium Purchase"),
//           actions: [
//             IconButton(
//               icon: Icon(Icons.refresh),
//               onPressed: () async {
//                 init();
//               },
//             ),
//             IconButton(
//               icon: Text("Restore"),
//               onPressed: () async {
//                 await appPurchase.restorePurchases();
//                 await init();
//                 setState(() {});
//               },
//             )
//           ],
//         ),
//         body: SingleChildScrollView(
//             padding: const EdgeInsets.all(10),
//             child: Column(
//               children: [
//                 Text("The Products You Can Buy From Brighter Life"),
//                 10.height,
//                 ...availableProducts.map((e) => Card(
//                       child: InkWell(
//                         splashFactory: InkRipple.splashFactory,
//                         onTap: () async {
//                           final para = PurchaseParam(productDetails: e);
//                           final succeed = await appPurchase.buyConsumable(
//                               purchaseParam: para, autoConsume: false);

//                           if (succeed) {
//                             toast("Purchase Succeed");
//                             print("output : Pavement Succeed");
//                           }
//                           await init();
//                         },
//                         borderRadius: radius(5),
//                         child: ListTile(
//                           title: Text(e.title),
//                           subtitle: Text(e.description),
//                           trailing: Text(e.price.toString()),
//                         ),
//                       ),
//                     )),
//                 20.height,
//                 Text("The Products You Bought"),
//                 10.height,
//                 ...boughtProuducts.map((e) => Card(
//                       child: InkWell(
//                         splashFactory: InkRipple.splashFactory,
//                         onTap: () async {
//                           await useConsume(e);
//                           await init();
//                           setState(() {});
//                         },
//                         child: ListTile(title: Text(e.productID)),
//                       ),
//                     ))
//               ],
//             )));
//   }
// }
