import 'package:traidbiz/controller/BookableProductController.dart';
import 'package:traidbiz/res/theme/theme.dart';
import 'package:traidbiz/routers/my_router.dart';
import 'package:traidbiz/ui/widget/common_button.dart';
import 'package:traidbiz/ui/widget/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../res/app_assets.dart';

class BookingProductScreen extends StatefulWidget {
  const BookingProductScreen({Key? key}) : super(key: key);

  @override
  BookingProductScreenState createState() => BookingProductScreenState();
}

class BookingProductScreenState extends State<BookingProductScreen> {
  final BookableProductController controller =
      Get.put(BookableProductController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery
    //     .of(context)
    //     .size;
    return Container(
      decoration: const BoxDecoration(
          color: Color(0xfffff8f9),
          image: DecorationImage(
            image: AssetImage(
              AppAssets.singleProductShapeBg,
            ),
            alignment: Alignment.topRight,
            fit: BoxFit.contain,
          )),
      child: Scaffold(
        appBar: backAppBar('Booking product'),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Obx(() {
            return !controller.isDataLoading.value
                ? loader(context)
                : SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        addHeight(4),
                        Align(
                          alignment: Alignment.center,
                          child: Material(
                            borderRadius: BorderRadius.circular(100),
                            elevation: 3,
                            child: SizedBox(
                              height: 155,
                              width: 155,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
                                child: Image.network(
                                  controller.model.value.data!.image.toString(),
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
                                ),
                              ),
                            ),
                          ),
                        ),
                        addHeight(24),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 32.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xfffff8f9),
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  controller.model.value.data!.productName
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textColorDarkBLue),
                                ),
                              ),
                              addHeight(20),
                              Row(
                                children: [
                                  const Text(
                                    'From',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        height: 1.5,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey),
                                  ),
                                  addWidth(10),
                                  Text(
                                    controller.model.value.data!.store!.name
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.primaryColor),
                                  ),
                                ],
                              ),
                              addHeight(12.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                            text:
                                                ' ${controller.model.value.data!.store!.name}',
                                            style: const TextStyle(
                                                fontSize: 18.0,
                                                height: 1.5,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    AppTheme.textColorSkyBLue)),
                                      ],
                                    ),
                                  ),
                                  RatingBar.builder(
                                    initialRating: double.parse(controller
                                        .model.value.data!.ratingCount
                                        .toString()),
                                    minRating: 0,
                                    itemSize: 24,
                                    ignoreGestures: true,
                                    // direction: Axis.horizontal,
                                    itemCount: 5,
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
                              addHeight(20),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Description',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      height: 1.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textColorDarkBLue),
                                ),
                              ),
                              addHeight(12),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  controller.model.value.data!.description
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey),
                                ),
                              ),
                              addHeight(40.0),
                              CommonButton(
                                  buttonHeight: 6.5,
                                  buttonWidth: 75,
                                  text: 'BOOK NOW',
                                  onTap: () {
                                    Get.toNamed(
                                        MyRouter
                                            .bookingProductScreenWithCalender,
                                        arguments: [
                                          controller.model.value.data!.id
                                        ]);
                                  },
                                  mainGradient: AppTheme.primaryGradientColor),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
          }),
        ),
      ),
    );
  }
}
