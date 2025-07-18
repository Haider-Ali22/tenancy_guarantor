import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tenancy_guarantor/services/stripe_service.dart';



class StripePaymentScreen extends StatefulWidget {
  @override
  _StripePaymentScreenState createState() => _StripePaymentScreenState();
}

class _StripePaymentScreenState extends State<StripePaymentScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding:  EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            Row(
              children: [
                Text('Your Name : ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Mr Haider Ali'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text('Property Rental Address : ', style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(
                    'Step In Electronics Limited (S7 1FD)',
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 8),

            // Payment Info Header
            Text('Payment Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 8),
            Text(
              'In this section, please provide your payment details to complete the transaction. '
                  'Ensure that all information entered is accurate and up-to-date to avoid any delays or issues with processing your payment. '
                  'If you need more time, you can save the form and return to it later.',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
            SizedBox(height: 24),

            // Card Section
            Text('Credit OR Debit Card', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 12),


            SizedBox(height: 20),

            // Pay Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  StripeService.instance.makePayment();
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 5,
                ),
                child: Text('Continue to Payment Link' ,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// String _cardNumber = '';
// String _expiryDate = '';
// String _cvvCode = '';
// bool _usePaymentLink = false;
// bool _showSaveWithLink = false;
//
// // Card Type Detection
// String? _cardType;
// static const Map<String, String> cardLogos = {
//   'Visa': 'visa',
//   'Mastercard': 'mastercard',
//   'AMEX': 'amex',
//   'JCB': 'jcb',
// };
//
// void onCardNumberChanged(String value) {
//   setState(() {
//     _cardNumber = value;
//
//     final rawNumber = _cardNumber.replaceAll(RegExp(r'\s+'), '');
//     if (rawNumber.length >= 2) {
//       final prefix2 = rawNumber.substring(0, 2);
//       final prefix1 = rawNumber.substring(0, 1);
//
//       if (prefix1 == '4') {
//         _cardType = 'Visa';
//       } else if (int.tryParse(prefix2) != null &&
//           int.parse(prefix2) >= 51 &&
//           int.parse(prefix2) <= 55) {
//         _cardType = 'Mastercard';
//       } else if (prefix2 == '34' || prefix2 == '37') {
//         _cardType = 'AMEX';
//       } else if (['21', '18'].contains(prefix2) ||
//           (int.tryParse(prefix2) != null &&
//               int.parse(prefix2) >= 35 &&
//               int.parse(prefix2) <= 39)) {
//         _cardType = 'JCB';
//       } else {
//         _cardType = null;
//       }
//     } else {
//       _cardType = null;
//     }
//
//     // Update save button visibility
//     _showSaveWithLink = rawNumber.isNotEmpty &&
//         _expiryDate.isNotEmpty &&
//         _cvvCode.isNotEmpty;
//   });
// }

// Future<void> _handlePay() async {
//   if (_usePaymentLink) {
//     const paymentLink = 'https://buy.stripe.com/test_your_link_here';
//     final uri = Uri.parse(paymentLink);
//
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Could not launch payment link')),
//       );
//     }
//   } else {
//     if (_cardNumber.isNotEmpty && _expiryDate.isNotEmpty && _cvvCode.isNotEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Processing manual payment...')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter valid card details')),
//       );
//     }
//   }
// }

// @override
// void initState() {
//   super.initState();
//
//   // Initialize Stripe
//   Stripe.publishableKey = 'pk_test_51Rd9g5CXHSRlgWhHLnBO7B3t1HqLoeT53ecBOlTOZ61Teesvfm0EWefSZMCZsOq1gtPSUdfADmhA4Wt5lSSqkD6G00sMOrGJk4';
//   Stripe.instance.applySettings();
// }


// class _CardNumberInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
//     final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
//     final buffer = StringBuffer();
//
//     for (int i = 0; i < digitsOnly.length; i++) {
//       buffer.write(digitsOnly[i]);
//       if ((i + 1) % 4 == 0 && i != digitsOnly.length - 1) {
//         buffer.write(' ');
//       }
//     }
//
//     return TextEditingValue(
//       text: buffer.toString(),
//       selection: TextSelection.collapsed(offset: buffer.length),
//     );
//   }
// }
//
// class _ExpiryDateFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
//     var text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
//     if (text.length > 2) {
//       text = '${text.substring(0, 2)}/${text.substring(2)}';
//     }
//     return TextEditingValue(
//       text: text,
//       selection: TextSelection.collapsed(offset: text.length),
//     );
//   }
// }




//     if (!_usePaymentLink)
//       Column(
//         children: [
//           // Card Number Field with Logo Inside
//
//       Row(
//       children: [
//       if (_cardType != null)
//     Padding(
//       padding: const EdgeInsets.only(right: 8.0),
//       child: Image.asset(
//         'assets/cards/${cardLogos[_cardType]}.png',
//         width: 40,
//         height: 40,
//         fit: BoxFit.contain,
//       ),
//     ),
//     Expanded(
//       child: TextField(
//         keyboardType: TextInputType.number,
//         inputFormatters: [
//           FilteringTextInputFormatter.digitsOnly,
//           LengthLimitingTextInputFormatter(16),
//           _CardNumberInputFormatter(), // Custom formatter for XXXX XXXX XXXX XXXX
//         ],
//         decoration: InputDecoration(
//           labelText: 'Card Number',
//           hintText: 'XXXX XXXX XXXX XXXX',
//           border: OutlineInputBorder(),
//         ),
//         onChanged: onCardNumberChanged,
//       ),
//     ),
//   ],
// ),

//   SizedBox(height: 16),
//
//   /// Row for Expiry Date and CVV
//   Row(
//     children: [
//       Expanded(
//         child: TextField(
//           keyboardType: TextInputType.number,
//           inputFormatters: [
//             FilteringTextInputFormatter.digitsOnly,
//             LengthLimitingTextInputFormatter(4),
//             _ExpiryDateFormatter(), // Custom MM/YY formatter
//           ],
//           decoration: InputDecoration(
//             labelText: 'Expiry Date',
//             hintText: 'MM/YY',
//             border: OutlineInputBorder(),
//           ),
//           onChanged: (value) => setState(() => _expiryDate = value),
//         ),
//       ),
//       SizedBox(width: 16),
//       Expanded(
//         child: TextField(
//           keyboardType: TextInputType.number,
//           inputFormatters: [
//             FilteringTextInputFormatter.digitsOnly,
//             LengthLimitingTextInputFormatter(3),
//           ],
//           decoration: InputDecoration(
//             labelText: 'CVV',
//             hintText: 'XXX',
//             border: OutlineInputBorder(),
//           ),
//           onChanged: (value) => setState(() => _cvvCode = value),
//         ),
//       ),
//     ],
//   ),
//
//   SizedBox(height: 16),
//
//           // Save with Link Checkbox
//           if (_showSaveWithLink)
//             Align(
//               alignment: Alignment.centerRight,
//               child: CheckboxListTile(
//                 title: Text(
//                   'Save with link',
//                   style: TextStyle(color: Colors.green),
//                 ),
//                 value: _usePaymentLink,
//                 onChanged: (value) {
//                   setState(() {
//                     _usePaymentLink = value!;
//                   });
//                 },
//                 controlAffinity: ListTileControlAffinity.leading,
//                 activeColor: Colors.green,
//                 dense: true,
//                 contentPadding: EdgeInsets.zero,
//               ),
//             ),
//         ],
//       ),
//
//     // Toggle Button between Manual & Payment Link
//     AnimatedSwitcher(
//       duration: Duration(milliseconds: 300),
//       transitionBuilder: (child, animation) => FadeTransition(
//         opacity: animation,
//         child: SizeTransition(
//           sizeFactor: animation,
//           axis: Axis.horizontal,
//           child: child,
//         ),
//       ),
//       child: _usePaymentLink
//           ? Row(
//         key: ValueKey('manual'),
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           TextButton(
//             style: TextButton.styleFrom(
//               backgroundColor: Colors.green.shade800,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//             ),
//             onPressed: () => setState(() => _usePaymentLink = false),
//             child: Text('Use Manual Input', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       )
//           : Align(
//         key: ValueKey('autofill'),
//         alignment: Alignment.centerRight,
//         child: TextButton(
//           onPressed: () => setState(() => _usePaymentLink = true),
//           child: Text(
//             'Autofill link',
//             style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//  ),