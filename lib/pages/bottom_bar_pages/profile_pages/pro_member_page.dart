// ignore_for_file: library_private_types_in_public_api
import 'dart:convert';

import 'package:english_learn/pages/bottom_bar_pages/profile_pages/iyzco/tc_view.dart';
import 'package:english_learn/service/package_add_service.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:english_learn/const/colors.dart';
import 'package:english_learn/model/packs_model.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:pay/pay.dart';
import '../../../const/const.dart';
import '../../../widgets/selected_container.dart';
import 'iyzco/webview.dart';

// Future<PacksModel> getPacks() async {
//   var response = await http.post(
//     Uri.parse("https://vocopus.com/api/v1/getPacks"),
//     body: {
//       "apiToken": apiToken,
//     },
//   );

//   if (response.statusCode == 200) {
//     return PacksModel.fromJson(jsonDecode(response.body));
//   } else {
//     throw Exception('Kayıt Başarısız');
//   }
// }

// List<PaymentItem> paymentItems = [
//   const PaymentItem(
//     label: 'Toplam',
//     amount: '0',
//     status: PaymentItemStatus.final_price,
//   )
// ];

// class ProMemberPage extends StatefulWidget {
//   const ProMemberPage({super.key});

//   @override
//   _ProMemberPageState createState() => _ProMemberPageState();
// }

// class _ProMemberPageState extends State<ProMemberPage> {
//   bool isSelected = true;
//   bool isSelected2 = false;

//   @override
//   void initState() {
//     super.initState();
//   }

//   void onGooglePayResult(paymentResult) {
//     debugPrint(paymentResult.toString());
//   }

//   void onApplePayResult(paymentResult) {
//     debugPrint(paymentResult.toString());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: colorBlue,
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             height: 300,
//             padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//             color: Colors.white,
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 12,
//                 ),
//                 Text(
//                   "Premium olarak uygulamanın \ntadını çıkar",
//                   style: Theme.of(context)
//                       .textTheme
//                       .titleLarge
//                       ?.copyWith(fontWeight: FontWeight.w600, color: colorBlue),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(
//                   height: 16,
//                 ),
//                 Image.asset(
//                   "assets/image/premium.jpeg",
//                   fit: BoxFit.cover,
//                   height: 200,
//                 )
//               ],
//             ),
//           ),
//           Expanded(
//             child: Container(
//               width: double.infinity,
//               color: Colors.white,
//               child: FutureBuilder<PacksModel>(
//                   future: getPacks(),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       if (snapshot.data?.response?.length == null) {
//                         return Text("Daha Sonra Tekrar Deneyin");
//                       } else if (snapshot.data?.response?.length == 0)
//                         return Text("Daha Sonra Tekrar Deneyin");
//                       else {
//                         return Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 16, vertical: 8),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   SelectedConteiner(
//                                     isMon: true,
//                                     planTitle:
//                                         snapshot.data?.response?[0].name ?? "",
//                                     price: double.parse(
//                                         snapshot.data?.response?[0].price ??
//                                             "0"),
//                                     selected: isSelected2,
//                                     onPressed: () => setState(() {
//                                       isSelected = false;
//                                       isSelected2 = true;
//                                       setState(() {
//                                         paymentItems = [
//                                           const PaymentItem(
//                                             label: 'Toplam',
//                                             amount: '300',
//                                             status:
//                                                 PaymentItemStatus.final_price,
//                                           )
//                                         ];
//                                       });
//                                     }),
//                                   ),
//                                   SelectedConteiner(
//                                     isMon: false,
//                                     planTitle:
//                                         snapshot.data?.response?[1].name ?? "",
//                                     price: double.parse(
//                                         snapshot.data?.response?[1].price ??
//                                             "0"),
//                                     selected: isSelected,
//                                     onPressed: () => setState(() {
//                                       isSelected = true;
//                                       isSelected2 = false;
//                                     }),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 15),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 16, vertical: 8),
//                               child: SizedBox(
//                                   width: double.infinity,
//                                   child: ElevatedButton(
//                                       style: ElevatedButton.styleFrom(
//                                           backgroundColor: colorBlue),
//                                       onPressed: () {
//                                         Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (context) => TCView(
//                                                 isSelected: isSelected,
//                                               ),
//                                             ));
//                                         // context.navigateToPage(IyzcoWebView(
//                                         //   url:
//                                         //       'https://vocopus.com/payments/packet_buy?id=$configID&packet_id=${isSelected ? 1 : 2}',
//                                         // ));
//                                       },
//                                       child: const Text("Devam Et"))),
//                             ),
//                           ],
//                         );
//                       }
//                     } else {
//                       return Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }
//                   }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class ProMemberPage extends StatefulWidget {
  @override
  _ProMemberPageState createState() => _ProMemberPageState();
}

class _ProMemberPageState extends State<ProMemberPage> {
  bool _isAvailable = false;
  List<ProductDetails> _products = [];
  final String _productId = 'aylik_10'; // Ürün ID'nizi buraya girin
  final String _productId2 = 'yillik_10'; // Ürün ID'nizi buraya girin
  bool isLoading1 = false;
  bool isLoading2 = false;

  @override
  void initState() {
    super.initState();
    _initialize();
    _listenToPurchaseUpdates();
  }

  void _initialize() async {
    final bool isAvailable = await InAppPurchase.instance.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
      });
      return;
    }

    final ProductDetailsResponse response = await InAppPurchase.instance
        .queryProductDetails({_productId, _productId2});

    if (response.notFoundIDs.isNotEmpty) {
      // ID'ler bulunamadı hatası
    }

    setState(() {
      _isAvailable = isAvailable;
      _products = response.productDetails;
    });
  }

  void _listenToPurchaseUpdates() {
    final Stream purchaseUpdates = InAppPurchase.instance.purchaseStream;
    purchaseUpdates.listen((purchases) {
      _handlePurchaseUpdates(purchases);
    });
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) {
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        if (purchaseDetails.productID == "aylik_10") {
          addPackageService("1");
        } else if (purchaseDetails.productID == "yillik_10")
          addPackageService("2");
        print("Kemal");
        // Başarılı satın alma işlemini işleyin
        if (purchaseDetails.pendingCompletePurchase) {
          InAppPurchase.instance.completePurchase(purchaseDetails);
          print("Emre");
        }
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        InAppPurchase.instance.completePurchase(purchaseDetails);

        // Satın alma işleminde hata oluştu
      }
      InAppPurchase.instance.completePurchase(purchaseDetails);

      isLoading2 = false;
      isLoading1 = false;

      // Diğer durumları da işleyebilirsiniz
    });
  }

  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: prod,
    );

    InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isAvailable
          ? Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 300,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Premium olarak uygulamanın \ntadını çıkar",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600, color: colorBlue),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Image.asset(
                        "assets/image/premium.jpeg",
                        fit: BoxFit.cover,
                        height: 200,
                      )
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(_products.length, (index) {
                    final product = _products[index];

                    if (index == 0)
                      return SelectedConteiner(
                        isMon: true,
                        planTitle: product.title,
                        price: product.rawPrice,
                        selected: true,
                        onPressed: () => _buyProduct(product),
                      );

                    return SelectedConteiner(
                        isMon: true,
                        planTitle: product.title,
                        price: product.rawPrice,
                        selected: true,
                        onPressed: () {
                          setState(() {
                            isLoading2 = true;
                          });
                          print(isLoading2);
                          _buyProduct(product);
                        });
                  }),
                ),
                SizedBox(
                  height: 12,
                ),
                Center(
                  child: Text(
                    "Premium ol ve uygulamayı özgürce kullan. Tüm özelliklere ulaşabilir ve arkadaşlarınla kelime yarışması yapabilirsin",
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: colorBlue),
                  ),
                )
                // ListView.builder(
                //   shrinkWrap: true,
                //   physics: NeverScrollableScrollPhysics(),
                //   itemCount: _products.length,
                //   itemBuilder: (context, index) {
                //     final product = _products[index];
                //     return SelectedConteiner(
                //       isMon: true,
                //       planTitle: product.title,
                //       price: product.rawPrice,
                //       selected: true,
                //       onPressed: () => _buyProduct(product),
                //     );
                //     ListTile(
                //       title: Text(product.title),
                //       subtitle: Text(product.description),
                //       trailing: TextButton(
                //         child: Text(product.price),
                //         onPressed: () => _buyProduct(product),
                //       ),
                //     );
                //   },
                // ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
