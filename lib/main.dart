import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naibrly/utils/app_contants.dart';
import 'package:naibrly/utils/tokenService.dart';
import 'package:naibrly/views/base/bottomNav/bottomNavWrapper.dart';
import 'package:naibrly/views/screen/welcome/welcome_screen.dart';

import 'controller/networkService/networkService.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await TokenService().init();
  Get.put(NetworkController());
  final token = TokenService().getToken();
  final bool hasToken = token != null && token.isNotEmpty;
  runApp(MyApp(
    firstScreen: hasToken ? BottomMenuWrappers() : const WelcomeScreen(),));
}

class MyApp extends StatelessWidget {
  final Widget firstScreen;
  const MyApp({super.key, required this.firstScreen});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: AppConstants.FONTFAMILY,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      builder: (context, child) => SafeArea(
        top: false,
        left: false,
        right: false,
        bottom: true,
        child: child ?? const SizedBox.shrink(),
      ),
      home: firstScreen,
    );
  }
}


