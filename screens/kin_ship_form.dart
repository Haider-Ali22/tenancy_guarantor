import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NextOfKinForm extends StatefulWidget {
  @override
  _NextOfKinFormState createState() => _NextOfKinFormState();
}

class _NextOfKinFormState extends State<NextOfKinForm> {

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  String fullName = '';
  String relationship = '';
  String mobile = '';
  String email = '';
  String confirmEmail = '';
  bool livesInUK = true;
  String residentialAddress = '';
  String postcode = '';


  List<String> addressList = [];
  String? selectedFullAddress;
  String addressLine1 = '';
  String addressLine2 = '';
  String city = '';
  String county = '';
  String selectedPostcode = '';

  TextEditingController postcodeController = TextEditingController();


  String getAddressApiKey = 'qNVLBUHKo0S0xiV7asTxKQ9741'; // Replace with your API Key


  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countyController = TextEditingController();
  final TextEditingController postcodeFilledController = TextEditingController();




  Future<void> fetchAddresses(String postcode) async {
    final url = Uri.parse(
      'https://api.getAddress.io/find/${postcode.trim()}?api-key=$getAddressApiKey',
    );

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      setState(() {
        addressList = List<String>.from(json['addresses']);
        selectedPostcode = json['postcode'] ?? '';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to fetch address for postcode"),
      ));
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
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
                "Tell us about your next of kin:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Please answer all questions honestly and accurately to avoid any delays or negative results with your reference.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              Divider(),
SizedBox(height:5),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full Name
                  Text(
                    "What is their full name? *",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Full Name",
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? "Required" : null,
                    onSaved: (value) => fullName = value!,
                  ),
                  SizedBox(height: 10),

                  // Relationship
                  Text(
                    "What is their relationship to you? *",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Relationship",
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? "Required" : null,
                    onSaved: (value) => relationship = value!,
                  ),
                  SizedBox(height: 10),

                  // Mobile Number
                  Text(
                    "Please provide their mobile phone number *",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Mobile Number",
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? "Required" : null,
                    onSaved: (value) => mobile = value!,
                  ),
                  SizedBox(height: 10),

                  // Email
                  Text(
                    "Please provide their email address *",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email Address",
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? "Required" : null,
                    onSaved: (value) => email = value!,
                  ),
                  SizedBox(height: 10),

                  // Confirm Email
                  Text(
                    "Please confirm their email address *",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Confirm Email",
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    validator: (value) =>
                    value != email ? "Emails do not match" : null,
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  SizedBox(height: 10),
                ],
              ),

    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Does your next of kin live in the United Kingdom?", style: TextStyle(fontWeight: FontWeight.bold),),
        SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Yes Option
                Flexible(
                  child: IntrinsicWidth(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: livesInUK == true ? Colors.green : Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: livesInUK,
                            onChanged: (value) {
                              setState(() {
                                livesInUK = value!;
                                addressList.clear();
                                selectedFullAddress = null;
                                addressLine1 = '';
                                addressLine2 = '';
                                city = '';
                                county = '';
                                postcodeController.clear();
                              });
                            },
                            fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                              return states.contains(MaterialState.selected)
                                  ? Colors.green
                                  : Colors.grey;
                            }),
                          ),
                          Text("Yes"),
                          SizedBox(width: 12),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 8),

                // Vertical Divider
                Container(
                  height: 28,
                  width: 1,
                  color: Colors.grey[400],
                ),

                SizedBox(width: 8),

                // No Option
                Flexible(
                  child: IntrinsicWidth(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: livesInUK == false ? Colors.red : Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        children: [
                          Radio<bool>(
                            value: false,
                            groupValue: livesInUK,
                            onChanged: (value) {
                              setState(() {
                                livesInUK = value!;
                                postcodeController.clear();
                                addressList.clear();
                                selectedFullAddress = null;
                                addressLine1 = '';
                                addressLine2 = '';
                                city = '';
                                county = '';
                              });
                            },
                            fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                              return states.contains(MaterialState.selected)
                                  ? Colors.red
                                  : Colors.grey;
                            }),
                          ),
                          Text("No"),
                          SizedBox(width: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 5),
          ],
        ),



        if (livesInUK) ...[

          Text(
            "What is their residential address? *",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child:   TextFormField(
                  controller: postcodeController,
                  decoration: InputDecoration(
                    hintText: "Enter Postcode",
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff006eff),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric( vertical: 12),
                ),
                onPressed: () {
                  if (postcodeController.text.isNotEmpty) {
                    fetchAddresses(postcodeController.text);
                  }
                },
                child: Icon(Icons.search, size: 25),
              ),
            ],
          ),


          SizedBox(height: 10),
          Divider(),
          SizedBox(height: 10),


          // Dropdown List of Addresses
          if (addressList.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Address from Dropdown List*",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    hintText: "Select Your Address",
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  value: selectedFullAddress,
                  onChanged: (value) {
                    final parts = value!.split(',').map((e) => e.trim()).toList();

                    print("Selected Address Parts: ${parts.toString()}");

                    String addressLine1 = '';
                    String addressLine2 = '';
                    String city = '';
                    String county = '';

                    if (parts.isNotEmpty) {
                      if (parts.length >= 1) addressLine1 = parts[0];
                      if (parts.length >= 2) addressLine2 = parts[1];
                      if (parts.length >= 3) city = parts[parts.length - 2];
                      if (parts.length >= 4) county = parts[parts.length - 1];
                    }

                    setState(() {
                      selectedFullAddress = value;
                      addressLine1Controller.text = addressLine1;
                      addressLine2Controller.text = addressLine2;
                      cityController.text = city;
                      countyController.text = county;
                      postcodeFilledController.text = postcodeController.text.trim().toUpperCase();
                    });
                  },
                  items: addressList.map((addr) {
                    return DropdownMenuItem(
                      value: addr,
                      child: Text(
                        addr,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),

          SizedBox(height: 10),

          if (selectedFullAddress != null) ...[

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Address Line 1
                Text("Address Line 1", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextFormField(
                  controller: addressLine1Controller,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Address Line 1",
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                SizedBox(height: 10),

                // Address Line 2
                Text("Address Line 2", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextFormField(
                  controller: addressLine2Controller,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Address Line 2",
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                SizedBox(height: 10),

                // City / Town
                Text("City / Town", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextFormField(
                  controller: cityController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "City / Town",
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                SizedBox(height: 10),

                // County
                Text("County", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextFormField(
                  controller: countyController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "County",
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                SizedBox(height: 10),

                // Postcode
                Text("Postcode", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextFormField(
                  controller: postcodeFilledController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Postcode",
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
              ],
            ),

          ]
        ],

        if (!livesInUK)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Please provide the full address of your next of kin including the country *",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextFormField(
                minLines: 1, // Reduced from 3
                maxLines: null, // Still expandable
                decoration: InputDecoration(
                  hintText: "Residential Address",
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Reduced vertical padding
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (!livesInUK && (value == null || value.isEmpty)) return "Required";
                  return null;
                },
                onSaved: (value) => residentialAddress = value!,
              ),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
            ],
          ),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                backgroundColor: Colors.green[800],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  print("Postcode: ${postcodeController.text}");
                  print("Selected Address: $selectedFullAddress");
                  print("Line 1: $addressLine1");
                  print("City: $city");
                  print("County: $county");

                  _pageController.animateToPage(
                    4,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Text("Next"),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    ),

            ],
          ),
        ),
      ),
    );
  }
}