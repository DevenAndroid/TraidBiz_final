import 'package:cached_network_image/cached_network_image.dart';
import 'package:dinelah/controller/BottomNavController.dart';
import 'package:dinelah/controller/WishListController.dart';
import 'package:dinelah/models/PopularProduct.dart';
import 'package:dinelah/repositories/add_to_wishlist_repository.dart';
import 'package:dinelah/repositories/get_update_cart_repository.dart';
import 'package:dinelah/res/theme/theme.dart';
import 'package:dinelah/routers/my_router.dart';
import 'package:dinelah/ui/screens/item/ItemVariationBottomSheet.dart';
import 'package:dinelah/ui/widget/common_widget.dart';
import 'package:dinelah/utils/ApiConstant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemProduct extends StatefulWidget {
  List<ModelProduct> popularProducts;
  int index;
  double itemHeight;
  final controller;
  bool isWishList;
  ItemProduct(this.controller, this.popularProducts, this.index,
      this.itemHeight, this.isWishList,
      {Key? key})
      : super(key: key);

  @override
  ItemProductState createState() => ItemProductState();
}

class ItemProductState extends State<ItemProduct> {
  var attributeSize;
  var attributeColor;

  final _wishListController = Get.put(WishListController());
  final bottomNavController = Get.put(BottomNavController());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("product type and id::" +
            widget.popularProducts[widget.index].id.toString() +
            '\n' +
            widget.popularProducts[widget.index].type.toString());

        if (widget.popularProducts[widget.index].type.toString() == "simple") {
          Get.toNamed(MyRouter.singleProductScreen,
              arguments: [widget.popularProducts[widget.index]]);
        } else if (widget.popularProducts[widget.index].type.toString() ==
            "variable") {
          Get.toNamed(MyRouter.singleProductScreen,
              arguments: [widget.popularProducts[widget.index]]);
        } else {
          Get.toNamed(MyRouter.bookingProductScreen,
              arguments: [widget.popularProducts[widget.index].id]);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 0.5),
                blurRadius: 0.5,
              ),
            ]),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                addHeight(widget.itemHeight / 24),
                Align(
                  alignment: Alignment.center,
                  child: Hero(
                    tag: widget.popularProducts[widget.index].imageUrl,
                    child: Material(
                      borderRadius: BorderRadius.circular(100),
                      elevation: 3,
                      child: SizedBox(
                        height: widget.itemHeight / 2.1,
                        width: widget.itemHeight / 2.1,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                          child: CachedNetworkImage(
                            imageUrl:
                                widget.popularProducts[widget.index].imageUrl,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.fill,
                                  // colorFilter: ColorFilter.mode(
                                  //     Colors.red,
                                  //     BlendMode.colorBurn
                                  // )
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Container(
                                height: 4,
                                width: 4,
                                child: CircularProgressIndicator(
                                  color: AppTheme.primaryColor,
                                )),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          // Image.network(
                          //   widget.popularProducts[widget.index].imageUrl,
                          //   fit: BoxFit.fill,
                          //   loadingBuilder: (BuildContext context, Widget child,
                          //       ImageChunkEvent? loadingProgress) {
                          //     if (loadingProgress == null) {
                          //       return child;
                          //     }
                          //     return Center(
                          //       child: Padding(
                          //         padding: const EdgeInsets.only(
                          //             top: 10.0, bottom: 10.0),
                          //         child: CircularProgressIndicator(
                          //           color: AppTheme.primaryColor,
                          //           value: loadingProgress.expectedTotalBytes !=
                          //                   null
                          //               ? loadingProgress
                          //                       .cumulativeBytesLoaded /
                          //                   loadingProgress.expectedTotalBytes!
                          //               : null,
                          //         ),
                          //       ),
                          //     );
                          //   },
                          // ),
                        ),
                      ),
                    ),
                  ),
                ),
                addHeight(widget.itemHeight / 14),
                Flexible(
                  child: Hero(
                    tag: widget.popularProducts[widget.index].name.toString(),
                    child: Text(
                      widget.popularProducts[widget.index].name.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppTheme.textColorDarkGreyDK,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                addHeight(
                  widget.itemHeight / 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.popularProducts[widget.index].currencySymbol
                              .toString() +
                          widget.popularProducts[widget.index].price.toString(),
                      style: const TextStyle(
                          color: AppTheme.addToCartColorDK,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        // print(popularProducts[index].type.toString());
                        if (widget.popularProducts[widget.index].type
                                .toString() ==
                            "simple") {
                          getUpdateCartData(context,
                                  widget.popularProducts[widget.index].id, 1)
                              .then((value) {
                            if (value.status) {
                              // ++bottomNavController.cartBadgeCount.value;
                              bottomNavController.getData();
                              showToast(value.message.toString());
                            } else {}
                            return;
                          });
                        } else if (widget.popularProducts[widget.index].type
                                .toString() ==
                            "variable") {
                          _getVariationBottomSheet(
                              widget.popularProducts[widget.index]);
                        } else if (widget.popularProducts[widget.index].type
                                .toString() ==
                            "booking") {
                          Get.toNamed(MyRouter.bookingProductScreen,
                              arguments: [
                                widget.popularProducts[widget.index].id
                              ]);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppTheme.addToCartColorDK,
                        ),
                        child: Icon(
                          Icons.add,
                          size: widget.itemHeight / 20,
                          color: AppTheme.colorWhite,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Positioned(
              right: 0,
              child: InkWell(
                onTap: () {
                  // setState(() {
                  widget.popularProducts[widget.index].isInWishlist =
                      !widget.popularProducts[widget.index].isInWishlist;
                  // });
                  addToWishlist(context,
                          widget.popularProducts[widget.index].id.toString())
                      .then((value) {
                    if (value.status) {
                      _wishListController.getYourWishList();
                      setState(() {
                        // widget.popularProducts.removeAt(widget.index);
                      });
                      showToast(value.message);
                    }
                    return null;
                  });

                  if (widget.isWishList) {
                    // widget.popularProducts.removeAt(widget.index);
                    // if (widget.controller.isInWishlist) {
                    _wishListController.getYourWishList();
                    widget.controller
                        .getWishlistData()
                        .then((value) => widget.controller.model.value = value);
                  }
                },
                child: Icon(
                  widget.popularProducts[widget.index].isInWishlist
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: AppTheme.primaryColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _getVariationBottomSheet(ModelProduct popularProduct) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return ItemVariationBottomSheet(popularProduct);
        });
  }
}
