import 'package:btsverse/utils/color.dart';
import 'package:flutter/material.dart';

linearProgress() {
  return Container(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: const LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(purple),
    ),
  );
}

circularProgress() {
  return Container(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(purple),
    ),
  );
}
