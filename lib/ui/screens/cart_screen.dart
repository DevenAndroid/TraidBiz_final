import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traidbiz/controller/BottomNavController.dart';
import 'package:traidbiz/controller/CartController.dart';
import 'package:traidbiz/models/ModelGetCart.dart';
import 'package:traidbiz/res/theme/theme.dart';
import 'package:traidbiz/ui/widget/common_button.dart';
import 'package:traidbiz/utils/ApiConstant.dart';

import '../../helper/Helpers.dart';
import '../../repositories/get_cart_data_repository.dart';
import '../../repositories/get_update_cart_repository.dart';
import '../../res/app_assets.dart';
import '../../routers/my_router.dart';
import '../widget/common_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  final CartController _cartController = Get.put(CartController());
  final bottomNavController = Get.put(BottomNavController());

  @override
  void deactivate() {
    super.deactivate();
    _cartController.onClose();
  }

  @override
  void initState() {
    super.initState();
    getCartData().then((value) {
      _cartController.isDataLoading.value = true;
      _cartController.model.value = value;
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: RefreshIndicator(
          color: AppTheme.primaryColor,
          onRefresh: () async {
            _cartController.getData();
          },
          child: Obx(() {
            return _cartController.isDataLoading.value
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: _cartController.model.value.data!.items.isEmpty
                        ? Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppAssets.emptyCart,
                                height: 190,
                                width: 190,
                              ),
                              addHeight(16),
                              const Text(
                                'Your cart is empty',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor),
                              ),
                              const Text(
                                'Add something to make me happy :)',
                                style: TextStyle(
                                    height: 1.5,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey),
                              )
                            ],
                          ))
                        : Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                    itemCount: _cartController
                                        .model.value.data!.items.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return orderCard(
                                        _cartController.model.value.data!.items,
                                        index,
                                      );
                                    }),
                              ),
                              Positioned(
                                  bottom: 0,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          addHeight(15),
                                          _getPaymentDetails(
                                              'Subtotal:',
                                              _cartController.model.value.data!
                                                      .cartmeta.currencySymbol +
                                                  _cartController.model.value
                                                      .data!.cartmeta.subtotal),
                                          addHeight(16),
                                          _getPaymentDetails(
                                            'Tax and fee:',
                                            _cartController.model.value.data!
                                                    .cartmeta.currencySymbol +
                                                _cartController.model.value
                                                    .data!.cartmeta.totalTax
                                                    .toString(),
                                          ),
                                          addHeight(16),
                                          _getPaymentDetails(
                                              'Delivery:', _cartController.model.value.data!
                                              .cartmeta.shippingTotal),
                                          addHeight(16),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Total:',
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppTheme
                                                        .addToCartColorDK),
                                              ),
                                              Text(
                                                _cartController
                                                        .model
                                                        .value
                                                        .data!
                                                        .cartmeta
                                                        .currencySymbol +
                                                    _cartController.model.value
                                                        .data!.cartmeta.total
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          addHeight(24),
                                          CommonButton(
                                              buttonHeight: 6.5,
                                              buttonWidth: 100,
                                              text: 'CHECKOUT',
                                              onTap: () async {
                                                SharedPreferences pref = await SharedPreferences.getInstance();
                                                if (pref.getString('user') != null) {
                                                  Get.toNamed(
                                                      MyRouter.checkoutScreen,
                                                      arguments: [_cartController
                                                            .model
                                                            .value
                                                            .data!
                                                            .cartmeta
                                                            .currencySymbol,
                                                      ]);
                                                } else {
                                                  Get.toNamed(MyRouter.logInScreen);
                                                }
                                              },
                                              mainGradient: AppTheme
                                                  .primaryGradientColor),
                                          addHeight(10),
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                  )
                : const Center(
                    child: CircularProgressIndicator(
                    color: AppTheme.newprimaryColor,
                  ));
          }),
        ));
  }

  Widget orderCard(
    List<Items> items,
    index,
  ) {
    Items item = items[index];

    return InkWell(
      onTap: () {
        //Get.toNamed(MyRouter.singleProductScreen);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                borderRadius: BorderRadius.circular(50),
                elevation: 2,
                child: SizedBox(
                  height: 95,
                  width: 95,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    child: Image.network(
                      item.product!.imageUrl,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: CircularProgressIndicator(
                              color: AppTheme.primaryColor,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              addWidth(10),
              Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      addHeight(8),
                      Text(
                        item.product!.name,
                        style: const TextStyle(
                            color: AppTheme.textColorDarkBLue,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                      ),
                      addHeight(8),
                      Text(
                        '${item.product!.currencySymbol} ${item.product!.regularPrice}',
                        style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                      addHeight(8),
                      item.product!.type == 'booking'
                          ? Row(
                              children: [
                                Text(
                                  "Qty: ${item.quantity}",
                                  style: const TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    showToast("Cart Updated");
                                    if (kDebugMode) {
                                      print("tem.product!.id for -1${item.product!.id}");
                                    }
                                    getUpdateCartData(
                                            context, item.product!.id, '-1')
                                        .then((value) async {
                                      if (value.status) {
                                        if (item.quantity == 1) {
                                          items.removeAt(index);
                                        } else {
                                          item.quantity = item.quantity - 1;
                                        }
                                        setState(() {
                                          getCartData().then((value) =>
                                              _cartController.model.value =
                                                  value);
                                        });
                                      } else {
                                        showToast("minus is not working");
                                        Helpers.createSnackBar(
                                            context, value.message.toString());
                                      }
                                      return;
                                    });
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          color: AppTheme.iconSelectionClr,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: const Icon(
                                        Icons.remove,
                                        size: 16,
                                        color: Colors.white,
                                      )),
                                ),
                                addWidth(10),
                                Text(
                                  item.quantity.toString(),
                                  style: const TextStyle(
                                      color: AppTheme.iconSelectionClr,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                addWidth(10),
                                InkWell(
                                  onTap: () {
                                    showToast("Cart Updated");
                                    getUpdateCartData(
                                            context, item.product!.id, 1)
                                        .then((value) async {
                                      if (value.status) {
                                        setState(() {
                                          item.quantity = item.quantity + 1;
                                          getCartData().then((value) =>
                                              _cartController.model.value =
                                                  value);
                                        });
                                      } else {
                                        Helpers.createSnackBar(
                                            context, value.message.toString());
                                      }
                                      return;
                                    });
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          color: AppTheme.iconSelectionClr,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: const Icon(
                                        Icons.add,
                                        size: 16,
                                        color: Colors.white,
                                      )),
                                ),
                              ],
                            )
                    ],
                  )),
              Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      showToast("Item removed from cart");

                      getUpdateCartData(context, item.product!.id, 0)
                          .then((value) async {
                        if (value.status) {
                          setState(() {
                            // item.quantity = item.quantity + 1;
                            getCartData()
                                .then((value) =>
                                    _cartController.model.value = value)
                                .then((value) {
                              if (value.status!) {
                                bottomNavController.getData();
                              }
                              return null;
                            });
                          });
                        } else {
                          Helpers.createSnackBar(
                              context, value.message.toString());
                        }
                        return;
                      });
                    },
                    child: const Icon(
                      Icons.cancel_outlined,
                      size: 28,
                      color: AppTheme.newprimaryColor,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _getPaymentDetails(String payTitle, String paySubTitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          payTitle,
          style: const TextStyle(
              color: AppTheme.textColorDarkGreyDK,
              fontSize: 16.0,
              fontWeight: FontWeight.w500),
        ),
        Text(
          paySubTitle,
          style: const TextStyle(
              color: Colors.grey, fontSize: 18.0, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
