import 'package:traidbiz/controller/WishListController.dart';
import 'package:traidbiz/res/theme/theme.dart';
import 'package:traidbiz/ui/screens/item/ItemProduct.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyWishList extends StatefulWidget {
  const MyWishList({Key? key}) : super(key: key);

  @override
  _MyWishListState createState() => _MyWishListState();
}

class _MyWishListState extends State<MyWishList> {
  final _wishListController = Get.put(WishListController());

  bool value = false;
  int? val = -1;
  var attributeSize = 'Blue';
  var attributeColor = 'Small';

  @override
  void initState() {
    super.initState();
    _wishListController.getYourWishList();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double itemHeight = screenSize.height / 3.4;
    final double itemWidth = screenSize.width / 2.1;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () async {
          _wishListController.getYourWishList();
        },
        child: Obx(() {
          return _wishListController.isDataLoading.value
              ? Padding(
                  padding: const EdgeInsets.only(
                      top: 4.0, left: 16.0, right: 16.0, bottom: 12),
                  child: _wishListController.model.value.data!.isEmpty
                      ? const Center(
                          child: Text(
                          'No item in your wishlist',
                          style: TextStyle(fontSize: 18),
                        ))
                      : CustomScrollView(
                          slivers: <Widget>[
                            SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio:
                                          (itemWidth / itemHeight),
                                      mainAxisSpacing: 10.0,
                                      crossAxisSpacing: 10.0),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return ItemProduct(
                                      _wishListController,
                                      _wishListController.model.value.data!,
                                      index,
                                      itemHeight,
                                      true);
                                },
                                childCount: _wishListController
                                    .model.value.data!.length,
                              ),
                            ),
                            const SliverPadding(
                              padding: EdgeInsets.only(bottom: 80.0),
                            )
                          ],
                        ),
                )
              : const Center(
                  child: CircularProgressIndicator(
                      color: AppTheme.newprimaryColor));
        }),
      ),
    );
  }
}
