import 'package:flutter/cupertino.dart';

import '../../utils/modal.dart';
import '../dialog/info.dart';

class QuestionMarkTooltip extends StatelessWidget {
  final String message;

  const QuestionMarkTooltip({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ModalUtils.showBaseDialog(
        context,
        BaseInfoDialog(
          body: this.message,
        ),
      ),
      child: const Icon(
        CupertinoIcons.question_circle_fill,
      ),
    );
    // return CustomTooltip(
    //   message: this.message,
    //   padding: EdgeInsets.all(12.0),
    //   margin: EdgeInsets.all(32.0),
    //   preferBelow: false,
    //   verticalOffset: 2.0,
    //   waitDuration: Duration(milliseconds: 0),
    //   showDuration: Duration(seconds: 5),
    //   immediately: true,
    //   child: Icon(StylingHelper.question),
    // );
  }
}
