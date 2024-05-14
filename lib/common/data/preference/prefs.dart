import 'package:kaedoo/common/data/preference/item/nullable_preference_item.dart';
import 'package:kaedoo/common/theme/custom_theme.dart';

class Prefs {
  static final appTheme = NullablePreferenceItem<CustomTheme>('appTheme');
}
