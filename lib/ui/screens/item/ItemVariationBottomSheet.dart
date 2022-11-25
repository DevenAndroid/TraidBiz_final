import 'package:traidbiz/controller/BottomNavController.dart';
import 'package:traidbiz/models/ModelAllAttrubutes.dart';
import 'package:traidbiz/models/PopularProduct.dart';
import 'package:traidbiz/repositories/get_update_cart_repository.dart';
import 'package:traidbiz/res/theme/theme.dart';
import 'package:traidbiz/ui/widget/common_button.dart';
import 'package:traidbiz/ui/widget/common_widget.dart';
import 'package:traidbiz/utils/ApiConstant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class ItemVariationBottomSheet extends StatefulWidget {
  final ModelProduct popularProducts;
  const ItemVariationBottomSheet(this.popularProducts, {Key? key})
      : super(key: key);

  @override
  ItemVariationBottomSheetState createState() =>
      ItemVariationBottomSheetState();
}

class ItemVariationBottomSheetState extends State<ItemVariationBottomSheet> {
  int productQuantity = 1;

  final bottomNavController = Get.put(BottomNavController());
  var selectedAttributes = RxList<ModelAllAttributesReq>.empty();
  @override
  Widget build(BuildContext context) {
    ModelProduct popularProduct = widget.popularProducts;
    if (selectedAttributes.value.isEmpty) {
      for (var item in popularProduct.attributeData) {
        // for (var i = 0; i < item.items.length;) {
        selectedAttributes.value.add(ModelAllAttributesReq(
            item.name.toString(), '0'.obs, item.items[0].termId));
        // }
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
          margin: EdgeInsets.only(top: 10),
          // height: MediaQuery.of(context).size.height * 0.8,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      popularProduct.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  InkWell(
                    onTap: () => Get.back(),
                    child: const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.clear)),
                  ),
                ],
              ),
              // description removed by dk
              // Html(
              //   data: popularProduct.description,
              // ),
              const Divider(),
              addHeight(8),
              ListView.builder(
                  itemCount: popularProduct.attributeData.length,
                  //snapshot.data!.data[0].attributes.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, index) {
                    return attributeList(
                        popularProduct.attributeData[index],
                        popularProduct.attributeData,
                        index,
                        selectedAttributes);
                  }),
              addHeight(4),
              addHeight(8),
              Row(
                children: [
                  // Container(
                  //   height: MediaQuery.of(context).size.height * 0.06,
                  //   decoration: BoxDecoration(
                  //       borderRadius:
                  //           const BorderRadius.all(Radius.circular(5.0)),
                  //       border: Border.all(color: Colors.grey)),
                  //   // child: Row(
                  //   //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   //   children: [
                  //   //     InkWell(
                  //   //       onTap: () {
                  //   //         decrement();
                  //   //         getUpdateCartVariationData(
                  //   //                 context,
                  //   //                 popularProduct.id,
                  //   //                 '$productQuantity',
                  //   //                 selectedAttributes.value)
                  //   //             .then((value) {
                  //   //           showToast(value.message);
                  //   //           if (value.status) {
                  //   //             decrement();
                  //   //           }
                  //   //           return null;
                  //   //         });
                  //   //       },
                  //   //       child: Container(
                  //   //           padding: const EdgeInsets.only(
                  //   //               top: 4, bottom: 4, left: 8),
                  //   //           child: const Icon(
                  //   //             Icons.remove,
                  //   //             size: 16,
                  //   //             color: Colors.grey,
                  //   //           )),
                  //   //     ),
                  //   //     addWidth(10),
                  //   //     // Container(
                  //   //     //     height: MediaQuery.of(context).size.height,
                  //   //     //     padding: const EdgeInsets.symmetric(
                  //   //     //         horizontal: 8, vertical: 8),
                  //   //     //     // color: const Color(0xffffe6e7),
                  //   //     //     child: Center(
                  //   //     //       child: Text(
                  //   //     //         '$productQuantity',
                  //   //     //         style: const TextStyle(
                  //   //     //             color: AppTheme.primaryColor,
                  //   //     //             fontSize: 16.0,
                  //   //     //             fontWeight: FontWeight.bold),
                  //   //     //       ),
                  //   //     //     )),
                  //   //     addWidth(10),
                  //   //     InkWell(
                  //   //       onTap: () {
                  //   //         increment();
                  //   //         getUpdateCartVariationData(
                  //   //                 context,
                  //   //                 popularProduct.id,
                  //   //                 '$productQuantity',
                  //   //                 selectedAttributes.value)
                  //   //             .then((value) {
                  //   //           showToast(value.message);
                  //   //           if (value.status) {
                  //   //             increment();
                  //   //           }
                  //   //           return null;
                  //   //         });
                  //   //       },
                  //   //       child: Container(
                  //   //           padding: const EdgeInsets.only(
                  //   //               top: 4, bottom: 4, right: 8),
                  //   //           child: const Icon(
                  //   //             Icons.add,
                  //   //             size: 16,
                  //   //             color: Colors.grey,
                  //   //           )),
                  //   //     ),
                  //   //   ],
                  //   // ),
                  // ),
                  // addWidth(10),
                  Expanded(
                    child: CommonButton(
                        buttonHeight: 6.5,
                        buttonWidth: 60,
                        text: 'ADD TO CART',
                        onTap: () {
                          getUpdateCartVariationData(context, popularProduct.id,
                                  '1', selectedAttributes.value)
                              .then((value) {
                            showToast(value.message);
                            if (value.status) {
                              ++bottomNavController.cartBadgeCount.value;
                              bottomNavController.getData();
                              Get.back();
                            }
                            return null;
                          });
                        },
                        mainGradient: AppTheme.primaryGradientColor),
                  )
                ],
              ),
            ],
          )),
    );
  }

  attributeList(AttributeData attributeData, List<AttributeData> attributeDatas,
      int parentIndex, selectedAttributes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          attributeData.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        addHeight(4),
        const Text(
          'Please select any one option',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        addHeight(10),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: attributeData.items.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, index) {
              return attributeOptionList(attributeData.items[index], index,
                  attributeDatas, parentIndex, selectedAttributes);
            }),
      ],
    );
  }

  increment() {
    setState(() {
      productQuantity++;
    });
  }

  decrement() {
    setState(() {
      productQuantity--;
    });
  }

  attributeOptionList(Items item, int index, List<AttributeData> attributeDatas,
      int parentIndex, selectedAttributes) {
    return Obx(() {
      return Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                selectedAttributes.value[parentIndex].termId = item.termId;
                selectedAttributes.value[parentIndex].currentIndex!.value =
                    index.toString();
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    selectedAttributes.value[parentIndex].currentIndex!.value
                                .toString() ==
                            index.toString()
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: AppTheme.primaryColor,
                  )
                ],
              ),
            ),
          )
        ],
      );
    });
  }
}
