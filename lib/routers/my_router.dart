import 'package:traidbiz/ui/screens/Delivery_Details/booking_order_detail.dart';
import 'package:traidbiz/ui/screens/Delivery_Details/order_detail.dart';
import 'package:traidbiz/ui/screens/Delivery_Details/sub_order_detail.dart';
import 'package:traidbiz/ui/screens/address/address.dart';
import 'package:traidbiz/ui/screens/cart_screen.dart';
import 'package:traidbiz/ui/screens/change_password.dart';
import 'package:traidbiz/ui/screens/dashboard_screen.dart';
import 'package:traidbiz/ui/screens/forgot_screen.dart';
import 'package:traidbiz/ui/screens/login_screen.dart';
import 'package:traidbiz/ui/screens/my_orders_screen.dart';
import 'package:traidbiz/ui/screens/reset_forgot_password.dart';
import 'package:traidbiz/ui/screens/search_host_screen.dart';
import 'package:traidbiz/ui/screens/search_screen.dart';
import 'package:traidbiz/ui/screens/signUp_screen.dart';
import 'package:traidbiz/ui/screens/verify_otp_forgot_password.dart';
import 'package:traidbiz/ui/screens/verify_signup_screen.dart';
import 'package:traidbiz/ui/screens/wishList_screen.dart';
import 'package:traidbiz/ui/static_pages/server_error_page.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../splash_screen.dart';
import '../ui/screens/all_hosts.dart';
import '../ui/screens/booking_product_D&T.dart';
import '../ui/screens/booking_product_screen.dart';
import '../ui/screens/bottom_Nav_Bar.dart';
import '../ui/screens/category_screen.dart';
import '../ui/screens/chat_Screen.dart';
import '../ui/screens/checkOut_Screen.dart';
import '../ui/screens/hosts_screen.dart';
import '../ui/screens/my_profile.dart';
import '../ui/screens/notification_screen.dart';
import '../ui/screens/single_product_Screen.dart';

class MyRouter {
  static var homeScreen = "/homeScreen";
  static var splashScreen = "/splashScreen";
  static var logInScreen = "/logScreen";
  static var verifyEmailScreen = "/verifyEmailScreen";
  static var signUpScreen = "/signUpScreen";
  static var dashBoardScreen = "/dashBoardScreen";
  static var customBottomBar = "/customBottomBar";
  static var categoryScreen = "/categoryScreen";
  static var chatScreen = "/chatScreen";
  static var allHostsScreen = "/allHostsScreen";
  static var hostsScreen = "/hostsScreen";
  static var orderDetail = "/orderDetail";
  static var subOrderDetail = "/subOrderDetail";
  static var bookingOrderDetail = "/bookingOrderDetail";
  static var cartScreen = "/cartScreen";
  static var myWishList = "/myWishList";
  static var checkoutScreen = "/checkoutScreen";
  static var profileScreen = "/profileScreen";
  static var addressScreen = "/addressScreen";
  static var notificationScreen = "/notificationScreen";
  static var myOrdersScreen = "/myOrdersScreen";
  static var forgotPassword = "/forgotPassword";
  static var changePassword = "/changePassword";
  static var singleProductScreen = "/singleProductScreen";
  static var bookingProductScreen = "/bookingProductScreen";
  static var bookingProductScreenWithCalender =
      "/bookingProductScreenWithCalender";
  static var resetForgotPasswordScreen = "/resetForgotPasswordScreen";
  static var searchProductScreen = "/searchProductScreen";
  static var filterProduct = "/filterProduct";
  static var searchHostProduct = "/searchHostProduct";
  static var filterHost = "/filterHost";
  // static var myBookingsScreen = "/myBookingsScreen";
  static var verifyOTPForgotPassword = "/verifyOTPForgotPassword";
  static var privacyPolicyScreen = "/privacyPolicyScreen";
  static var shippingPolicy = "/shippingPolicy";
  static var loginDrawerScreen = "/loginDrawerScreen";
  static var refundDrawerScreen = "/refundDrawerScreen";
  static var paymentOptionsDrawerScreen = "/paymentOptionsDrawerScreen";
  static var aboutUsScreenDrawer = "/aboutUsScreenDrawer";
  static var whyTraidBizScreenDrawer = "/whyTraidBizScreenDrawer";
  static var sellOnTraidBizScreen = "/sellOnTraidBizScreen";
  static var termsAndConditionsDrawer = "/termsAndConditionsDrawer";
  static var contactUsScreenDrawer = "/contactUsScreenDrawer";
  static var helpCenterScreenDrawer = "/helpCenterScreenDrawer";
  static var referAndEarnDrawer = "/referAndEarnDrawer";
  static var serverErrorUi = "/serverErrorUi";

  static var route = [
    GetPage(name: '/', page: () => SplashScreen()),
    GetPage(name: MyRouter.splashScreen, page: () => SplashScreen()),
    GetPage(name: MyRouter.logInScreen, page: () => const LoginScreen()),
    GetPage(name: MyRouter.signUpScreen, page: () => SignUpScreen()),
    GetPage(name: MyRouter.verifyEmailScreen, page: () => VerifyEmailSignup()),
    GetPage(
        name: MyRouter.dashBoardScreen, page: () => const DashBoardScreen()),
    GetPage(
        name: MyRouter.customBottomBar,
        page: () => const CustomNavigationBar()),
    GetPage(name: MyRouter.chatScreen, page: () => ChatterScreen()),
    GetPage(name: MyRouter.categoryScreen, page: () => const CategoryScreen()),
    GetPage(name: MyRouter.allHostsScreen, page: () => const AllHostsScreen()),
    GetPage(name: MyRouter.hostsScreen, page: () => const HostsScreen()),
    GetPage(name: MyRouter.orderDetail, page: () => const OrderDetail()),
    GetPage(name: MyRouter.subOrderDetail, page: () => const SubOrderDetail()),
    GetPage(name: MyRouter.cartScreen, page: () => const CartScreen()),
    GetPage(name: MyRouter.myWishList, page: () => const MyWishList()),
    GetPage(name: MyRouter.checkoutScreen, page: () => const Checkout()),
    GetPage(name: MyRouter.profileScreen, page: () => MyProfile()),
    GetPage(name: MyRouter.addressScreen, page: () => const AddressScreen()),
    GetPage(
        name: MyRouter.bookingOrderDetail,
        page: () => const BookingOrderDetail()),
    GetPage(
        name: MyRouter.notificationScreen,
        page: () => const NotificationScreen()),
    GetPage(name: MyRouter.myOrdersScreen, page: () => const MyOrdersScreen()),
    // GetPage(
    //     name: MyRouter.myBookingsScreen, page: () => const MyBookingsScreen()),
    GetPage(name: MyRouter.forgotPassword, page: () => const ForgotPassword()),
    GetPage(name: MyRouter.changePassword, page: () => const ChangePassword()),
    GetPage(
        name: MyRouter.singleProductScreen,
        page: () => const SingleProductScreen()),
    GetPage(
        name: MyRouter.bookingProductScreen,
        page: () => const BookingProductScreen()),
    GetPage(
        name: MyRouter.bookingProductScreenWithCalender,
        page: () => const BookingProductWithCalender()),
    GetPage(
        name: MyRouter.searchProductScreen, page: () => const SearchProduct()),
    // GetPage(name: MyRouter.filterProduct, page: () => const FilterProduct()),
    // GetPage(name: MyRouter.filterHost, page: () => const FilterHost()),
    GetPage(
        name: MyRouter.searchHostProduct,
        page: () => const SearchHostProduct()),
    GetPage(
        name: MyRouter.resetForgotPasswordScreen,
        page: () => const ResetForgotPassword()),
    GetPage(
        name: MyRouter.verifyOTPForgotPassword,
        page: () => const VerifyOTPForgotPassword()),

    GetPage(name: MyRouter.serverErrorUi, page: () => ServerErrorUi()),
  ];
}
