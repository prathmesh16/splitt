import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splitt/features/expense/domain/currency_data_store.dart';

class CurrencyAmount extends StatelessWidget {
  final String amount;
  final TextStyle? style;

  const CurrencyAmount({
    super.key,
    required this.amount,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: CurrencyDataStore()
                .getCurrencySymbol(CurrencyDataStore().selectedCurrency),
            style: GoogleFonts.notoSans(
              textStyle: style?.copyWith(
                fontFamilyFallback: const [],
              ),
            ),
          ),
          TextSpan(
            text: amount,
            style: GoogleFonts.poppins(
              textStyle: style,
            ),
          ),
        ],
      ),
    );
  }
}
