import 'dart:developer';
import 'dart:math'; // Importing to generate random numbers
import 'package:chatzy/widgets/common_loader.dart';
import 'package:chatzy/widgets/validation.dart';
import 'package:flutter/cupertino.dart';
import '../../../config.dart';

class ProfileSetupScreen extends StatelessWidget {
  final profileCtrl = Get.put(ProfileSetupController());

  ProfileSetupScreen({super.key}) {
    // Automatically generate and assign a random email
    profileCtrl.emailController.text = generateRandomEmail();
  }

  // Function to generate a random email
  String generateRandomEmail() {
    const String chars = "abcdefghijklmnopqrstuvwxyz0123456789";
    final Random random = Random();
    String username = List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();
    String domain = "example.com"; // You can customize the domain if needed
    return "$username@$domain";
  }

  @override
  Widget build(BuildContext context) {
    // log("USER DATA: ${profileCtrl.user}");
    // log("IMAGE URL: ${profileCtrl.imageUrl}");

    return GetBuilder<ProfileSetupController>(builder: (_) {
      return Scaffold(
        backgroundColor: appCtrl.appTheme.screenBG,
        appBar: AppBar(
          backgroundColor: appCtrl.appTheme.screenBG,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            appFonts.profileSetup.tr,
            style: AppCss.manropeBold16
                .textColor(appCtrl.appTheme.darkText),
          ),
        ),
        body: profileCtrl.isLoading
            ? const CommonLoader()
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  SizedBox(
                    height: Sizes.s100,
                    width: Sizes.s100,
                    child: profileCtrl.isLoading
                        ? const CircularProgressIndicator()
                        : ClipRRect(
                      borderRadius: const BorderRadius.all(
                          Radius.circular(AppRadius.r8)),
                      child: _buildProfileImage(profileCtrl),
                    ),
                  ),
                  if (profileCtrl.user?["image"] != null)
                    _buildEditButton(profileCtrl),
                ],
              ),
              const VSpace(Sizes.s22),
              // Profile Setup Form
              Form(
                key: profileCtrl.profileGlobalKey,
                child: Padding(
                  padding: const EdgeInsets.all(Insets.i20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // _buildTextFieldSection(
                      //   title: appFonts.displayName.tr,
                      //   hintText: appFonts.enterYourName.tr,
                      //   controller: profileCtrl.userNameController,
                      //   validator: (name) =>
                      //       Validation().nameValidation(name),
                      // ),
                      // const VSpace(Sizes.s20),
                      // _buildTextFieldSection(
                      //   title: appFonts.email.tr,
                      //   hintText: appFonts.enterYourEmail.tr,
                      //   controller: profileCtrl.emailController,
                      //   validator: (email) =>
                      //       Validation().emailValidation(email),
                      // ),
                      const VSpace(Sizes.s20),
                      _buildTextFieldSection(
                        title: appFonts.addStatus.tr,
                        hintText: appFonts.writeHere.tr,
                        controller: profileCtrl.statusController,
                        validator: (status) =>
                            Validation().nameValidation(status),
                      ),
                      const VSpace(Sizes.s48),
                      ButtonCommon(
                        title: appFonts.submit,
                        onTap: profileCtrl.submitUserData,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // Helper function to build the profile image
  Widget _buildProfileImage(ProfileSetupController profileCtrl) {
    if (profileCtrl.imageUrl.isNotEmpty) {
      return Image.network(
        profileCtrl.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(eImageAssets.profileAnon),
      );
    } else if (profileCtrl.user?["image"] != null &&
        profileCtrl.user!["image"] != "") {
      return Image.network(
        profileCtrl.user!["image"],
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(eImageAssets.profileAnon),
      );
    } else {
      return DottedBorder(
        borderType: BorderType.RRect,
        color: appCtrl.appTheme.greyText.withOpacity(0.6),
        radius: const Radius.circular(AppRadius.r5),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.r5)),
          child: SizedBox(
            child: Icon(
              CupertinoIcons.add,
              color: appCtrl.appTheme.greyText.withOpacity(0.6),
            ).paddingAll(Insets.i4).decorated(
                borderRadius: BorderRadius.circular(AppRadius.r8),
                border: Border.all(
                    color: appCtrl.appTheme.greyText.withOpacity(0.6))),
          ).alignment(Alignment.center),
        ),
      );
    }
  }

  // Helper function to build the edit button
  Widget _buildEditButton(ProfileSetupController profileCtrl) {
    return SizedBox(
      child: SvgPicture.asset(eSvgAssets.edit)
          .paddingAll(Insets.i6)
          .decorated(
        color: appCtrl.appTheme.white,
        border: Border.all(color: appCtrl.appTheme.screenBG),
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.r6)),
      ),
    ).inkWell(
      onTap: () => profileCtrl.onTapProfile(profileCtrl.user?["image"]),
    );
  }

  // Helper function to build text field sections
  Widget _buildTextFieldSection({
    required String title,
    required String hintText,
    required TextEditingController controller,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppCss.manropeBold15.textColor(appCtrl.appTheme.darkText),
        ),
        const VSpace(Sizes.s8),
        TextFieldCommon(
          hintText: hintText,
          controller: controller,
          validator: validator,
        ),
      ],
    );
  }
}
