import 'dart:async';
import 'dart:ffi';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:traidbiz/controller/SearchController.dart';
import 'package:traidbiz/res/theme/theme.dart';
import 'package:traidbiz/ui/screens/item/ItemProduct.dart';
import 'package:traidbiz/ui/widget/common_widget.dart';
import 'package:traidbiz/utils/ApiConstant.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/GetHomeController.dart';
import '../../models/ModelHomeData.dart';
import '../../repositories/update_user_currency.dart';
import '../../routers/my_router.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  DashBoardScreenState createState() => DashBoardScreenState();
}

class DashBoardScreenState extends State<DashBoardScreen> {
  final _controller = Get.put(GetHomeController());
  final searchController = TextEditingController();

  @override
  void deactivate() {
    super.deactivate();
    _controller.onClose();
    // InternetConnectionChecker().onStatusChange.listen((status) {
    //   final connected = status == InternetConnectionStatus.connected;
    //   showSimpleNotification(
    //       Text(connected ? "Connected to internet" : "NO INTERNET FOUND"),
    //       background: Colors.green);
    // });
  }

  bool servicestatus = false;
  bool haspermission = false;

  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";

  late StreamSubscription<Position> positionStream;

  @override
  void initState() {
    super.initState();
    checkGps();
    _controller.getData();
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text(
                  "Location",
                ),
                content: const Text(
                  "Please turn on GPS location service to narrow down the nearest Stores.",
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Approve'),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await Geolocator.openLocationSettings();
                      servicestatus =
                          await Geolocator.isLocationServiceEnabled();
                      if (servicestatus) {
                        permission = await Geolocator.checkPermission();

                        if (permission == LocationPermission.denied) {
                          permission = await Geolocator.requestPermission();
                          if (permission == LocationPermission.denied) {
                            print('Location permissions are denied');
                          } else if (permission ==
                              LocationPermission.deniedForever) {
                            print(
                                "Location permissions are permanently denied");
                          } else {
                            haspermission = true;
                          }
                        } else {
                          haspermission = true;
                        }

                        if (haspermission) {
                          setState(() {
                            //refresh the UI
                          });

                          getLocation();
                        }
                      }
                    },
                  ),
                ],
              ));

      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('latitude', lat.toString());
    prefs.setString('longitude', long.toString());
    setState(() {
      //refresh UI
    });

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    // StreamSubscription<Position> positionStream =
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      long = position.longitude.toString();
      lat = position.latitude.toString();

      setState(() {
        // print('Latitude :: ' +
        //     position.longitude.toString()); //Output: 80.24599079
        // print('Longitude :: ' +
        //     position.latitude.toString()); //Output: 29.6593457

        //refresh UI on update
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // InternetConnectionChecker.createInstance(
    //         checkInterval: const Duration(
    //           seconds: 5,
    //         ),
    //         checkTimeout: const Duration(seconds: 1))
    //     .onStatusChange
    //     .listen((status) {
    //   final connected = status == InternetConnectionStatus.connected;
    //   if (connected == true) {
    //     return;
    //   } else {
    //     connected
    //         ? showToast("Connected to internet")
    //         : showToast("No Internet Found, please check internet connection");
    //   }
    // });

    final screenSize = MediaQuery.of(context).size;
    final double itemHeight = screenSize.height / 2.8;
    final double itemWidth = screenSize.width / 2;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(() {
          return !_controller.isDataLoading.value
              ? Center(child: loader(context))
              : Padding(
                  padding: const EdgeInsets.only(
                      top: 4.0, left: 16.0, right: 16.0, bottom: 12),
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(servicestatus
                          //     ? "GPS is Enabled"
                          //     : "GPS is disabled."),
                          // Text(haspermission
                          //     ? "GPS is Enabled"
                          //     : "GPS is disabled."),
                          // Text("Longitude: $long",
                          //     style: TextStyle(fontSize: 20)),
                          // Text(
                          //   "Latitude: $lat",
                          //   style: TextStyle(fontSize: 20),
                          // ),
                          const Text(
                            'Lets Find\nGood Quality Products',
                            style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'popins',
                                color: AppTheme.colorWhite),
                          ),
                          addHeight(20),
                          searchView(context, () {
                            applySearch(context);
                          }, searchController),
                          addHeight(20),
                          Container(
                            height: screenSize.height * 0.18,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            child: Swiper(
                              autoplay: true,
                              outer: false,
                              autoplayDisableOnInteraction: false,
                              itemBuilder: (BuildContext context, int index) {
                                return Image.network(
                                  _controller.model.value.data!.slider.slides[index].url
                                      .toString(),
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
                                          color: AppTheme.addToCartColorDK,
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
                              itemCount: _controller.model.value.data!.slider.slides.length,
                              pagination: const SwiperPagination(),
                              control: const SwiperControl(size: 0), // remove arrows
                            ),
                          ),
                          addHeight(20),
                          SizedBox(
                            height: screenSize.height * 0.05,
                            child: ListView.builder(
                                itemCount: _controller.model.value.data!.category.categories.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return categoryList(
                                      _controller.model.value.data!.category.categories,
                                      index);
                                }),
                          ),

                          const Text(
                            'Popular Products',
                            style: TextStyle(
                                color: AppTheme.textColorDarkGreyDK,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          addHeight(10),
                        ],
                      )),
                      SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: (itemWidth / itemHeight),
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return ItemProduct(
                                _controller,
                                _controller.model.value.data!.popularProducts,
                                index,
                                itemHeight,
                                false);
                          },
                          childCount: _controller.model.value.data!.popularProducts.length,
                        ),
                      ),
                      const SliverPadding(
                        padding: EdgeInsets.only(bottom: 80.0),
                      )
                    ],
                  ),
                );
        }),
      ),
    );
  }

  void applySearch(BuildContext context) {
    var controller = Get.put(SearchController());
    if (searchController.text.isEmpty) {
      showToast('Please enter something to search');
    } else {
      Future.delayed(const Duration(milliseconds: 2000), () {
        setState(() {
          controller.searchKeyboard.value = searchController.text;
          print('SEARCH PARAM ::   ${searchController.text}');
          Get.toNamed(MyRouter.searchProductScreen,
              arguments: [searchController.text]);
          searchController.clear();
          FocusManager.instance.primaryFocus?.unfocus();
        });
      });
    }
  }

  Widget categoryList(List<Categories> categories, int index) {
    return InkWell(
      onTap: () {
        Get.toNamed(MyRouter.categoryScreen, arguments: [
          categories,
          categories[index].termId,
          index,
        ]);
      },
      child: Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 1.0,
            ),
          ], color: Colors.white, borderRadius: BorderRadius.circular(6)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: Row(
              children: [
                Material(
                  borderRadius: BorderRadius.circular(50),
                  elevation: 3,
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100)),
                      child: Image.network(
                        categories[index].imageUrl.toString(),
                        fit: BoxFit.cover,
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
                      ),
                    ),
                  ),
                ),
                addWidth(8),
                Text(
                  categories[index].name.toString(),
                  style: const TextStyle(
                      color: AppTheme.textColorDarkBLue,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          )),
    );
  }
  Future<bool> _onWillPop() async {
        await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),          
        content: const Text('Do you want to exit App'),

        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('No',style: TextStyle(color: Colors.black),),
          ),
          ElevatedButton(
            onPressed: () {
              SystemNavigator.pop();
              },
            child: const Text('Yes',style: TextStyle(color: Colors.black),),
          ),
        ],
      ),
    );
        return false;
  }
}
