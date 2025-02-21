import 'dart:developer';
import 'package:chatzy/widgets/common_media_share_screen.dart';
import 'package:chatzy/widgets/media_share_layout.dart';
import '../../../../../config.dart';

class ChatUserImagesVideos extends StatelessWidget {
  final String? chatId;
  final chatCtrl = Get.put(ChatLayoutController());

  ChatUserImagesVideos({super.key, this.chatId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatLayoutController>(builder: (chatCtrl) {
      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(appCtrl.user["id"])
            .collection(collectionName.messages)
            .doc(chatId)
            .collection(collectionName.chat)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List messages = [];
            List docs = [];
            List links = [];
            if (snapshot.data!.docs.isNotEmpty) {
              snapshot.data!.docs.asMap().entries.forEach((e) {
                log("MESSAGE LIST ${e.value.data()}");
                if (e.value.data()["type"] == MessageType.image.name ||
                    e.value.data()["type"] == MessageType.video.name) {
                  messages.add(e.value.data());
                } else if (e.value.data()["type"] == MessageType.doc.name) {
                  docs.add(e.value.data());
                } else if (e.value.data()["type"] == MessageType.link.name) {
                  links.add(e.value.data());
                }
              });
            }
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...chatCtrl.mediaList
                      .asMap()
                      .entries
                      .map((e) => MediaShareLayout(
                          index: e.key,
                          list: chatCtrl.mediaList,
                          title: e.value,
                          mediaCount: e.key == 0
                              ? messages.length.toString()
                              : e.key == 1
                                  ? docs.length.toString()
                                  : links.length.toString(),
                          onTap: () {
                            final mediaCtrl = Get.put(MediaShareController());
                            if (e.key == 0) {
                              mediaCtrl.selectedIndex = e.key;
                            }
                            if (e.key == 1) {
                              mediaCtrl.selectedIndex = e.key;
                            }
                            if (e.key == 2) {
                              mediaCtrl.selectedIndex = e.key;
                            }
                            Get.to(() => CommonMediaShareScreen(), arguments: {
                              "message": messages,
                              "docs": docs,
                              "links": links,
                              "index": e.key
                            });
                          })),
                  Divider(
                          height: 1,
                          thickness: 1,
                          color: appCtrl.appTheme.borderColor)
                      .paddingSymmetric(vertical: Insets.i20),
                ]);
          } else {
            return Container();
          }
        },
      );
    });
  }
}
