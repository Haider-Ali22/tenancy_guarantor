import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'dart:convert'; // For base64 encoding


class PropertyRentalForm extends StatefulWidget {
  @override
  _PropertyRentalFormState createState() => _PropertyRentalFormState();
}

class _PropertyRentalFormState extends State<PropertyRentalForm> {


  SignatureController signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
  );

  bool agreedToTerms = false;

  void submitApplication() {
    if (!agreedToTerms) {
      _showDialog(context, 'Please agree to the terms and conditions.');
      return;
    }

    if (signatureController.isEmpty) {
      _showDialog(context, 'Please provide a signature.');
      return;
    }

    // Export signature as PNG image data
    signatureController.toPngBytes().then((value) {
      if (value != null) {
        String base64Signature = base64Encode(value);
        print('Signature (Base64): data:image/png;base64,$base64Signature');

        _showDialog(context, 'Form submitted successfully!');
      }
    });
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
           padding:  EdgeInsets.all(16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Text(
                  'Time to submit your application form',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Do you want to tell us anything else about your application?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 8),
                TextField(
                  minLines: 2,
                  maxLines: null,
                  decoration: InputDecoration(
                      hintText: 'Type here',
                      border: OutlineInputBorder()),
                ),
                SizedBox(height: 16),
                // Signature Field
                Text(
                  'Please sign in the box below with your finger signature*',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: Signature(
                    controller: signatureController,

                    backgroundColor: Color(0xffffffff),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  ' Put your signature in the box above by using your finger',
                  style: TextStyle(color: Colors.black,fontSize: 12, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 10),
                // Clear Signature Button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue[800],
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                        side: BorderSide(color: Colors.blue[800]!, width: 1.5),
                      ),
                    ),
                    onPressed: () {
                      signatureController.clear();
                    },
                    child: Text('Clear Signature'),
                  ),
                ),
                // Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: agreedToTerms,
                      onChanged: (value) {
                        setState(() {
                          agreedToTerms = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        'I agree to be referenced and have read and understood the terms, conditions, and privacy policy.',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Submit Button
                ElevatedButton(
                  onPressed: submitApplication,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.green[800],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Hood/capsule shape
                    ),
                  ),
                  child: Text('Submit Application'),
                ),
                SizedBox(height: 20),
              ],
          ),
      ),
    );
  }
}