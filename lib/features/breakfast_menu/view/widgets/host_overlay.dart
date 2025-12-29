import 'package:cozy/features/mode/view/cubit/mode_cubit.dart';
import 'package:cozy/features/overlay/view/cubit/popup_cubit.dart';
import 'package:cozy/features/overlay/view/cubit/popup_state.dart';
import 'package:cozy/features/overlay/view/widgets/order_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../mode/data/repo/mode_repo.dart';
import '../../../order/data/model/breakfast_request_model.dart';
import '../../../order/view/cubit/order_cubit.dart';

class HostOverlay extends StatelessWidget {
  const HostOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<ModeCubit>().state.mode;
    if (mode != UserMode.host) return const SizedBox.shrink();

    return BlocBuilder<PopupCubit, PopupState>(
      builder: (context, state) {
        if (state is PopupVisible) {
          return Container(
            margin: EdgeInsets.only(bottom: 20.h),
            child: OrderPopup(
              request: state.request,
              onAccept: () {
                context
                    .read<OrderCubit>()
                    .respondToRequest(state.request.id, RequestStatus.accepted);
                context.read<PopupCubit>().clear();
              },
              onReject: () {
                context
                    .read<OrderCubit>()
                    .respondToRequest(state.request.id, RequestStatus.rejected);
                context.read<PopupCubit>().clear();
              },
              onDismiss: () => context.read<PopupCubit>().clear(),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
