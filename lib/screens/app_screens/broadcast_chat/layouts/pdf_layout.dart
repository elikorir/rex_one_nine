import 'dart:developer';
import 'package:intl/intl.dart';
import '../../../../config.dart';
import '../../../../widgets/broadcast_pdf_content.dart';

class PdfLayout extends StatefulWidget {
  final MessageModel? document;
  final GestureLongPressCallback? onLongPress;
  final GestureTapCallback? onTap;
  final bool isReceiver, isGroup, isBroadcast;
  final String? currentUserId;

  const PdfLayout(
      {super.key,
      this.document,
      this.onLongPress,
      this.onTap,
      this.isReceiver = false,
      this.isGroup = false,
      this.isBroadcast = false,
      this.currentUserId})
     ;

  @override
  State<PdfLayout> createState() => _PdfLayoutState();
}

class _PdfLayoutState extends State<PdfLayout> {
/*  PDFDocument? doc;*/
  bool downloading = false, isSeen = false;
  var progressString = "";

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  getData() async {
    isSeen = widget.document!.isSeen ?? false;
    log("LINK : ${decryptMessage(widget.document!.content).split("-BREAK-")[1]}");
  /*  doc = await PDFDocument.fromURL(decryptMessage(widget.document!.content)
        .split("-BREAK-")[1]
        .toString());
    setState(() {});
    log("DOC : $doc");*/
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Stack(clipBehavior: Clip.none, children: [
          PdfContentLayout(
              isGroup: widget.isGroup,
              currentUserId: widget.currentUserId,
              // doc: doc,
              document: widget.document,
              isBroadcast: widget.isBroadcast,
              isReceiver: widget.isReceiver),
          if (widget.document!.emoji != null)
            EmojiLayout(emoji: widget.document!.emoji)
        ]),
        IntrinsicHeight(
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          if (widget.document!.isFavourite != null)
            if (widget.document!.isFavourite == true)
              if (appCtrl.user["id"].toString() ==
                  widget.document!.favouriteId.toString())
                Icon(Icons.star,
                    color: appCtrl.appTheme.greyText, size: Sizes.s10),
          const HSpace(Sizes.s3),
          if (!widget.isGroup)
            if (!widget.isReceiver || !widget.isBroadcast)
              Icon(Icons.done_all_outlined,
                  size: Sizes.s15,
                  color: isSeen == true
                      ? appCtrl.appTheme.primary
                      : appCtrl.appTheme.greyText),
          const HSpace(Sizes.s5),
          Text(
              DateFormat('HH:mm a').format(DateTime.fromMillisecondsSinceEpoch(
                  int.parse(widget.document!.timestamp.toString()))),
              style:
                  AppCss.manropeMedium12.textColor(appCtrl.appTheme.greyText))
        ]).marginSymmetric(vertical: Insets.i3))
      ]).marginSymmetric(horizontal: Insets.i10, vertical: Insets.i5),
    );
  }
}
