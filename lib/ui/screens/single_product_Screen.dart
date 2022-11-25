import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:traidbiz/controller/BottomNavController.dart';
import 'package:traidbiz/helper/Helpers.dart';
import 'package:traidbiz/models/PopularProduct.dart';
import 'package:traidbiz/repositories/get_update_cart_repository.dart';
import 'package:traidbiz/res/theme/theme.dart';
import 'package:traidbiz/ui/screens/item/ItemVariationBottomSheet.dart';
import 'package:traidbiz/ui/widget/common_button.dart';
import 'package:traidbiz/ui/widget/common_widget.dart';
import 'package:traidbiz/utils/ApiConstant.dart';

import '../../res/app_assets.dart';

class SingleProductScreen extends StatefulWidget {
  const SingleProductScreen({Key? key}) : super(key: key);

  @override
  SingleProductScreenState createState() => SingleProductScreenState();
}

class SingleProductScreenState extends State<SingleProductScreen> {
  bool value = false;
  int productQuantity = 1;

  final bottomNavController = Get.put(BottomNavController());
  late ModelProduct model;
  @override
  void initState() {
    super.initState();

    bottomNavController.getData();
    model = Get.arguments[0];
  }

  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;
    print('object is here' + model.storeName.toString());
    print('rating is is is is si si ' + model.averageRating.toString());
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage(
          AppAssets.singleProductShapeBg,
        ),
        alignment: Alignment.topRight,
        fit: BoxFit.cover,
      )),
      child: Scaffold(
          bottomSheet: Container(
            alignment: Alignment.center,
            height: 88,
            color: Colors.transparent,
            child: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 5,
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: (model.manageStock.toString() != "1")
                          ? CommonButton(
                              buttonHeight: 6.5,
                              buttonWidth: 75,
                              text: 'ADD TO CART',
                              onTap: () {
                                if (model.type.toString() == "simple") {
                                  ++bottomNavController.cartBadgeCount.value;
                                  getUpdateCartData(context, model.id, 1)
                                      .then((value) {
                                    if (value.status) {
                                      bottomNavController.getData();
                                      Get.back();
                                      Helpers.createSnackBar(
                                          context, value.message.toString());
                                    } else {}
                                    return null;
                                  });
                                } else {
                                  _getVariationBottomSheet(model);
                                }
                              },
                              mainGradient: AppTheme.primaryGradientColor)
                          : ((model.stockQuantity.toString() != "0")
                              ? CommonButton(
                                  buttonHeight: 6.5,
                                  buttonWidth: 75,
                                  text: 'ADD TO CART',
                                  onTap: () {
                                    if (model.type.toString() == "simple") {
                                      ++bottomNavController
                                          .cartBadgeCount.value;
                                      getUpdateCartData(context, model.id, 1)
                                          .then((value) {
                                        if (value.status) {
                                          bottomNavController.getData();
                                          Get.back();
                                          Helpers.createSnackBar(context,
                                              value.message.toString());
                                        } else {}
                                        return null;
                                      });
                                    } else {
                                      _getVariationBottomSheet(model);
                                    }
                                  },
                                  mainGradient: AppTheme.primaryGradientColor)
                              : CommonButton(
                                  buttonHeight: 6.5,
                                  buttonWidth: 75,
                                  text: 'Out of Stock',
                                  onTap: () {
                                    showToast(
                                        "we will notify you when product come back in stock");
                                  },
                                  mainGradient: AppTheme.primaryGradientColor)),
                    )
                  ],
                )),
          ),
          appBar: backAppBar(""),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  addHeight(4),
                  Align(
                    alignment: Alignment.center,
                   /* child: Hero(
                      tag: model.imageUrl,
                      child: Material(
                        borderRadius: BorderRadius.circular(100),
                        elevation: 3,
                        child: SizedBox(
                          height: 155,
                          width: 155,
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                            child: CachedNetworkImage(
                              imageUrl: model.imageUrl,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                  height: 4,
                                  width: 4,
                                  child: const CircularProgressIndicator(
                                    color: AppTheme.primaryColor,
                                  )),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                    ),*/
                    child: Hero(
                      tag: model.imageUrl,
                      child: Material(
                        borderRadius: BorderRadius.circular(100),
                        elevation: 3,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.width*0.6,
                          width: MediaQuery.of(context).size.height,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(4)),
                            child: CachedNetworkImage(
                              imageUrl: model.imageUrl,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                  height: 4,
                                  width: 4,
                                  child: const CircularProgressIndicator(
                                    color: AppTheme.primaryColor,
                                  )),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  addHeight(8),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 32.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xfff3f3f3),
                    ),
                    child: Column(
                      children: [
                        Hero(
                          tag: model.name.toString(),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              model.name,
                              style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textColorDarkGreyDK),
                            ),
                          ),
                        ),
                        addHeight(12.0),
                        Row(
                          children: [
                            const Text(
                              'From: ',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  height: 1.5,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey),
                            ),
                            addWidth(10),
                            Text(
                              model.currencySymbol + model.price,
                              style: const TextStyle(
                                  fontSize: 20.0,
                                  height: 1.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primaryColor),
                            ),
                          ],
                        ),
                        addHeight(12.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Sold by: ',
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    height: 1.5,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: model.storeName.toString(),
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          height: 1.5,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.textColorSkyBLue)),
                                ],
                              ),
                            ),
                            RatingBar.builder(
                              initialRating:
                                  double.parse(model.averageRating.toString()),
                              minRating: 0,
                              itemSize: 24,
                              ignoreGestures: true,
                              // direction: Axis.horizontal,
                              itemCount:
                                  double.parse(model.averageRating.toString())
                                      .toInt(),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: AppTheme.primaryColor,
                              ),
                              onRatingUpdate: (rating) {
                                // debugPrint(rating.toString());
                              },
                            ),
                          ],
                        ),
                        addHeight(12.0),
                        Row(
                          children: [
                            const Text(
                              'Qty:',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  height: 1.5,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey),
                            ),
                            addWidth(10),
                            (model.manageStock.toString() == "1" ||
                                    model.manageStock == true)
                                ? Text(
                                    (model.stockQuantity.toString() != "0")
                                        ? model.stockQuantity.toString()
                                        : 'Out of Stock',
                                    style: const TextStyle(
                                        fontSize: 20.0,
                                        height: 1.5,
                                        color: AppTheme.textColorSkyBLue),
                                  )
                                : Text(
                                    model.stockQuantity.toString(),
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        height: 1.5,
                                        color: AppTheme.textColorSkyBLue),
                                  ),
                          ],
                        ),
                        addHeight(20),
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Policies',
                          style: TextStyle(
                              fontSize: 20.0,
                              height: 1.5,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textColorDarkGreyDK),)),
                        addHeight(8),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: (){
                                  Get.defaultDialog(
                                    title: "Shipping Policy",
                                    content: Html(
                                      data: model.shipping_policy.toString(),
                                    )
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text('1. Shipping Policy',style: TextStyle(decoration: TextDecoration.underline
                                    ),),
                                    Icon(Icons.arrow_forward,size: 16,)
                                  ],
                                ),
                              ),
                              addHeight(8),
                              InkWell(
                                onTap: (){
                                  Get.defaultDialog(
                                      title: "Refund Policy",
                                      content: Html(
                                        data: model.refund_policy.toString(),
                                      )
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text('2. Refund Policy',style: TextStyle(decoration: TextDecoration.underline
                                    ),),
                                    Icon(Icons.arrow_forward,size: 16,)
                                  ],
                                ),
                              ),
                              addHeight(8),
                              InkWell(
                                onTap: (){
                                  Get.defaultDialog(
                                      title: "Cancellation Policy",
                                      content: Html(
                                        data: model.cancellation_policy.toString(),
                                      )
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text('3. Cancellation Policy',style: TextStyle(decoration: TextDecoration.underline
                                    ),),
                                    Icon(Icons.arrow_forward,size: 16,)
                                  ],
                                ),
                              ),


                            ],
                          ),
                        ),
                        addHeight(12),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Description',
                            style: TextStyle(
                                fontSize: 20.0,
                                height: 1.5,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textColorDarkGreyDK),
                          ),
                        ),
                        addHeight(12),
                        model.description.toString().isEmpty
                            ? const SizedBox(
                                height: 170,
                              )
                            : FittedBox(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Html(
                                    data: model.description.toString(),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  _getVariationBottomSheet(ModelProduct popularProduct) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return ItemVariationBottomSheet(model);
        });
  }
// return SingleChildScrollView(
//   scrollDirection: Axis.vertical,
//   child: Container(
//       color: Colors.white,
//       padding:
//           const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             popularProduct.name,
//             style: const TextStyle(
//                 fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           addHeight(8),
//           Text(
//             popularProduct.description,
//             style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey),
//           ),
//           const Divider(),
//           addHeight(8),
//           ListView.builder(
//               itemCount: popularProduct.attributeData.length,
//               //snapshot.data!.data[0].attributes.length,
//               shrinkWrap: true,
//               itemBuilder: (BuildContext context, index) {
//                 return attributeList(
//                     popularProduct.attributeData[index],
//                     popularProduct.attributeData,
//                     index,
//                     selectedAttributes);
//               }),
//           addHeight(4),
//           addHeight(8),
//           Row(
//             children: [
//               Container(
//                 height: MediaQuery.of(context).size.height * 0.06,
//                 decoration: BoxDecoration(
//                     borderRadius:
//                         const BorderRadius.all(Radius.circular(5.0)),
//                     border: Border.all(color: AppTheme.primaryColor)),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         getUpdateCartVariationData(
//                                 context,
//                                 popularProduct.id,
//                                 '$productQuantity',
//                                 selectedAttributes.value)
//                             .then((value) {
//                           showToast(value.message);
//                           if (value.status) {
//                             decrement();
//                           }
//                           return null;
//                         });
//                       },
//                       child: Container(
//                           padding: const EdgeInsets.only(
//                               top: 4, bottom: 4, left: 8),
//                           child: const Icon(
//                             Icons.remove,
//                             size: 16,
//                             color: Colors.grey,
//                           )),
//                     ),
//                     addWidth(10),
//                     Container(
//                         height: MediaQuery.of(context).size.height,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 8),
//                         color: const Color(0xffffe6e7),
//                         child: Center(
//                           child: Text(
//                             '$productQuantity',
//                             style: const TextStyle(
//                                 color: AppTheme.primaryColor,
//                                 fontSize: 16.0,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         )),
//                     addWidth(10),
//                     InkWell(
//                       onTap: () {
//                         var attributes = '';
//                         getUpdateCartVariationData(
//                                 context,
//                                 popularProduct.id,
//                                 '$productQuantity',
//                                 attributes)
//                             .then((value) {
//                           showToast(value.message);
//                           if (value.status) {
//                             increment();
//                           }
//                           return null;
//                         });
//                       },
//                       child: Container(
//                           padding: const EdgeInsets.only(
//                               top: 4, bottom: 4, right: 8),
//                           child: const Icon(
//                             Icons.add,
//                             size: 16,
//                             color: Colors.grey,
//                           )),
//                     ),
//                   ],
//                 ),
//               ),
//               addWidth(10),
//               Expanded(
//                 child: CommonButton(
//                     buttonHeight: 6.5,
//                     buttonWidth: 60,
//                     text: 'ADD TO CART',
//                     onTap: () {
//                       getUpdateCartVariationData(
//                               context,
//                               popularProduct.id,
//                               '$productQuantity',
//                               selectedAttributes.value)
//                           .then((value) {
//                         showToast(value.message);
//                         if (value.status) {
//                           ++bottomNavController.cartBadgeCount.value;
//                         }
//                         return null;
//                       });
//                     },
//                     mainGradient: AppTheme.primaryGradientColor),
//               )
//             ],
//           ),
//         ],
//       )),
// );
  //
  // attributeList(AttributeData attributeData, List<AttributeData> attributeDatas,
  //     int parentIndex, selectedAttributes) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         attributeData.name,
  //         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //       ),
  //       addHeight(4),
  //       const Text(
  //         'Please select any one option',
  //         style: TextStyle(
  //             fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
  //       ),
  //       addHeight(10),
  //       ListView.builder(
  //           physics: const NeverScrollableScrollPhysics(),
  //           itemCount: attributeData.items.length,
  //           shrinkWrap: true,
  //           itemBuilder: (BuildContext context, index) {
  //             return attributeOptionList(attributeData.items[index], index,
  //                 attributeDatas, parentIndex, selectedAttributes);
  //           }),
  //     ],
  //   );
  // }
  //
  // increment() {
  //   setState(() {
  //     productQuantity++;
  //   });
  // }
  //
  // decrement() {
  //   setState(() {
  //     productQuantity--;
  //   });
  // }
  //
  // attributeOptionList(Items item, int index, List<AttributeData> attributeDatas,
  //     int parentIndex, selectedAttributes) {
  //   return Obx(() {
  //     return Column(
  //       children: [
  //         InkWell(
  //           onTap: () {
  //             setState(() {
  //               selectedAttributes.value[parentIndex].termId = item.termId;
  //               selectedAttributes.value[parentIndex].currentIndex!.value =
  //                   index.toString();
  //             });
  //           },
  //           child: Padding(
  //             padding: const EdgeInsets.all(10.0),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   item.name,
  //                   style: const TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 Icon(
  //                   selectedAttributes.value[parentIndex].currentIndex!.value
  //                               .toString() ==
  //                           index.toString()
  //                       ? Icons.radio_button_checked
  //                       : Icons.radio_button_unchecked,
  //                   color: AppTheme.primaryColor,
  //                 )
  //               ],
  //             ),
  //           ),
  //         )
  //       ],
  //     );
  //   });
  // }
}
