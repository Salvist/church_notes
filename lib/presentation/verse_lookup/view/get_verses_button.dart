import 'package:church_notes/presentation/verse_lookup/cubit/verse_lookup_cubit.dart';
import 'package:church_notes/presentation/verse_lookup/cubit/verse_lookup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';

class GetVersesButton extends StatelessWidget {
  final QuillController controller;
  const GetVersesButton({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerseLookupCubit, VerseLookupState>(
      builder: (context, state) {
        return TextButton(
          onPressed: state.isLoading
              ? null
              : () {
                  FocusScope.of(context).unfocus();
                  context.read<VerseLookupCubit>().getPassages(controller);
                },
          child: const Text('Get verses'),
        );
      },
    );
  }
}
