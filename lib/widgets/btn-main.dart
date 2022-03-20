import 'package:flutter/material.dart';

class BtnMain extends StatelessWidget {

  final String title;
  final  onTap;

  const BtnMain({Key? key, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 20,),),
      ),
    );
  }
}
