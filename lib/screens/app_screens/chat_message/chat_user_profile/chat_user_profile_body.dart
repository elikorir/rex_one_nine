import 'package:intl/intl.dart';
import '../../../../../config.dart';
import '../../../../widgets/block_report_layout.dart';
import 'chat_user_images.dart';

class ChatUserProfileBody extends StatelessWidget {
  const ChatUserProfileBody({super.key});

  String _getLastSeenText(int lastSeenTimestamp) {
    DateTime lastSeenDate = DateTime.fromMillisecondsSinceEpoch(lastSeenTimestamp);
    DateTime now = DateTime.now();

    // Check if last seen was today
    if (lastSeenDate.day == now.day &&
        lastSeenDate.month == now.month &&
        lastSeenDate.year == now.year) {
      // Return "Today at [time]"
      return "Today at ${DateFormat('HH:mm a').format(lastSeenDate)}";
    } else {
      // Return the date for last seen
      return DateFormat('dd/MM/yyyy at HH:mm a').format(lastSeenDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (chatCtrl) {

      return Container(
          decoration: ShapeDecoration(
              color: appCtrl.appTheme.screenBG,
              shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                      cornerRadius: 20, cornerSmoothing: 1)
              )),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 10),
                decoration: ShapeDecoration(
                    color: appCtrl.appTheme.screenBG,
                    shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                            cornerRadius: 20, cornerSmoothing: 1))),
                child: Column(children: [
                  Text(chatCtrl.pData["name"],
                      style: AppCss.manropeSemiBold16
                          .textColor(appCtrl.appTheme.darkText)),
                  const VSpace(Sizes.s10),
                  Text(chatCtrl.pData["phone"],
                      style: AppCss.manropeSemiBold16
                          .textColor(appCtrl.appTheme.darkText)),
                  const VSpace(Sizes.s10),
                Text(
                  chatCtrl.userData["status"] == "Offline"
                      ? _getLastSeenText(int.parse(chatCtrl.userData['lastSeen']))
                      : chatCtrl.userData["status"],
                  textAlign: TextAlign.center,
                  style: AppCss.manropeMedium14.textColor(appCtrl.appTheme.greyText),
                ),
                  const VSpace(Sizes.s20)
                ])),
            Text(
              chatCtrl.userData["statusDesc"],
              textAlign: TextAlign.center,
              style:
                  AppCss.manropeMedium14.textColor(appCtrl.appTheme.darkText),
            )
                .width(MediaQuery.of(context).size.width)
                .paddingAll(Insets.i20)
                .decorated(
                    color: appCtrl.appTheme.greyText,
                    // borderRadius: const BorderRadius.only(
                    //     bottomLeft: Radius.circular(AppRadius.r20),
                    //     bottomRight: Radius.circular(AppRadius.r20))
            ),
            const VSpace(Sizes.s5),
            ChatUserImagesVideos(chatId: chatCtrl.chatId),
            const VSpace(Sizes.s5),
                BlockReportLayout(
                    icon: chatCtrl.isBlock ? eSvgAssets.block : eSvgAssets.unblock,
                    name:
                    "${chatCtrl.isBlock ? appFonts.unblock.tr : appFonts.block.tr} ${chatCtrl.pName}",
                    onTap: () => chatCtrl.blockUser()),
                BlockReportLayout(
                    icon: eSvgAssets.dislike,
                    name: "${appFonts.report.tr} ${chatCtrl.pName!}",
                    onTap: () async {
                      await FirebaseFirestore.instance
                          .collection(collectionName.report)
                          .add({
                        "reportFrom": appCtrl.user["id"],
                        "reportTo": chatCtrl.pId,
                        "isSingleChat": true,
                        "timestamp": DateTime.now().millisecondsSinceEpoch
                      }).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(appFonts.reportSend.tr),
                          backgroundColor: appCtrl.appTheme.primary,
                        ));
                      });
                    }),
            const VSpace(Sizes.s35)
          ]));
    });
  }
}
