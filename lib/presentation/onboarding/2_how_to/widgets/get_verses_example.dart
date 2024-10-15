import 'package:church_notes/domain/enums/bible_version.dart';
import 'package:church_notes/domain/models/passage.dart';
import 'package:church_notes/presentation/onboarding/2_how_to/cubit/passage_cubit.dart';
import 'package:church_notes/presentation/onboarding/2_how_to/cubit/passage_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetVersesExample extends StatelessWidget {
  const GetVersesExample({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<PassageCubit, PassageState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.onSurface),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Jeremiah 29:11'),
                  TextButton(
                    onPressed: () {
                      const reference = BibleReference(
                        bookName: 'Jeremiah',
                        chapter: 29,
                        verseStart: 11,
                        version: BibleVersion.asv,
                        matchStart: 0,
                        matchEnd: 1,
                      );
                      context.read<PassageCubit>().fetchPassage(reference);
                    },
                    child: const Text('Get verses'),
                  ),
                ],
              ),
              if (state is PassageSuccess) Text(state.passage.versesText)
            ],
          ),
        );
      },
    );
  }
}
