import 'package:dishful/common/data/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Logo extends StatelessWidget {
  Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 180,
          height: 180,
          child: SvgPicture.asset(
            "temp-logo.svg",
            width: 180,
            height: 180,
            fit: BoxFit.fill,
            // allowDrawingOutsideViewBox: true,
            placeholderBuilder: (context) => SizedBox(
              width: 125,
              height: 125,
              child: Container(
                decoration: BoxDecoration(
                  color: HexColor.fromHex("#ff4d88"),
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 6),
          child: Text(
            "Dishful",
            style: TextStyle(
              color: Colors.white,
              fontSize: 76,
              fontFamily: "SweetApricot",
            ),
          ),
        ),
      ],
    );
  }
}
