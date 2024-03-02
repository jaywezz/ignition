//styles constants
import 'package:flutter/cupertino.dart';
import 'package:soko_flow/utils/size_utils2.dart';

// double defaultPadding = SizeConfig.blockSizeHorizontal *
//     (SizeConfig.isTabletWidth ? 3 : (SizeConfig.isTall ? 4 : 3));
defaultPadding(BuildContext context) {
  return MediaQuery.of(context).size.width /
      100 *
      (Responsive.isTablet(context) ? 3 : (Responsive.isTall(context) ? 4 : 3));
}

double defaultRadius1 = 11;
const defaultDuration = Duration(seconds: 1);
