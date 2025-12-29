import 'package:cozy/core/component/custom_loading_indicator.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//! BlocLoadingOverlay
class BlocLoadingOverlay<B extends StateStreamable<S>, S>
    extends StatelessWidget {
  final B bloc;
  final bool Function(S state) loadingWhen;
  final Widget child;

  const BlocLoadingOverlay(
      {super.key,
      required this.bloc,
      required this.loadingWhen,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      bloc: bloc,
      buildWhen: (prev, curr) => loadingWhen(prev) != loadingWhen(curr),
      builder: (context, state) {
        final isLoading = loadingWhen(state);
        if (!isLoading) return child;
        return Stack(
          children: [
            child,
            Positioned.fill(
              child: Container(
                color: const Color(0x66000000),
                alignment: Alignment.center,
                child: const SizedBox(
                  width: 36,
                  height: 36,
                  child: CustomLoadingIndicator(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
