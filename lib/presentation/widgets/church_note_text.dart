import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChurchNotesText extends StatelessWidget {
  const ChurchNotesText({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      'Church Notes',
      style: GoogleFonts.pacifico(fontSize: textTheme.displayLarge?.fontSize),
    );
  }
}
