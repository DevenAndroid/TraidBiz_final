// import 'package:traidbiz/controller/MyBookingsController.dart';
// import 'package:traidbiz/models/ModelMyBookings.dart';
// import 'package:traidbiz/res/theme/theme.dart';
// import 'package:traidbiz/routers/my_router.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../res/app_assets.dart';
// import '../widget/common_widget.dart';
//
// class MyBookingsScreen extends StatefulWidget {
//   const MyBookingsScreen({Key? key}) : super(key: key);
//
//   @override
//   MyBookingsScreenState createState() => MyBookingsScreenState();
// }
//
// class MyBookingsScreenState extends State<MyBookingsScreen> {
//   bool isMoreDataLoad = false;
//   bool isDataLoad = false;
//
//   final controller = Get.put(MyBookingsController());
//
//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     return Container(
//       decoration: const BoxDecoration(
//         color: Color(0xfff3f3f3),
//         image: DecorationImage(
//           image: AssetImage(
//             AppAssets.shapeBg,
//           ),
//           alignment: Alignment.topRight,
//           fit: BoxFit.contain,
//         ),
//       ),
//       child: Scaffold(
//           appBar: backAppBar('My Bookings'),
//           backgroundColor: Colors.transparent,
//           body: Obx(() {
//             return !controller.isDataLoading.value
//                 ? loader(context)
//                 : controller.model.value.data!.isEmpty
//                     ? getNoDataFound(screenSize, 'No Orders Found')
//                     : ListView.builder(
//                         // controller: scrollController,
//                         itemCount: controller.model.value.data!.length,
//                         shrinkWrap: true,
//                         itemBuilder: (context, index) {
//                           return orderCard(controller.model.value.data![index]);
//                         });
//           })),
//     );
//   }
//
//   Widget orderCard(ModelBookingData order) {
//     return GestureDetector(
//       onTap: () {
//         if (order.hasSuborder!) {
//           Get.toNamed(MyRouter.subOrderDetail, arguments: [order.orderId]);
//         } else {
//           Get.toNamed(MyRouter.bookingOrderDetail,
//               arguments: [order.bookingId]);
//         }
//         // Get.toNamed(MyRouter.bookingOrderDetail, arguments: [order.orderId]);
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 10),
//         child: Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Material(
//                   borderRadius: BorderRadius.circular(50),
//                   elevation: 3,
//                   child: SizedBox(
//                     height: 85,
//                     width: 85,
//                     child: ClipRRect(
//                       borderRadius: const BorderRadius.all(Radius.circular(50)),
//                       child: Image.network(
//                         order.image.toString(),
//                         loadingBuilder: (BuildContext context, Widget child,
//                             ImageChunkEvent? loadingProgress) {
//                           if (loadingProgress == null) {
//                             return child;
//                           }
//                           return Center(
//                             child: Padding(
//                               padding: const EdgeInsets.only(
//                                   top: 10.0, bottom: 10.0),
//                               child: CircularProgressIndicator(
//                                 color: AppTheme.primaryColor,
//                                 value: loadingProgress.expectedTotalBytes !=
//                                         null
//                                     ? loadingProgress.cumulativeBytesLoaded /
//                                         loadingProgress.expectedTotalBytes!
//                                     : null,
//                               ),
//                             ),
//                           );
//                         },
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ),
//                 addWidth(12),
//                 Expanded(
//                     child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     addHeight(8),
//                     Text(
//                       'OrderID #${order.bookingId}',
//                       style: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.w500),
//                     ),
//                     addHeight(4),
//                     Text(
//                       'Start at: ${order.start}',
//                       style: const TextStyle(
//                           color: Colors.grey,
//                           fontSize: 16.0,
//                           fontWeight: FontWeight.w400),
//                     ),
//                     Text(
//                       'End at: ${order.end}',
//                       style: const TextStyle(
//                           color: Colors.grey,
//                           fontSize: 16.0,
//                           fontWeight: FontWeight.w400),
//                     ),
//                     addHeight(4),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           order.cost.toString(),
//                           style: const TextStyle(
//                               color: AppTheme.primaryColor,
//                               fontSize: 16.0,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 8, vertical: 4),
//                             decoration: BoxDecoration(
//                                 color: const Color(0xffd1ffdc),
//                                 borderRadius: BorderRadius.circular(5)),
//                             child: Text(
//                               order.status.toString(),
//                               style: const TextStyle(
//                                 color: Colors.green,
//                               ),
//                             )),
//                       ],
//                     ),
//                   ],
//                 )),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
