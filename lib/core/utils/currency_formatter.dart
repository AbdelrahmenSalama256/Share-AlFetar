import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/global_cubit.dart';




String formatCurrency(BuildContext context, num amount, {bool withCode = false}) {
  final cubit = context.read<GlobalCubit>();
  final symbol = cubit.currencySymbol;
  final code = cubit.currencyCode;
  final value = amount.isFinite ? amount.toStringAsFixed(2) : '0.00';

  final isAlphabetic = RegExp(r'^[A-Za-z]+$').hasMatch(symbol);

  if (withCode) {

    return isAlphabetic ? '$value $symbol' : '$symbol$value $code';
  }

  return isAlphabetic ? '$value $symbol' : '$symbol$value';
}

