import 'dart:developer';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../config.dart';
import '../../../controllers/recent_chat_controller.dart';
import '../../../models/data_model.dart';
import '../../../widgets/popup_item_row_common.dart';
import 'layouts/current_user_status.dart';
import 'layouts/status_layout.dart';

class ChatScreen extends StatelessWidget {
  final chatCtrl = Get.put(ChatDashController());

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    log("data::${appCtrl.user['id']}");
    return PickupLayout(
      scaffold: GetBuilder<ChatDashController>(builder: (_) {
        return GetBuilder<DashboardController>(builder: (dashCtrl) {
          return Consumer<FetchContactController>(
              builder: (context, availableContacts, child) {
            return Consumer<RecentChatController>(
                builder: (contextw, recentChat, child) {
              return ScopedModel<DataModel>(
                  model: appCtrl.getModel()!,
                  child: ScopedModelDescendant<DataModel>(
                      builder: (context, child, model) {
                    appCtrl.cachedModel = model;
                    return Center(
                      child: DirectionalityRtl(
                        child: Scaffold(
                            backgroundColor: appCtrl.isTheme
                                ? appCtrl.appTheme.screenBG
                                : appCtrl.appTheme.white,
                            appBar: AppBar(
                                toolbarHeight: Sizes.s70,
                                backgroundColor: appCtrl.isTheme
                                    ? appCtrl.appTheme.screenBG
                                    : appCtrl.appTheme.white,
                                elevation: 0,
                                actions: [
                                  if (!dashCtrl.isSearch)
                                    ActionIconsCommon(
                                      icon: eSvgAssets.search,
                                      vPadding: Insets.i15,
                                      color: appCtrl.appTheme.white,
                                    ).inkWell(onTap: () {
                                      dashCtrl.isSearch = true;
                                      dashCtrl.update();
                                    }),
                                  if (!dashCtrl.isSearch)
                                    PopupMenuCommon(
                                        onOpened: () => chatCtrl.onTapDots(),
                                        onCanceled: () {
                                          chatCtrl.isFilter = false;
                                          chatCtrl.update();
                                        },
                                        itemBuilder: (context) => [
                                              buildPopupMenuItem(
                                                  list: chatCtrl.chatMenuLists
                                                      .asMap()
                                                      .entries
                                                      .map((e) => e.value[
                                                                  'title'] ==
                                                              appFonts
                                                                  .newBroadcast
                                                          ? !appCtrl
                                                                  .usageControlsVal!
                                                                  .allowCreatingBroadcast!
                                                              ? Container()
                                                              : PopupItemRowCommon(
                                                                  data: e.value,
                                                                  index: e.key,
                                                                  list: chatCtrl
                                                                      .chatMenuLists,
                                                                  onTap: () {
                                                                    chatCtrl.isFilter =
                                                                        false;
                                                                    if (e.key ==
                                                                        0) {
                                                                      Get.back();
                                                                      Get.toNamed(
                                                                          routeName
                                                                              .groupMessageScreen,
                                                                          arguments:
                                                                              true);
                                                                    } else if (e
                                                                            .key ==
                                                                        1) {
                                                                      Get.back();
                                                                      Get.toNamed(
                                                                          routeName
                                                                              .groupMessageScreen,
                                                                          arguments:
                                                                              false);
                                                                    } else {
                                                                      Get.back();
                                                                      Get.to(() =>
                                                                          FetchContact(
                                                                              prefs: appCtrl.pref));
                                                                    }

                                                                    chatCtrl
                                                                        .update();
                                                                  },
                                                                )
                                                          : e.value['title'] ==
                                                                  appFonts
                                                                      .newGroup
                                                              ? !appCtrl
                                                                      .usageControlsVal!
                                                                      .allowCreatingGroup!
                                                                  ? Container()
                                                                  : PopupItemRowCommon(
                                                                      data: e
                                                                          .value,
                                                                      index:
                                                                          e.key,
                                                                      list: chatCtrl
                                                                          .chatMenuLists,
                                                                      onTap:
                                                                          () {
                                                                        chatCtrl.isFilter =
                                                                            false;
                                                                        if (e.key ==
                                                                            0) {
                                                                          Get.back();
                                                                          Get.toNamed(
                                                                              routeName.groupMessageScreen,
                                                                              arguments: true);
                                                                        } else if (e.key ==
                                                                            1) {
                                                                          Get.back();
                                                                          Get.toNamed(
                                                                              routeName.groupMessageScreen,
                                                                              arguments: false);
                                                                        } else {
                                                                          Get.back();
                                                                          Get.to(() =>
                                                                              FetchContact(prefs: appCtrl.pref));
                                                                        }

                                                                        chatCtrl
                                                                            .update();
                                                                      },
                                                                    )
                                                              : PopupItemRowCommon(
                                                                  data: e.value,
                                                                  index: e.key,
                                                                  list: chatCtrl
                                                                      .chatMenuLists,
                                                                  onTap: () {
                                                                    chatCtrl.isFilter =
                                                                        false;
                                                                    if (e.key ==
                                                                        0) {
                                                                      Get.back();
                                                                      Get.toNamed(
                                                                          routeName
                                                                              .groupMessageScreen,
                                                                          arguments:
                                                                              true);
                                                                    } else if (e
                                                                            .key ==
                                                                        1) {
                                                                      Get.back();
                                                                      Get.toNamed(
                                                                          routeName
                                                                              .groupMessageScreen,
                                                                          arguments:
                                                                              false);
                                                                    } else {
                                                                      Get.back();
                                                                      Get.to(() =>
                                                                          FetchContact(
                                                                              prefs: appCtrl.pref));
                                                                    }

                                                                    chatCtrl
                                                                        .update();
                                                                  },
                                                                ))
                                                      .toList())
                                            ]).paddingSymmetric(
                                        horizontal: Insets.i15,
                                        vertical: Insets.i15)
                                ],
                                title: dashCtrl.isSearch
                                    ? SizedBox(
                                        height: Sizes.s50,
                                        child: TextFieldCommon(
                                            controller: dashCtrl.userText,
                                            hintText: "Search...",
                                            fillColor: appCtrl.appTheme.white,
                                            autoFocus: true,
                                            border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color:
                                                      appCtrl.appTheme.darkText,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppRadius.r8)),
                                            keyboardType:
                                                TextInputType.multiline,
                                            onChanged: (val) {
                                              dashCtrl.recentMessageSearch();
                                            },
                                            suffixIcon: dashCtrl
                                                    .userText.text.isNotEmpty
                                                ? Icon(CupertinoIcons.multiply,
                                                        color: appCtrl
                                                            .appTheme.white,
                                                        size: Sizes.s15)
                                                    .decorated(
                                                        color: appCtrl
                                                            .appTheme.darkText
                                                            .withOpacity(.3),
                                                        shape: BoxShape.circle)
                                                    .marginAll(Insets.i12)
                                                    .inkWell(onTap: () {
                                                    dashCtrl.isSearch = false;
                                                    dashCtrl.userText.text = "";
                                                    dashCtrl.update();
                                                  })
                                                : SvgPicture.asset(
                                                        eSvgAssets.search,
                                                        height: Sizes.s15)
                                                    .marginAll(Insets.i12)
                                                    .inkWell(onTap: () {
                                                    dashCtrl.isSearch = false;
                                                    dashCtrl.userText.text = "";
                                                    dashCtrl.update();
                                                  })),
                                      )
                                    : Text(appFonts.chatzy.tr,
                                        style: AppCss.muktaVaani20.textColor(
                                            appCtrl.appTheme.darkText))),
                            body: ScopedModel<DataModel>(
                              model: recentChat.getModel(appCtrl.user,
                                  isSearch: dashCtrl.isSearch,
                                  name: dashCtrl.userText.text)!,
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(appFonts.recentUpdate.tr,
                                              style: AppCss.manropeMedium14
                                                  .textColor(appCtrl
                                                      .appTheme.greyText))
                                          .paddingSymmetric(
                                              horizontal: Insets.i20,
                                              vertical: Insets.i10),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CurrentUserStatus(
                                                status: dashCtrl.statusCtrl
                                                    .currentUserStatus,
                                                onTap: () => dashCtrl.statusCtrl
                                                    .onTapStatus(),
                                                currentUserId:
                                                    dashCtrl.statusCtrl.user !=
                                                            null
                                                        ? dashCtrl.statusCtrl
                                                            .user["id"]
                                                        : ""),
                                            const HSpace(Sizes.s15),
                                            SponsorStatus(
                                                onTap: () => dashCtrl.statusCtrl
                                                    .onTapStatus(),
                                                status: dashCtrl
                                                    .statusCtrl.sponsorStatus),
                                            const HSpace(Sizes.s15),
                                            Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: dashCtrl
                                                    .statusCtrl.statusList
                                                    .asMap()
                                                    .entries
                                                    .map((e) {
                                                  return e.value.photoUrl!
                                                          .isNotEmpty
                                                      ? StatusLayout(
                                                              snapshot: e.value,
                                                              isShowAddIcon:
                                                                  false)
                                                          .paddingOnly(
                                                              right: Insets.i15)
                                                      : Container();
                                                }).toList())
                                          ]).paddingSymmetric(
                                          horizontal: Insets.i20),
                                      const VSpace(Sizes.s15),
                                      Divider(
                                              height: 1,
                                              thickness: 2,
                                              color:
                                                  appCtrl.appTheme.borderColor)
                                          .paddingSymmetric(
                                              horizontal: Insets.i20),
                                      const ChatCard(),
                                    ],
                                  ),
                                  if (chatCtrl.isFilter)
                                    BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 3, sigmaY: 3),
                                        child: Container(
                                            color: const Color(0xff042549)
                                                .withOpacity(0.3)))
                                ],
                              ),
                            )),
                      ),
                    );
                  }));
            });
          });
        });
      }),
    );
  }
}
