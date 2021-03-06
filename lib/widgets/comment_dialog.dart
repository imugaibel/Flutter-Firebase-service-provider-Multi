import 'package:flutter/material.dart';
import 'package:maintenance/utils/app_localization.dart';

import 'btn-main.dart';

commentDialog(context, {required String titleBtn, action}) {
  String commentEN = "";
  String commentAR = "";

  AlertDialog alert = AlertDialog(
    content: SizedBox(
      height: MediaQuery.of(context).size.height * (180 / 812),
      child: Column(
        children: [
          TextField(
            onChanged: (value) => commentEN = value.trim(),
            decoration: InputDecoration(
                hintText:
                    AppLocalization.of(context)!.translate("write comment EN")),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            onChanged: (value) => commentAR = value.trim(),
            decoration: InputDecoration(
                hintText:
                    AppLocalization.of(context)!.translate("write comment AR")),
          ),
          const Expanded(child: SizedBox()),
          SizedBox(
              height: MediaQuery.of(context).size.height * (40 / 812),
              child: BtnMain(title: titleBtn, onTap: () => action(commentEN, commentAR),)
          ),

        ],
      ),
    ),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
