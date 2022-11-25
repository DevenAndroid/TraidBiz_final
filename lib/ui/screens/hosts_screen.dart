import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traidbiz/models/ModelStoreInfo.dart';
import 'package:traidbiz/repositories/getSupport.dart';
import 'package:traidbiz/res/theme/theme.dart';
import 'package:traidbiz/routers/my_router.dart';
import 'package:traidbiz/ui/screens/item/ItemProduct.dart';
import 'package:traidbiz/ui/widget/common_widget.dart';
import 'package:traidbiz/utils/ApiConstant.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/HostController.dart';
import '../../res/app_assets.dart';

class HostsScreen extends StatefulWidget {
  const HostsScreen({Key? key}) : super(key: key);

  @override
  HostsScreenState createState() => HostsScreenState();
}

class HostsScreenState extends State<HostsScreen> {
  final HostController _controller = Get.put(HostController());

  bool value = false;
  int? val = -1;

  var attributeSize = 'Blue';
  var attributeColor = 'Small';
  var productQuantity = 1;

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double itemHeight = screenSize.height / 4;
    final double itemWidth = screenSize.width / 2;
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xfffff8f9),
        image: DecorationImage(
          image: AssetImage(
            AppAssets.hostBgShape,
          ),
          alignment: Alignment.topRight,
          fit: BoxFit.contain,
        ),
      ),
      child: Scaffold(
        appBar: backAppBar(Get.arguments[1]),
        backgroundColor: Colors.transparent,
        body: Obx(() {
          return _controller.isDataLoading.value
              ? Padding(
                  padding:
                      const EdgeInsets.only(left: 0.0, right: 0.0, bottom: 0),
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.38,
                                  width: screenSize.width,
                                  child: Image.network(
                                    _controller
                                        .model.value.data!.storeInfo.banner,
                                    alignment: Alignment.topRight,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
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
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                    fit: BoxFit.cover,
                                  )),
                              Positioned(
                                  bottom: 0,
                                  left: 16.0,
                                  right: 16.0,
                                  child: Card(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Container(
                                        // height: 140,
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _controller.model.value.data!
                                                  .storeInfo.storeName,
                                              style: const TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Hello ${_controller.model.value.data!.storeInfo.storeName}',
                                              style: const TextStyle(
                                                  height: 1.5,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey),
                                            ),

                                            //code comment by dk
                                            // RatingBar.builder(
                                            //   initialRating: double.parse(
                                            //       _controller.model.value.data!
                                            //           .storeInfo.rating.count
                                            //           .toString()),
                                            //   minRating: 0,
                                            //   itemSize: 18,
                                            //   ignoreGestures: true,
                                            //   direction: Axis.horizontal,
                                            //   itemCount: 5,
                                            //   itemBuilder: (context, _) =>
                                            //       const Icon(
                                            //     Icons.star,
                                            //     color: Colors.amber,
                                            //   ),
                                            //   onRatingUpdate: (rating) {
                                            //     debugPrint(rating.toString());
                                            //   },
                                            // ),
                                            Text(
                                              _controller.model.value.data!
                                                  .storeInfo.address
                                                  .toString(),
                                              style: const TextStyle(
                                                  height: 1.5,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey),
                                            ),
                                            InkWell(
                                              onTap: _clicktoCall,
                                              child: Text(
                                                'Phone :- ${_controller.model.value.data!.storeInfo.storePhone}',
                                                style: const TextStyle(
                                                    height: 1.5,
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.grey),
                                              ),
                                            ),

                                            addHeight(12),
                                            const Divider(
                                              color: Colors.grey,
                                            ),
                                            IntrinsicHeight(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  _controller.model.value.data!.storeInfo.storeOpenClose.enabled.toString()=="yes"
                                                      ?
                                                  InkWell(
                                                      onTap: () {
                                                        // Get.defaultDialog(
                                                        //     backgroundColor:
                                                        //         Colors.white
                                                        //             .withOpacity(
                                                        //                 0.90),
                                                        //     titleStyle:
                                                        //         const TextStyle(
                                                        //       color: Colors.black,
                                                        //     ),
                                                        //     title: "Store Timing",
                                                        //     content:
                                                        //         dataTableWidget(
                                                        //       _controller
                                                        //           .model
                                                        //           .value
                                                        //           .data!
                                                        //           .storeInfo
                                                        //           .storeOpenClose
                                                        //           .time,
                                                        //     ));
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Dialog(
                                                                  // shape: RoundedRectangleBorder(
                                                                  //     borderRadius:
                                                                  //         BorderRadius.circular(
                                                                  //             40)),
                                                                  elevation: 16,
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Text(
                                                                          'Store Timing'),
                                                                      dataTableWidget(
                                                                        _controller
                                                                            .model
                                                                            .value
                                                                            .data!
                                                                            .storeInfo
                                                                            .storeOpenClose
                                                                            .time,
                                                                      )
                                                                    ],
                                                                  ));
                                                            });
                                                      },
                                                      child: Text(
                                                        'Store Time',
                                                              style: TextStyle(
                                                                  height: 1.5,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  color: Colors
                                                                      .black87),
                                                            )) : const Text('Always open', style: TextStyle(
          height: 1.5,
          fontSize:
          16.0,
          fontWeight:
          FontWeight
              .w800,
          color: Colors
              .black87),),
                                                  const VerticalDivider(
                                                    color: Colors.grey,
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      SharedPreferences pref =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      if (pref.getString(
                                                              'user') !=
                                                          null) {
                                                        final formKey =
                                                            GlobalKey<
                                                                FormState>();
                                                        var subjectController =
                                                            TextEditingController();
                                                        var messageController =
                                                            TextEditingController();
                                                        showDialog(
                                                            barrierDismissible:
                                                                false,
                                                            context: context,
                                                            builder: (context) {
                                                              return SingleChildScrollView(
                                                                  child:
                                                                      AlertDialog(
                                                                backgroundColor:
                                                                    Colors.white
                                                                        .withOpacity(
                                                                            0.90),
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            25,
                                                                        right:
                                                                            25),
                                                                title: const Center(
                                                                    child: Text(
                                                                        "Get Support")),
                                                                shape: const RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(20.0))),
                                                                content:
                                                                    SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height /
                                                                      1.5,
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    child: Form(
                                                                      key:
                                                                          formKey,
                                                                      child: Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                const Text(
                                                                                  "Hi,",
                                                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                                                                ),
                                                                                InkWell(
                                                                                    onTap: () {
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: const Icon(Icons.clear))
                                                                              ],
                                                                            ),
                                                                            const Text(
                                                                              'Create a new support topic',
                                                                              style: TextStyle(fontSize: 18),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 12,
                                                                            ),
                                                                            const Text(
                                                                              "Subject:",
                                                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 8,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 44,
                                                                              child: TextFormField(
                                                                                controller: subjectController,
                                                                                validator: (value) {
                                                                                  if (value!.trim().isEmpty) {
                                                                                    return 'Please enter subject';
                                                                                  }
                                                                                  return null;
                                                                                },
                                                                                decoration: const InputDecoration(hintText: 'Enter Message', enabled: true, focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey)), enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey))),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 14,
                                                                            ),
                                                                            const Text(
                                                                              "Message:",
                                                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 8,
                                                                            ),
                                                                            TextFormField(
                                                                              maxLines: 8,
                                                                              controller: messageController,
                                                                              validator: (value) {
                                                                                if (value!.trim().isEmpty) {
                                                                                  return 'Please enter message';
                                                                                } else if (value.trim().length < 10) {
                                                                                  return 'Message can\'t be less then 10 characters';
                                                                                }
                                                                                return null;
                                                                              },
                                                                              decoration: const InputDecoration(hintText: 'Type here', enabled: true, focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey)), enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey))),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 12,
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 18,
                                                                            ),
                                                                            InkWell(
                                                                              onTap: () {
                                                                                if (formKey.currentState!.validate()) {
                                                                                  getSupport(context, _controller.model.value.data!.storeInfo.id.toString(), subjectController.text, messageController.text).then((value) {
                                                                                    showToast(value.message);
                                                                                    Get.back();
                                                                                    return null;
                                                                                  });
                                                                                }
                                                                              },
                                                                              child: Center(
                                                                                child: Container(
                                                                                  // width: 140,
                                                                                  height: 46,
                                                                                  alignment: Alignment.center,
                                                                                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5)),
                                                                                  child: const Text(
                                                                                    "Submit",
                                                                                    style: TextStyle(color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ]),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ));
                                                            });
                                                      } else {
                                                        Get.toNamed(MyRouter
                                                            .logInScreen);
                                                      }
                                                    },
                                                    child: const Text(
                                                      'Get Support',
                                                      style: TextStyle(
                                                          height: 1.5,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color:
                                                              Colors.black87),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                  ))
                            ],
                          ),
                          addHeight(20),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              height: screenSize.height * 0.18,
                              clipBehavior: Clip.antiAlias,
                              //padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  //color: Colors.red,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Swiper(
                                autoplay: true,
                                outer: false,
                                autoplayDisableOnInteraction: false,
                                itemBuilder: (BuildContext context, int index) {
                                  return Image.network(
                                    _controller
                                        .model.value.data!.slider.slides[0].url,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
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
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                itemCount: _controller
                                    .model.value.data!.slider.slides.length,
                                pagination: const SwiperPagination(),
                                control: const SwiperControl(
                                    size: 0), // remove arrows
                              ),
                            ),
                          ),
                          addHeight(20),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'Popular Products',
                              style: TextStyle(
                                  color: AppTheme.textColorDarkBLue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          addHeight(10),
                        ],
                      )),
                      _controller.model.value.data!.storeProducts.isEmpty
                          ? SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      childAspectRatio: .95,
                                      mainAxisSpacing: 10.0,
                                      crossAxisSpacing: 0.0),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return getNoDataFound(
                                      screenSize, 'No Product Found');
                                },
                                childCount: 1,
                              ),
                            )
                          : SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio:
                                          (itemWidth / itemHeight),
                                      mainAxisSpacing: 10.0,
                                      crossAxisSpacing: 0.0),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, right: 16.0),
                                    child: ItemProduct(
                                        _controller,
                                        _controller
                                            .model.value.data!.storeProducts,
                                        index,
                                        itemHeight,
                                        false),
                                  );
                                },
                                childCount: _controller
                                    .model.value.data!.storeProducts.length,
                              ),
                            ),
                      const SliverPadding(
                        padding: EdgeInsets.only(bottom: 80.0),
                      )
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }

  dataTableWidget(List<Time> time) {
    return ListView.builder(
        itemCount: time.length,
        shrinkWrap: true,
        itemBuilder: ((context, index) {
          return Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Divider(),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const VerticalDivider(
                      width: 5,
                      color: Colors.red,
                    ),
                    Expanded(
                        child: Text(
                      time[index].day.toString(),
                      textAlign: TextAlign.center,
                    )),
                    const VerticalDivider(
                      width: 2,
                      color: Colors.red,
                    ),
                    Expanded(
                        child: Text(
                            time[index].openingTime.isEmpty
                                ? "Open"
                                : time[index].openingTime.toString(),
                            textAlign: TextAlign.center)),
                    const VerticalDivider(width: 2, color: Colors.red),
                    Expanded(
                        child: Text(
                            time[index].closingTime.isEmpty
                                ? "Open"
                                : time[index].closingTime.toString(),
                            textAlign: TextAlign.center)),
                    const VerticalDivider(width: 2, color: Colors.red),

                  ],
                ),
              ),
              const Divider(),
              // Divider(),
            ],
          );
        }));
  }

  _clicktoCall() async {
    var url;

    url = 'tel:${_controller.model.value.data!.storeInfo.storePhone}';

    await launch(url);
  }
}
