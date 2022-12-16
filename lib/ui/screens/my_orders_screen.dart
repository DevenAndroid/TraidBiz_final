import 'package:traidbiz/controller/MyOrdersController.dart';
import 'package:traidbiz/models/ModelGetOrder.dart';
import 'package:traidbiz/res/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../res/app_assets.dart';
import '../../routers/my_router.dart';
import '../widget/common_widget.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  MyOrdersScreenState createState() => MyOrdersScreenState();
}

class MyOrdersScreenState extends State<MyOrdersScreen> {
  bool isMoreDataLoad = false;
  bool isDataLoad = false;

  final controller = Get.put(MyOrdersController());
  bool downloading = false;
  RxString progress = "0".obs;
  RxString progress1 = "0".obs;
  var path = "No Data";
  var _onPressed;
  var platformVersion = "Unknown";


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xfff3f3f3),
        image: DecorationImage(
          image: AssetImage(
            AppAssets.shapeBg,
          ),
          alignment: Alignment.topRight,
          fit: BoxFit.contain,
        ),
      ),
      child: Scaffold(
          appBar: backAppBar('My Orders'),
          backgroundColor: Colors.transparent,
          body: Obx(() {
            return !controller.isDataLoading.value
                ? loader(context)
                : controller.model.value.data!.orders.isEmpty
                    ? getNoDataFound(screenSize, 'No Orders Found')
                    : ListView.builder(
                        // controller: scrollController,
                        itemCount: controller.model.value.data!.orders.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return orderCard(
                              controller.model.value.data!.orders[index]);
                        });
          })),
    );
  }

  Widget orderCard(Orders order) {
    return GestureDetector(
      onTap: () {
        if (order.hasSuborder) {
          Get.toNamed(MyRouter.subOrderDetail, arguments: [order.id]);
        } else {
          Get.toNamed(MyRouter.orderDetail, arguments: [order.id]);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 6, left: 10, right: 10),
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
                        order.image,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'OrderID #${order.number}',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500),
                        ),
                        InkWell(
                          onTap: () async {
                            launch(order.orderPdf.toString());
                            /*if ( order.orderPdf == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('No Data Found')));
                            } else {
                              downloadFile(order.orderPdf);
                              showToast('Downloading..');
                            }*/
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 6.0),
                            child: Text(
                              'Invoice',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    addHeight(4),
                    Text(
                      'Placed at: ${order.dateCreated}',
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400),
                    ),
                    addHeight(4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order.currencySymbol + order.total.toString(),
                          style: const TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                                color: const Color(0xffd1ffdc),
                                borderRadius: BorderRadius.circular(6)),
                            child: Text(
                              order.status.toString().capitalizeFirst ?? '',
                              style: const TextStyle(
                                color: Colors.green,
                              ),
                            )),
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
  ///Download code
  // Future<void> downloadFile(downloadLink) async {
  //   print(Platform.isAndroid);
  //   // print(Platform.isIOS);
  //   Dio dio = Dio();
  //   final status = await Permission.storage.request();
  //   var dirloc;
  //   if (Platform.isAndroid == true) {
  //     if (status.isGranted == true) {
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             content: const Text("Downloading Done"),
  //             actions: [
  //               Obx(() {
  //                 return Text(progress.value.toString() + '%');
  //               }),
  //               Obx(() {
  //                 return Container(
  //                   height: 10,
  //                   width: MediaQuery.of(context).size.width,
  //                   color: AppTheme.primaryColor,
  //                   padding: EdgeInsets.only(
  //                       left: MediaQuery.of(context).size.width /
  //                           100 *
  //                           double.parse(progress.value.toString())),
  //                   child: Container(
  //                     color: Colors.grey,
  //                   ),
  //                 );
  //               })
  //             ],
  //           );
  //         },
  //       );
  //       dirloc = "/sdcard/Download/";
  //       try {
  //         FileUtils.mkdir([dirloc]);
  //         await dio.download(downloadLink, dirloc + downloadLink.split('/').last,
  //             onReceiveProgress: (receivedBytes, totalBytes) {
  //               print('here 1');
  //               setState(() {
  //                 downloading = true;
  //                 progress.value = ((receivedBytes / totalBytes) * 100).toStringAsFixed(0);
  //                 print(progress);
  //               });
  //               print('here 2');
  //             });
  //       } catch (e) {
  //         print('catch catch catch');
  //         print(e);
  //       }
  //       setState(() {
  //         downloading = false;
  //         progress1.value = "Download Completed.";
  //         path = dirloc + downloadLink.split('/').last;
  //         _onPressed = () {
  //           downloadFile(downloadLink);
  //         };
  //       });
  //       print('Downloader path::::' + downloadLink);
  //       print(path);
  //
  //       Get.back();
  //       OpenFile.open(path);
  //     } else {
  //       setState(() {
  //         progress1.value = "Permission Denied!";
  //         showToast('Storage permission required');
  //       });
  //     }
  //   } else {
  //     var uri = await Uri.parse(downloadLink);
  //     if (await canLaunchUrl(uri)) {
  //       await launchUrl(uri);
  //     } else {
  //       // can't launch url
  //     }
  //   }
  // }
}
