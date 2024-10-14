import 'package:chatzy/screens/bottom_screens/call_screen/layouts/call_view.dart';

import '../../../../config.dart';
import '../../../../controllers/bottom_controllers/call_list_controller.dart';

class CallListLayout extends StatelessWidget {
  final AsyncSnapshot<dynamic>? snapshot;
  final List<DocumentSnapshot>? results;
  const CallListLayout({super.key, this.snapshot,this.results});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CallListController>(builder: (callListCtrl) {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: Insets.i10),
        itemBuilder: (context, index) {
          return CallView(
            snapshot:snapshot != null?  snapshot!.data!.docs[index].data():results![index].data(),
            index: index,
            userId: appCtrl.user["id"],
          );
        },
        itemCount:snapshot != null?  snapshot!.data!.docs.length:results!.length,
      );
    });
  }
}
