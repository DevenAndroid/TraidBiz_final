
import 'package:traidbiz/controller/GetSocialLinksController.dart';
import 'package:traidbiz/models/ModelNotification.dart';
import 'package:traidbiz/repositories/clear_notifications.dart';
import 'package:traidbiz/res/app_assets.dart';
import 'package:traidbiz/routers/my_router.dart';
import 'package:traidbiz/ui/widget/common_widget.dart';
import 'package:traidbiz/utils/ApiConstant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widget/common_widget.dart';

class GetSocialLinksScreen extends StatefulWidget {
  const GetSocialLinksScreen({Key? key}) : super(key: key);

  @override
  GetSocialLinksScreenState createState() => GetSocialLinksScreenState();
}

class GetSocialLinksScreenState extends State<GetSocialLinksScreen> {
  // late Future<ModelNotificationData> future;

  final controller = Get.put(GetSocialLinksController());

  @override
  void initState() {
    super.initState();
    // future = getNotificationData(context);
  }

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
          backgroundColor: Colors.transparent,
          appBar: backAppBar('Connect with us on Social'),
          body: Obx(() {
            return !controller.isDataLoading.value
                ? loader(context)
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ListView.builder(
                          itemCount: controller.model.value.data!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index){
                        return GestureDetector(
                          onTap: (){
                            var url = controller.model.value.data![index].link.toString();
                            launch(url);
                          },
                          child: Card(
                            child: ListTile(
                              leading: CircleAvatar(),
                              title: Text(controller.model.value.data![index].tittle.toString()),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
          }),
        ) //;
        );
  }

  Widget notificationList(List<Notifications> notifications, int index) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Card(
        elevation: 0,
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF100012 * (index + 1)),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                height: MediaQuery.of(context).size.height * 0.07,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Container(
                width: 55,
                height: 55,
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    child: Image.asset(
                      AppAssets.hostBanner,
                      //snapshot.data!.data.notifications[index].image,
                      fit: BoxFit.fill,
                    ) //Text('A', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ),),
                    ),
              ),
            ),
            Expanded(
              flex: 40,
              child: Container(
                margin: const EdgeInsets.fromLTRB(12, 8, 8, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(notifications[index].title ?? ""),
                    //textBold(snapshot.data!.data.notifications[index].title),
                    addHeight(4),
                    Text(
                      notifications[index].description ?? "",
                      //snapshot.data!.data.notifications[index].message,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          height: 1.2, color: Colors.black54, fontSize: 14),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // return loader(context);
}
//);
// }
//}
