import 'package:dinelah/controller/BottomNavController.dart';
import 'package:dinelah/controller/vendorsListController.dart';
import 'package:dinelah/helper/Helpers.dart';
import 'package:dinelah/models/ModelSearchProduct.dart';
import 'package:dinelah/models/ModelVendorStore.dart';
import 'package:dinelah/repositories/get_update_cart_repository.dart';
import 'package:dinelah/res/theme/theme.dart';
import 'package:dinelah/ui/widget/common_button.dart';
import 'package:dinelah/utils/ApiConstant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/app_assets.dart';
import '../../routers/my_router.dart';
import '../widget/common_widget.dart';

class SearchHostProduct extends StatefulWidget {
  const SearchHostProduct({Key? key}) : super(key: key);

  @override
  SearchHostProductState createState() => SearchHostProductState();
}

class SearchHostProductState extends State<SearchHostProduct> {
  final controller = Get.put(VendorsController());
  bool value = false;
  int? val = -1;

  var indexSortBy = 0;
  RxBool isSort = false.obs;

  void applySearch(BuildContext context) {
    if (searchController.text.isEmpty) {
      showToast('Please enter something to search');
    } else {
      Get.toNamed(MyRouter.searchProductScreen,
          arguments: [searchController.text]);
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      searchController.text = Get.arguments[0];
    }
  }

  @override
  void dispose() {
    super.dispose();
    searchController.clear();
  }

  final searchController = TextEditingController();
  List<String> listSortBy = ['Near by', 'Top Rated'];

  @override
  Widget build(BuildContext context) {
    // controller.context = context;
    final screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        controller.getResetData();
        return true;
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xfffff8f9),
          image: DecorationImage(
            image: AssetImage(
              AppAssets.shapeBg,
            ),
            alignment: Alignment.topRight,
            fit: BoxFit.contain,
          ),
        ),
        child: Scaffold(
          appBar: backAppBar('Search Result'),
          backgroundColor: Colors.transparent,
          body: Obx(() {
            if (controller.sortBy.value != '') {
              isSort.value = true;
            }
            return controller.isDataLoading.value
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: controller.model.value.data!.stores.isEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: screenSize.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              maxLines: 1,
                                              controller: searchController,
                                              style:
                                                  const TextStyle(fontSize: 17),
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              decoration: InputDecoration(
                                                filled: true,
                                                prefixIcon: Icon(Icons.search,
                                                    color: Theme.of(context)
                                                        .iconTheme
                                                        .color),
                                                suffixIcon: InkWell(
                                                    onTap: () {
                                                      controller.searchKeyboard
                                                              .value =
                                                          searchController.text;
                                                      controller.getDataMap();
                                                      // print("searchController" +
                                                      //     searchController.text.toString());
                                                      // Get.toNamed(
                                                      //     MyRouter.searchProductScreen,
                                                      //     arguments: [
                                                      //       searchController.text
                                                      //     ]);
                                                      // searchController.clear();
                                                    },
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              8),
                                                      decoration: BoxDecoration(
                                                          color: AppTheme
                                                              .primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: const Icon(
                                                        Icons.search,
                                                        size: 18,
                                                        color: Colors.white,
                                                      ),
                                                    )),
                                                border:
                                                    const OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8))),
                                                fillColor: Colors.white,
                                                contentPadding: EdgeInsets.zero,
                                                hintText: 'Search Your Food',
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Get.toNamed(MyRouter.filterHost,
                                                  arguments: [
                                                    controller
                                                        .searchKeyboard.value
                                                  ]);
                                            },
                                            child: Container(
                                              width: 42,
                                              height: 42,
                                              margin: const EdgeInsets.all(8),
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Image.asset(
                                                  AppAssets.filterIcon),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              addHeight(10),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        isDismissible: true,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(16))),
                                        builder: (context) =>
                                            DraggableScrollableSheet(
                                          initialChildSize: 0.4,
                                          minChildSize: 0.2,
                                          maxChildSize: 0.40,
                                          expand: false,
                                          builder: (_, controller) => Column(
                                            children: [
                                              Icon(
                                                Icons.remove,
                                                size: 50,
                                                color: Colors.grey[600],
                                              ),
                                              Text(
                                                'Sort By',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              addHeight(24),
                                              Expanded(
                                                child: ListView.builder(
                                                  controller: controller,
                                                  itemCount: listSortBy.length,
                                                  itemBuilder: (_, index) {
                                                    return itemTextFilter(
                                                        index);
                                                  },
                                                ),
                                              ),
                                              const Divider(),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          'Sort by',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: isSort.value,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          isSort.value = !isSort.value;
                                          controller.sortBy.value = '';
                                          controller.searchKeyboard.value =
                                              searchController.text;
                                          controller.getDataMap();
                                        });
                                      },
                                      child: Material(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        color: Colors.white,
                                        elevation: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 12.0),
                                          child: Row(
                                            children: [
                                              Text(controller.sortBy.value
                                                  .toString()),
                                              addWidth(8),
                                              Icon(Icons.clear)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              addHeight(300),
                              const Align(
                                  alignment: Alignment.center,
                                  child: Text('No Host Found'))
                            ],
                          )
                        : Column(
                            children: [
                              SizedBox(
                                width: screenSize.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: searchView(context, () {
                                              controller.searchKeyboard.value =
                                                  searchController.text;
                                              controller.getDataMap();
                                            }, searchController),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Get.toNamed(MyRouter.filterHost,
                                                  arguments: [
                                                    controller
                                                        .searchKeyboard.value
                                                  ]);
                                            },
                                            child: Container(
                                              width: 42,
                                              height: 42,
                                              margin: const EdgeInsets.all(8),
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Image.asset(
                                                  AppAssets.filterIcon),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              addHeight(10),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        isDismissible: true,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(16))),
                                        builder: (context) =>
                                            DraggableScrollableSheet(
                                          initialChildSize: 0.4,
                                          minChildSize: 0.2,
                                          maxChildSize: 0.75,
                                          expand: false,
                                          builder: (_, controller) => Column(
                                            children: [
                                              Icon(
                                                Icons.remove,
                                                size: 50,
                                                color: Colors.grey[600],
                                              ),
                                              Expanded(
                                                child: ListView.builder(
                                                  controller: controller,
                                                  itemCount: listSortBy.length,
                                                  itemBuilder: (_, index) {
                                                    return itemTextFilter(
                                                        index);
                                                  },
                                                ),
                                              ),
                                              const Divider(),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Sort by',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                              addHeight(8),
                              Expanded(
                                child: ListView.builder(
                                    itemCount: controller
                                        .model.value.data!.stores.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return hostsList(controller
                                          .model.value.data!.stores[index]);
                                    }),
                              ),
                            ],
                          ),
                  )
                : loader(context);
          }),
        ),
      ),
    );
  }

  Widget hostsList(Stores store) {
    return GestureDetector(
      onTap: () {
        debugPrint(
            "::::StoreId::::${store.id}::::StoreId::::${store.storeName}");
        Get.toNamed(MyRouter.hostsScreen, arguments: [store.id]);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      topLeft: Radius.circular(15.0),
                    ),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey,
                        height: 130,
                        child: /*store.banner==null
                          ? Image.asset(AppAssets.drawerIcon)
                          : CachedNetworkImage(
                          imageUrl: store.banner,fit: BoxFit.cover,
                      placeholder: (context, url) => loader(context),
                      ),*/
                            Image.network(
                          store.banner,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 10.0),
                                child: CircularProgressIndicator(
                                  color: AppTheme.primaryColor,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          fit: BoxFit.cover,
                        )),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(store.storeName,
                        style: const TextStyle(
                            color: AppTheme.textColorDarkBLue,
                            fontSize: 20,
                            fontWeight: FontWeight.w700)),
                    addHeight(8.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.call,
                          size: 18,
                          color: AppTheme.primaryColor,
                        ),
                        addWidth(12),
                        const Text('+91 7742956054',
                            style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w400))
                      ],
                    ),
                    addHeight(4.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 20,
                          color: AppTheme.primaryColor,
                        ),
                        addWidth(12),
                        Expanded(
                          child: Text(store.address,
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget orderCard(Products product) {
    final bottomNavController = Get.put(BottomNavController());
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  borderRadius: BorderRadius.circular(50),
                  elevation: 3,
                  child: SizedBox(
                    height: 85,
                    width: 85,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      child: Image.network(
                        product.imageUrl,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 10.0),
                              child: CircularProgressIndicator(
                                color: AppTheme.primaryColor,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                addWidth(12),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    addHeight(8),
                    Text(
                      product.name,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500),
                    ),
                    addHeight(4),
                    Text(
                      product.categoryName,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500),
                    ),
                    addHeight(4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.currencySymbol + product.price,
                          style: const TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            // print(product.type.toString());
                            if (product.type.toString() == "simple") {
                              getUpdateCartData(context, product.id, 1)
                                  .then((value) {
                                if (value.status) {
                                  ++bottomNavController.cartBadgeCount.value;
                                  Helpers.createSnackBar(
                                      context, value.message.toString());
                                } else {}
                                return;
                              });
                            } else if (product.type.toString() == "variable") {
                              _getVariationBottomSheet();
                            } else if (product.type.toString() == "booking") {
                              Get.toNamed(MyRouter.bookingProductScreen,
                                  arguments: [product.id]);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppTheme.primaryColor,
                            ),
                            child: Row(
                              children: const [
                                Text(
                                  'Add to cart',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getVariationBottomSheet() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Wrap(
            children: [
              Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Exotica Pizza',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      addHeight(8),
                      const Text(
                        '[Green Capsicum, Sweet corn, Olives, Jalapino,Mashroom, Onion And Herbed Paneer]',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      ),
                      const Divider(),
                      addHeight(8),
                      const Text(
                        'Variation',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      addHeight(4),
                      const Text(
                        'Please select any one option',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      ),
                      addHeight(4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Small',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor),
                          ),
                          Row(
                            children: [
                              const Text(
                                '\$259.0',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.primaryColor),
                              ),
                              Radio(
                                  activeColor: AppTheme.primaryColor,
                                  value: 1,
                                  groupValue: val,
                                  onChanged: (value) {
                                    setState(() {
                                      val = value as int?;
                                    });
                                  })
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Medium',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          Row(
                            children: [
                              const Text(
                                '\$489.0',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Radio(
                                  value: 0, groupValue: 1, onChanged: (val) {})
                            ],
                          )
                        ],
                      ),
                      addHeight(8),
                      const Text(
                        'choice [7 Inch]',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      addHeight(4),
                      const Text(
                        'Please select any one option',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      ),
                      addHeight(4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Hand Tossed',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                '\$15.0',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Radio(
                                  activeColor: AppTheme.primaryColor,
                                  value: 1,
                                  groupValue: 1,
                                  onChanged: (val) {})
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Fresh Pen',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                '\$15.0',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Radio(
                                  activeColor: AppTheme.primaryColor,
                                  value: 1,
                                  groupValue: 1,
                                  onChanged: (val) {})
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Thin Crust',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          Row(
                            children: [
                              const Text(
                                '\$20.0',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Radio(
                                  value: 0, groupValue: 1, onChanged: (val) {})
                            ],
                          )
                        ],
                      ),
                      const Text(
                        'Extra Cheese (Small)',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      addHeight(4),
                      const Text(
                        'Please select any one option',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      ),
                      addHeight(4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Extra Cheese (Small)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                '\$60.0',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Checkbox(value: false, onChanged: (value) {})
                            ],
                          )
                        ],
                      ),
                      addHeight(8),
                      Row(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0)),
                                border: Border.all(color: Colors.blueAccent)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 4, bottom: 4, left: 8),
                                      child: const Icon(
                                        Icons.remove,
                                        size: 16,
                                        color: Colors.grey,
                                      )),
                                ),
                                addWidth(10),
                                Container(
                                    height: MediaQuery.of(context).size.height,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    color: const Color(0xffffe6e7),
                                    child: const Center(
                                        child: Text(
                                      '5',
                                      style: TextStyle(
                                          color: AppTheme.primaryColor,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ))),
                                addWidth(10),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 4, bottom: 4, right: 8),
                                      child: const Icon(
                                        Icons.add,
                                        size: 16,
                                        color: Colors.grey,
                                      )),
                                ),
                              ],
                            ),
                          ),
                          addWidth(10),
                          CommonButton(
                              buttonHeight: 6.5,
                              buttonWidth: 60,
                              text: 'ADD TO CART',
                              onTap: () {},
                              mainGradient: AppTheme.primaryGradientColor)
                        ],
                      ),
                    ],
                  ))
            ],
          );
        });
  }

  Widget itemTextFilter(index) {
    return InkWell(
      onTap: () {
        setState(() {
          indexSortBy = index;
        });

        controller.sortBy.value = listSortBy[indexSortBy];
        controller.getDataMap();
        Get.back();
      },
      child: Column(
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  listSortBy[index],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
