import 'package:dots/generated/l10n.dart';
import 'package:flutter/material.dart';


List getItems(BuildContext context) => [
  {
    "header": S.of(context).item1Header,
    "description": S.of(context).item1Description,
    "image": "images/dotsLogo.png",
  },
  {
    "header": S.of(context).item2Header,
    "description": S.of(context).item2Description,
    "image": "images/3.png",
  },
  {
    "header": S.of(context).item3Header,
    "description": S.of(context).item3Description,
    "image": "images/2.png",
  },
  {
    "header": S.of(context).item4Header,
    "description": S.of(context).item4Description,
    "image": "images/4.png",
  },
  {
    "header": S.of(context).item5Header,
    "description": S.of(context).item5Description,
    "image": "images/5.png",
  },
];