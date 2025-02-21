import 'dart:developer';
import '../../../../config.dart';

class MessageCardSubTitle extends StatelessWidget {
  final DocumentSnapshot? document;
  final String? currentUserId, blockBy,name;
final dynamic data;
  const MessageCardSubTitle({super.key, this.document, this.currentUserId,this.blockBy,this.name, this.data});

  @override
  Widget build(BuildContext context) {

    return  Row(children: [
      if (currentUserId == document!["senderId"])
        Icon(Icons.done_all_outlined,
            color: document!["isSeen"]
                ? appCtrl.appTheme.sameWhite
                : appCtrl.appTheme.tick,
            size: Sizes.s16),
      if (currentUserId == document!["senderId"])
        const HSpace(Sizes.s5),
      Expanded(
        child: Text(
            (decryptMessage(document!["lastMessage"])
                .contains("media"))
                ? "$name Media Share"
                : document!["isBlock"] == true &&
                document!["isBlock"] == "true"
                ? document!["blockBy"] != blockBy
                ? document![
            "blockUserMessage"]
                : decryptMessage(document!["lastMessage"])
                .contains("http")
                : (decryptMessage(document!["lastMessage"])
                .contains(".pdf") ||
                decryptMessage(document!["lastMessage"])
                    .contains(".doc") ||
                decryptMessage(document!["lastMessage"])
                    .contains(".mp3") ||
                decryptMessage(document!["lastMessage"])
                    .contains(".mp4") ||
                decryptMessage(document!["lastMessage"])
                    .contains(".xlsx") ||
                decryptMessage(document!["lastMessage"])
                    .contains(".ods"))
                ? decryptMessage(document!["lastMessage"])
                .split("-BREAK-")[0]
                : decryptMessage(document!["lastMessage"]),
            style: AppCss.manropeMedium12
                .textColor(appCtrl.appTheme.greyText).textHeight(1.2),
            overflow: TextOverflow.ellipsis),
      )
    ]).width(Sizes.s170);
  }
}
