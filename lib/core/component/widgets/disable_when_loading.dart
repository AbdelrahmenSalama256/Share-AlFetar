import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//! DisableWhenLoading
class DisableWhenLoading extends StatelessWidget {
  final bool disabled;
  final Widget child;
  final double disabledOpacity;

  const DisableWhenLoading({super.key, required this.disabled, required this.child, this.disabledOpacity = 0.6});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: disabled,
      child: Opacity(
        opacity: disabled ? disabledOpacity : 1.0,
        child: child,
      ),
    );
  }
}

//! BlocDisableWhen
class BlocDisableWhen<B extends StateStreamable<S>, S> extends StatelessWidget {
  final B bloc;
  final bool Function(S state) disabledWhen;
  final Widget child;
  final double disabledOpacity;

  const BlocDisableWhen({super.key, required this.bloc, required this.disabledWhen, required this.child, this.disabledOpacity = 0.6});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      bloc: bloc,
      buildWhen: (prev, curr) => disabledWhen(prev) != disabledWhen(curr),
      builder: (context, state) {
        final disabled = disabledWhen(state);
        return IgnorePointer(
          ignoring: disabled,
          child: Opacity(
            opacity: disabled ? disabledOpacity : 1.0,
            child: child,
          ),
        );
      },
    );
  }
}

