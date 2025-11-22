import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naibrly/utils/app_colors.dart';
import 'package:naibrly/views/base/appTextfield/appTextfield.dart';
import 'package:naibrly/views/screen/Users/auth/sign_up.dart';
import '../../../controller/Customer/authCustomer/signInController.dart';
import '../../base/AppText/appText.dart';
import '../../base/Ios_effect/iosTapEffect.dart';
import '../../base/primaryButton/primary_button.dart';
import 'base/or/orLogin.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final SignInController controller = Get.put(SignInController());


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.White,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.02),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/Frame 2147226485.png",
                height: 200,
                width: 160,
              ),
            ),
            AppText(
              "Welcome Back",
              fontWeight: FontWeight.w400,
              fontSize: 28,
              color: AppColors.textcolor,
            ),
            SizedBox(height: size.height * 0.01),
            AppText(
              "Hello there, login to continue",
              fontWeight: FontWeight.w300,
              fontSize: 14,
              color: AppColors.textcolor,
            ),
            SizedBox(height: size.height * 0.03),
            AppTextField(controller: controller.emailcontroller, hint: "Email Address"),
            SizedBox(height: 15),
            Obx(
                  () => AppTextField(
                obscure: controller.passShowHide.value,
                // ✅ dynamic obscure
                keyboardType: TextInputType.twitter,
                controller: controller.passwordcontroller,
                // ✅ use passwordController here
                hint: "Password",
                suffix: IconButton(
                  icon: Icon(
                    controller.passShowHide.value
                        ? CupertinoIcons.eye_slash
                        : CupertinoIcons.eye,
                    color: Colors.white38,
                  ),
                  onPressed: () {
                    controller.toggle();
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.topRight,
              child: AppText(
                "Forgot Password?",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textcolor,
              ),
            ),
            SizedBox(height: size.height * 0.04),
            Obx((){
              return PrimaryButton(
                loading: controller.isLoading.value,
                text: "Login",
                onTap: () {
                  final email = controller.emailcontroller.text;
                  final password = controller.passwordcontroller.text;
                  if(email.isEmpty || password.isEmpty){
                    showError(context,"Please fill the field");
                  }else{
                    controller.loginUser(context, email, password);
                  }
                },
              );
            }),
            SizedBox(height: size.height * 0.04),
            const OrDivider(),
            SizedBox(height: size.height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GoogleOrAppcle(onTap: () {}, icon: "assets/icons/Group (5).svg"),
                SizedBox(width: 16,),
                GoogleOrAppcle(onTap: () {}, icon: "assets/icons/Google (1).svg"),
              ],
            ),
            SizedBox(height: size.height * 0.05),
            IosTapEffect(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (builder)=> SignUp()));
              },
              child: Align(
                alignment: Alignment.center,
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppText("Create account",fontSize: 16,fontWeight: FontWeight.w400,color: AppColors.secondary,),
                      Container(height: 2,color: AppColors.secondary.withOpacity(0.50),),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

  void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class GoogleOrAppcle extends StatelessWidget {
  final VoidCallback onTap;
  final String icon;

  const GoogleOrAppcle({super.key, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return IosTapEffect(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0xFF000000).withOpacity(0.04),
              offset: Offset(0, 6),
              blurRadius: 24,
            ),
          ],
          color: Colors.white,
          border: Border.all(
            width: 1,
            color: AppColors.secondary.withOpacity(0.20),
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [SvgPicture.asset(icon)],
          ),
        ),
      ),
    );
  }
}
