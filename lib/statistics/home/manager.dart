import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../view/widget_success.dart';
import '../bloc/bloc.dart';

/*
 * Main description:
 This class build screen basing on bloc state
 */
class Manager extends StatelessWidget {
  const Manager({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsBloc, StatsState>(
        builder: (context, state) {
          return state.status.isSuccess
              ? WidgetSuccessStats(menu: state.menu)
              : state.status.isLoading
              ? const Center(child: CircularProgressIndicator(),)
              : state.status.isError
              ? const Center(child: Text('Error'),)
              : const SizedBox();
        }
    );
  }
}