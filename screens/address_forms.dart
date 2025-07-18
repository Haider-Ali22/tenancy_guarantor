import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import '../consts.dart';

class AddressSectionModel {
  // Text controllers
  final postcodeFilledCtrl = TextEditingController();
  final postcodeCtrl = TextEditingController();
  final flatCtrl = TextEditingController();
  final houseNoCtrl = TextEditingController();
  final houseNameCtrl = TextEditingController();
  final line1Ctrl = TextEditingController();
  final line2Ctrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final countyCtrl = TextEditingController();
  final additionalInfoCtrl = TextEditingController();     // other

  // Dynamic dropdown list when searching by postcode

  List<String> addressList = [];
  String? selectedFullAddress;
  String? selectedPostcode;


  final TextEditingController arrearsAmountCtrl;

  AddressSectionModel() : arrearsAmountCtrl = TextEditingController();

  // State fields
  bool? livesInUK;            // “Do you live in the UK?”
  bool? wasLivedInUK;         // for previous addresses
  String? residencyType;      // Renting / Home owner / etc.
  String? movedInMonth;
  String? movedInYear;
  String? rentalArrears;      // Yes / No / N/A
  String? proofType;          // proof‑of‑address doc
  String? chosenFileName;     // uploaded file
  String? selectedCountry;


  /// helper → convert to JSON object for API call
  Map<String, dynamic> toJson() => {
    "livesInUK": livesInUK,
    "wasLivedInUK": wasLivedInUK,
    "postcodeFilled": postcodeCtrl.text.trim(),
    "postcode": postcodeCtrl.text.trim(),
    "flatNumber": flatCtrl.text.trim(),
    "houseNumber": houseNoCtrl.text.trim(),
    "houseName": houseNameCtrl.text.trim(),
    "addressLine1": line1Ctrl.text.trim(),
    "addressLine2": line2Ctrl.text.trim(),
    "city": cityCtrl.text.trim(),
    "county": countyCtrl.text.trim(),
    "residencyType": residencyType,
    "movedInMonth": movedInMonth,
    "movedInYear": movedInYear,
    "rentalArrears": rentalArrears,
    "arrearsAmount": arrearsAmountCtrl.text.trim(),
    "additionalInfo": additionalInfoCtrl.text.trim(),
    "proofType": proofType,
  };

  void dispose() {
    postcodeFilledCtrl.dispose();
    postcodeCtrl.dispose();
    flatCtrl.dispose();
    houseNoCtrl.dispose();
    houseNameCtrl.dispose();
    line1Ctrl.dispose();
    line2Ctrl.dispose();
    cityCtrl.dispose();
    countyCtrl.dispose();
    arrearsAmountCtrl.dispose();
    additionalInfoCtrl.dispose();
  }
}


class AddressHistoryFormPage extends StatefulWidget {
   AddressHistoryFormPage({Key? key}) : super(key: key);

  @override
  State<AddressHistoryFormPage> createState() => _AddressHistoryFormPageState();
}

class _AddressHistoryFormPageState extends State<AddressHistoryFormPage> {
  // First section is always “current address”
  final List<AddressSectionModel> _sections = [AddressSectionModel()];


  final List<String> countries = [
    'Afghanistan',
    'Albania',
    'Algeria',
    'Andorra',
    'Angola',
    'Antigua and Barbuda',
    'Argentina',
    'Armenia',
    'Australia',
    'Austria',
    'Azerbaijan',
    'Bahamas',
    'Bahrain',
    'Bangladesh',
    'Barbados',
    'Belarus',
    'Belgium',
    'Belize',
    'Benin',
    'Bhutan',
    'Bolivia',
    'Bosnia and Herzegovina',
    'Botswana',
    'Brazil',
    'Brunei',
    'Bulgaria',
    'Burkina Faso',
    'Burundi',
    'Cabo Verde',
    'Cambodia',
    'Cameroon',
    'Canada',
    'Central African Republic',
    'Chad',
    'Chile',
    'China',
    'Colombia',
    'Comoros',
    'Congo (Congo-Brazzaville)',
    'Costa Rica',
    'Croatia',
    'Cuba',
    'Cyprus',
    'Czechia (Czech Republic)',
    'Denmark',
    'Djibouti',
    'Dominica',
    'Dominican Republic',
    'Ecuador',
    'Egypt',
    'El Salvador',
    'Equatorial Guinea',
    'Eritrea',
    'Estonia',
    'Eswatini (fmr. "Swaziland")',
    'Ethiopia',
    'Fiji',
    'Finland',
    'France',
    'Gabon',
    'Gambia',
    'Georgia',
    'Germany',
    'Ghana',
    'Greece',
    'Grenada',
    'Guatemala',
    'Guinea',
    'Guinea-Bissau',
    'Guyana',
    'Haiti',
    'Honduras',
    'Hungary',
    'Iceland',
    'India',
    'Indonesia',
    'Iran',
    'Iraq',
    'Ireland',
    'Israel',
    'Italy',
    'Jamaica',
    'Japan',
    'Jordan',
    'Kazakhstan',
    'Kenya',
    'Kiribati',
    'Korea, North',
    'Korea, South',
    'Kosovo',
    'Kuwait',
    'Kyrgyzstan',
    'Laos',
    'Latvia',
    'Lebanon',
    'Lesotho',
    'Liberia',
    'Libya',
    'Liechtenstein',
    'Lithuania',
    'Luxembourg',
    'Madagascar',
    'Malawi',
    'Malaysia',
    'Maldives',
    'Mali',
    'Malta',
    'Marshall Islands',
    'Mauritania',
    'Mauritius',
    'Mexico',
    'Micronesia',
    'Moldova',
    'Monaco',
    'Mongolia',
    'Montenegro',
    'Morocco',
    'Mozambique',
    'Myanmar (formerly Burma)',
    'Namibia',
    'Nauru',
    'Nepal',
    'Netherlands',
    'New Zealand',
    'Nicaragua',
    'Niger',
    'Nigeria',
    'North Macedonia',
    'Norway',
    'Oman',
    'Pakistan',
    'Palau',
    'Palestine State',
    'Panama',
    'Papua New Guinea',
    'Paraguay',
    'Peru',
    'Philippines',
    'Poland',
    'Portugal',
    'Qatar',
    'Romania',
    'Russia',
    'Rwanda',
    'Saint Kitts and Nevis',
    'Saint Lucia',
    'Saint Vincent and the Grenadines',
    'Samoa',
    'San Marino',
    'Sao Tome and Principe',
    'Saudi Arabia',
    'Senegal',
    'Serbia',
    'Seychelles',
    'Sierra Leone',
    'Singapore',
    'Slovakia',
    'Slovenia',
    'Solomon Islands',
    'Somalia',
    'South Africa',
    'South Sudan',
    'Spain',
    'Sri Lanka',
    'Sudan',
    'Suriname',
    'Sweden',
    'Switzerland',
    'Syria',
    'Taiwan',
    'Tajikistan',
    'Tanzania',
    'Thailand',
    'Timor-Leste',
    'Togo',
    'Tonga',
    'Trinidad and Tobago',
    'Tunisia',
    'Turkey',
    'Turkmenistan',
    'Tuvalu',
    'Uganda',
    'Ukraine',
    'United Arab Emirates',
    'United Kingdom',
    'United States of America',
    'Uruguay',
    'Uzbekistan',
    'Vanuatu',
    'Vatican City',
    'Venezuela',
    'Vietnam',
    'Yemen',
    'Zambia',
    'Zimbabwe',
    'Other'
  ];

  // static lists -------------------------------------------------
  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  final List<String> _years =
  List.generate(100, (i) => (DateTime.now().year - i).toString());


  bool showPreviousAddressSection = false;

  // // -------------------- Date check -------------------------
  // void _checkAddressDate(AddressSectionModel currentSection) {
  //   if (currentSection.movedInMonth != null && currentSection.movedInYear != null) {
  //     final int month = _months.indexOf(currentSection.movedInMonth!) + 1;
  //     final int year = int.parse(currentSection.movedInYear!);
  //     final selectedDate = DateTime(year, month);
  //     final threeYearsAgo = DateTime(DateTime.now().year - 3, DateTime.now().month);
  //
  //     final isWithinThreeYears = selectedDate.isAfter(threeYearsAgo);
  //
  //     setState(() {
  //       showPreviousAddressSection = isWithinThreeYears;
  //       // Add/remove section based on the condition
  //       if (isWithinThreeYears && _sections.length == 1) {
  //         _sections.add(AddressSectionModel());
  //       } else if (!isWithinThreeYears && _sections.length > 1) {
  //         _sections.removeLast();
  //       }
  //     });
  //   }
  // }


  void _checkAddressDate(AddressSectionModel currentSection, int index) {
    if (currentSection.movedInMonth != null && currentSection.movedInYear != null) {
      final selectedYear = int.tryParse(currentSection.movedInYear ?? '');
      final isInRange = selectedYear != null && (selectedYear >= 2023 && selectedYear <= 2025);

      setState(() {
        if (isInRange && index == _sections.length - 1) {
          _sections.add(AddressSectionModel());
        }
      });
    }
  }


  final List<String> _residencyTypes = const [
    "Renting from landlord or letting agent",
    "Council or social or housing association",
    "Living with family or friends",
    "Student Accommodation",
    "Homeowner",
    "Other",
  ];

  // listener for £ formatting -----------------------------------
  @override
  void initState() {
    super.initState();
    final ctrl = _sections[0].arrearsAmountCtrl;
    ctrl.addListener(() {
      String txt = ctrl.text.replaceAll('£', '').trim();
      if (txt.isNotEmpty) {
        ctrl.value = TextEditingValue(
          text: '£ $txt',
          selection: TextSelection.collapsed(offset: '£ $txt'.length),
        );
      }
    });
  }


  final List<String> documentsLast3Months = [
    'Gas Bill',
    'Electricity Bill',
    'Telephone Bill',
    'Water Supply Bill',
    'Mobile Phone Bill',
    'Bank Statement',
    'Building Society Statement',
    'Credit Card Statement',
    'Cable Television Subscription',
    'Broadband Services',
    'Council Tax Bill (current year)',
    'Mortgage Statement',
    'DWP Document for Child Allowance',
    'Current local council rent card or tenancy agreement',
  ];
  final List<String> documentsLast6Months = [
    'HM Revenue and Customs tax notification (P60 and P45 is not acceptable)',
    'Government issued Benefits documents',
    'Pension Statement',
    'Voter Registration',
    'Driver\'s License',
    'Home Insurance',
    'Payslip from UK Employer',
    'Letter from Employer on Company Headed Paper',
  ];


  //–––––––––––– postcode fetch ––––––––––––
  Future<void> _fetchAddresses(AddressSectionModel s) async {
    final code = s.postcodeCtrl.text.trim();
    if (code.isEmpty) return;

    final uri = Uri.parse(
        'https://api.getAddress.io/find/$code?api-key=$getAddressApiKey');
    final res = await http.get(uri);

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      setState(() {
        s.addressList = List<String>.from(json['addresses']);
        s.selectedPostcode = json['postcode'] ?? '';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to fetch address for postcode'),
      ));
    }
  }

  InputDecoration _inputDec(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.grey.shade100,
    isDense: true,
    contentPadding:
     EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade400),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:  BorderSide(color: Colors.blue, width: 1.5),
    ),
  );


  Widget _buildSection(AddressSectionModel s, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        if (index == 0) ...[
          Text('Tell us about your last 3 years addresses', style: TextStyle(fontSize : 16,fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text('In this section we need to know the addresses you have lived at in the last 3 years. Please answer these questions accurately as we check this data against your credit history. This will avoid any delays or negative results with your reference. If you do not know the answers to any questions, you can save the form and return to it later.',
              style: TextStyle(fontSize : 12,fontWeight: FontWeight.w500,color: Colors.grey)),

          SizedBox(height: 10),
          Text("Do you currently live in the UK? *", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
          SizedBox(height: 12),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                styledRadioOption<bool>(
                  value: true,
                  groupValue: s.livesInUK,
                  onChanged: (val) => setState(() => s.livesInUK = val),
                  label: "Yes ",
                  activeColor: Colors.green,
                ),
                Container(
                  height: 28,
                  width: 1,
                  color: Colors.grey[400],
                ),
                styledRadioOption<bool>(
                  value: false,
                  groupValue: s.livesInUK,
                  onChanged: (val) => setState(() => s.livesInUK = val),
                  label: "No ",
                  activeColor: Colors.red,
                ),
              ],
            ),
          ),


          if (s.livesInUK == true)...[

            SizedBox(height: 10),
            Divider(),
            Text("What is their residential address? *", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: s.postcodeCtrl,
                    decoration: _inputDec('Enter Postcode'),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  Color(0xff006eff),
                    foregroundColor: Colors.white,
                    padding:  EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => _fetchAddresses(s),
                  child:  Icon(Icons.search, size: 24),
                ),
              ],
            ),


            // ––– Address dropdown –––
            if (s.addressList.isNotEmpty) ...[
              SizedBox(height: 10),
              Text('Select Address from Dropdown List *',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              DropdownButtonFormField2<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 1.5),
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                hint: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select Your Address',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ),
                value: s.selectedFullAddress,
                items: s.addressList
                    .map((addr) => DropdownMenuItem(
                  value: addr,
                  child: Text(addr, overflow: TextOverflow.ellipsis),
                ))
                    .toList(),
                onChanged: (val) {
                  if (val == null) return;
                  final parts = val.split(',').map((e) => e.trim()).toList();
                  setState(() {
                    s.selectedFullAddress = val;
                    s.line1Ctrl.text = parts.isNotEmpty ? parts[0] : '';
                    s.line2Ctrl.text = parts.length > 1 ? parts[1] : '';
                    s.cityCtrl.text = parts.length > 2 ? parts[parts.length - 2] : '';
                    s.countyCtrl.text = parts.length > 3 ? parts.last : '';
                    s.postcodeFilledCtrl.text = s.postcodeCtrl.text.trim().toUpperCase();
                  });
                },
                buttonStyleData: ButtonStyleData(
                  height: 25,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 300, // 👈 This is your dropdown height
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12), // 👈 Rounded corners for dropdown
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                menuItemStyleData: MenuItemStyleData(
                  height: 48,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
                iconStyleData: IconStyleData(
                  icon: Icon(Icons.expand_more_rounded, size: 20),
                  iconEnabledColor: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 5),
            ],

            // ––– Detailed address fields –––
            if (s.selectedFullAddress != null) ...[
              Divider(),
              Text('Please check your address and edit if necessary',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              SizedBox(height: 10),
              _addrField(s.flatCtrl, 'Flat Number'),
              _addrField(s.houseNoCtrl, 'House Number'),
              _addrField(s.houseNameCtrl, 'House Name'),
              _addrField(s.line1Ctrl, 'Address Line 1'),
              _addrField(s.line2Ctrl, 'Address Line 2'),
              _addrField(s.cityCtrl, 'City / Town'),
              _addrField(s.countyCtrl, 'County'),
              _addrField(s.postcodeFilledCtrl, 'Postcode', readOnly: true),


              Divider(),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "What are the terms of residency at your current property *",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ..._buildResidencyRadioTiles(s),
                ],
              ),



              Divider(),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Moved In Month
                  Text('Moved In Month *', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  DropdownButtonFormField2<String>(
                    isExpanded: true,
                    value: s.movedInMonth,

                    onChanged: (val) {
                      s.movedInMonth = val;
                      _checkAddressDate(s, index);
                    },
                    hint: Text(
                      'Select Month',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                    items: _months.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          e,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      );
                    }).toList(),

                    // 🎯 Proper field decoration
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
                      ),
                    ),

                    // 🎯 Button styling (open/closed state)
                    buttonStyleData: ButtonStyleData(
                      height: 25,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // Use this if your version supports it:
                      //  alignment: Alignment.centerLeft,
                    ),

                    // 🎯 Dropdown menu styling
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),

                    // 🎯 Menu item styling
                    menuItemStyleData: MenuItemStyleData(
                      height: 48,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),

                    // 🎯 Dropdown icon
                    iconStyleData: IconStyleData(
                      icon: Icon(Icons.expand_more_rounded, size: 20),
                      iconEnabledColor: Colors.blueAccent,
                    ),
                  ),



                  SizedBox(height: 12),

                  // Moved In Year
                  Text('Moved In Year *', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  DropdownButtonFormField2<String>(
                    isExpanded: true,
                    value: s.movedInYear,
                    onChanged: (val) {
                      s.movedInYear = val;
                      _checkAddressDate(s, index);
                    },

                    hint: Text(
                      'Select Year',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                    items: _years.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          e,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      );
                    }).toList(),

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
                      ),
                    ),

                    buttonStyleData: ButtonStyleData(
                      height: 25,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),

                    menuItemStyleData: MenuItemStyleData(
                      height: 48,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),

                    iconStyleData: IconStyleData(
                      icon: Icon(Icons.expand_more_rounded, size: 20),
                      iconEnabledColor: Colors.blueAccent,
                    ),
                  ),




                  // Conditional Rental Arrears Section
                  if ([
                    "Renting from landlord or letting agent",
                    "Council or social or housing association",
                    "Student Accommodation",
                    "Other",
                  ].contains(s.residencyType))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Divider(),

                        Text(
                          'Have you had any rental arrears in the past 3 years? *',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 12),
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              styledRadioOption<String>(
                                value: "Yes",
                                groupValue: s.rentalArrears,
                                onChanged: (val) => setState(() => s.rentalArrears = val!),
                                label: "Yes ",
                                activeColor: Colors.red,
                              ),
                              Container(
                                height: 28,
                                width: 1,
                                color: Colors.grey[400],
                              ),
                              styledRadioOption<String>(
                                value: "No",
                                groupValue: s.rentalArrears,
                                onChanged: (val) => setState(() => s.rentalArrears = val!),
                                label: "No ",
                                activeColor: Colors.green,
                              ),
                              Container(
                                height: 28,
                                width: 1,
                                color: Colors.grey[400],
                              ),
                              styledRadioOption<String>(
                                value: "Not applicable",
                                groupValue: s.rentalArrears,
                                onChanged: (val) => setState(() => s.rentalArrears = val!),
                                label: "N/A ",
                                activeColor: Colors.orange,
                              ),
                            ],
                          ),
                        ),


                        // Show TextFormField only if "Yes"
                        if (s.rentalArrears == "Yes") ...[
                          SizedBox(height: 12),
                          Text(
                            'Please tell us about your rental arrears (£) *',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: s.arrearsAmountCtrl,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              hintText: "Arrears (£)",
                              hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade400),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.blue, width: 1.5),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade200),
                              ),
                            ),
                          ),

                        ],

                        if (["Other",].contains(s.residencyType))

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text("Additional information or comments *", style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: s.additionalInfoCtrl,
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: "Additional Info",
                                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade400),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.blue, width: 1.5),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade200),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),

                  SizedBox(height: 10),
                  Divider(),

                  Text(
                    "Please upload a clear copy of a document from the list below which is addressed to you and contains the date as well as your current address",
                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  // Proof of Address
                  Text('Proof of address type *', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  DropdownButtonFormField2<String>(
                    isExpanded: true,
                    value: (s.proofType != null &&
                        s.proofType!.isNotEmpty &&
                        [...documentsLast3Months, ...documentsLast6Months].contains(s.proofType))
                        ? s.proofType
                        : null,
                    onChanged: (val) => setState(() => s.proofType = val),

                    hint: Text(
                      'Select Document',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),

                    items: [
                      // Group 1 Header
                      DropdownMenuItem<String>(
                        enabled: false,
                        child: Text(
                          'Acceptable Documents (Less than 3 months)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
                        ),
                      ),
                      // Group 1 Items
                      ...documentsLast3Months.map(
                            (e) => DropdownMenuItem<String>(
                          value: e,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            e,
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),

                      // Group 2 Header
                      DropdownMenuItem<String>(
                        enabled: false,
                        child: Text(
                          'Acceptable Documents (Less than 6 months)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
                        ),
                      ),
                      // Group 2 Items
                      ...documentsLast6Months.map(
                            (e) => DropdownMenuItem<String>(
                          value: e,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            e,
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ],

                    decoration: InputDecoration(
                      hintText: 'Select Document',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),

                    buttonStyleData: ButtonStyleData(
                      height: 25,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      height: 48,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    iconStyleData: IconStyleData(
                      icon: Icon(Icons.expand_more_rounded, size: 20),
                      iconEnabledColor: Colors.blueAccent,
                    ),
                  ),


                  SizedBox(height: 12),
                  Text(
                    "Upload Proof of Address Document *",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: s.chosenFileName ?? 'No file chosen',
                            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade400),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.blue, width: 1.5),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey[50],
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                        icon: Icon(Icons.attach_file, size: 20),
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg', 'doc', 'docx'],
                          );

                          if (result != null && result.files.isNotEmpty) {
                            setState(() {
                              s.chosenFileName = result.files.single.name;
                            });

                            // You can access the file using result.files.single.path
                            // Implement your upload logic here
                          }
                        },
                        label: Text("Choose File"),
                      ),
                    ],
                  ),

                ],
              ),
            ],
          ],



          if (s.livesInUK== false)...[
            SizedBox(height:5),
            Divider(),
            Text('Please enter your address correct in the below fields *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            SizedBox(height: 5),
            _addrField(s.flatCtrl, 'Flat Number'),
            _addrField(s.houseNoCtrl, 'House Number'),
            _addrField(s.houseNameCtrl, 'House Name'),
            _addrField(s.line1Ctrl, 'Address Line 1'),
            _addrField(s.line2Ctrl, 'Address Line 2'),
            _addrField(s.cityCtrl, 'City / Town'),
            _addrField(s.countyCtrl, 'County'),
            _addrField(s.postcodeFilledCtrl, 'Postcode'),


            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Country', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                DropdownButtonFormField2<String>(
                  isExpanded: true,
                  value: countries.contains(s.selectedCountry) ? s.selectedCountry : null,
                  onChanged: (val) => setState(() => s.selectedCountry = val!),

                  hint: Text(
                    'Select Country',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),

                  items: countries.map((e) {
                    return DropdownMenuItem<String>(
                      value: e,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        e,
                        style: TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),

                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    hintText: 'Select Country',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                  ),

                  buttonStyleData: ButtonStyleData(
                    height: 25,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),

                  menuItemStyleData: MenuItemStyleData(
                    height: 48,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),

                  iconStyleData: IconStyleData(
                    icon: Icon(Icons.expand_more_rounded, size: 20),
                    iconEnabledColor: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "What are the terms of residency at your current property *",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                ..._buildResidencyRadioTiles(s),
              ],
            ),

            Divider(),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Moved In Month
                Text('Moved In Month *', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                DropdownButtonFormField2<String>(
                  isExpanded: true,
                  value: s.movedInMonth,
                  onChanged: (val) {
                    s.movedInMonth = val;
                    _checkAddressDate(s, index);
                  },
                  hint: Text(
                    'Select Month',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  items: _months.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        e,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    );
                  }).toList(),

                  // 🎯 Proper field decoration
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                  ),

                  // 🎯 Button styling (open/closed state)
                  buttonStyleData: ButtonStyleData(
                    height: 25,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    // Use this if your version supports it:
                    //  alignment: Alignment.centerLeft,
                  ),

                  // 🎯 Dropdown menu styling
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),

                  // 🎯 Menu item styling
                  menuItemStyleData: MenuItemStyleData(
                    height: 48,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),

                  // 🎯 Dropdown icon
                  iconStyleData: IconStyleData(
                    icon: Icon(Icons.expand_more_rounded, size: 20),
                    iconEnabledColor: Colors.blueAccent,
                  ),
                ),



                SizedBox(height: 12),

                // Moved In Year
                Text('Moved In Year *', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                DropdownButtonFormField2<String>(
                  isExpanded: true,
                  value: s.movedInYear,
                  onChanged: (val) {
                    s.movedInYear = val;
                    _checkAddressDate(s, index);
                  },
                  hint: Text(
                    'Select Year',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  items: _years.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        e,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    );
                  }).toList(),

                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                  ),

                  buttonStyleData: ButtonStyleData(
                    height: 25,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),

                  menuItemStyleData: MenuItemStyleData(
                    height: 48,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),

                  iconStyleData: IconStyleData(
                    icon: Icon(Icons.expand_more_rounded, size: 20),
                    iconEnabledColor: Colors.blueAccent,
                  ),
                ),


                // Conditional Rental Arrears Section
                if ([
                  "Renting from landlord or letting agent",
                  "Council or social or housing association",
                  "Student Accommodation",
                  "Other",
                ].contains(s.residencyType))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Divider(),

                      Text(
                        'Have you had any rental arrears in the past 3 years? *',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12),
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            styledRadioOption<String>(
                              value: "Yes",
                              groupValue: s.rentalArrears,
                              onChanged: (val) => setState(() => s.rentalArrears = val!),
                              label: "Yes ",
                              activeColor: Colors.red,
                            ),
                            Container(
                              height: 28,
                              width: 1,
                              color: Colors.grey[400],
                            ),
                            styledRadioOption<String>(
                              value: "No",
                              groupValue: s.rentalArrears,
                              onChanged: (val) => setState(() => s.rentalArrears = val!),
                              label: "No ",
                              activeColor: Colors.green,
                            ),
                            Container(
                              height: 28,
                              width: 1,
                              color: Colors.grey[400],
                            ),
                            styledRadioOption<String>(
                              value: "Not applicable",
                              groupValue: s.rentalArrears,
                              onChanged: (val) => setState(() => s.rentalArrears = val!),
                              label: "N/A ",
                              activeColor: Colors.orange,
                            ),
                          ],
                        ),
                      ),


                      // Show TextFormField only if "Yes"
                      if (s.rentalArrears == "Yes") ...[
                        SizedBox(height: 12),
                        Text(
                          'Please tell us about your rental arrears (£) *',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: s.arrearsAmountCtrl,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            hintText: "Arrears (£)",
                            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade400),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.blue, width: 1.5),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                        ),

                      ],

                      if (["Other",].contains(s.residencyType))

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Text("Additional information or comments *", style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            TextFormField(
                              controller: s.additionalInfoCtrl,
                              decoration: InputDecoration(
                                hintText: "Additional Info",
                                hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade400),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.blue, width: 1.5),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade200),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                SizedBox(height: 10),
                Divider(),

                Text(
                  "Please upload a clear copy of a document from the list below which is addressed to you and contains the date as well as your current address",
                  style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                // Proof of Address
                Text('Proof of address type *', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                DropdownButtonFormField2<String>(
                  isExpanded: true,
                  value: (s.proofType != null &&
                      s.proofType!.isNotEmpty &&
                      [...documentsLast3Months, ...documentsLast6Months].contains(s.proofType))
                      ? s.proofType
                      : null,

                  onChanged: (val) => setState(() => s.proofType = val),

                  hint: Text(
                    'Select Document',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),

                  items: [
                     DropdownMenuItem<String>(
                      enabled: false,
                      child: Text(
                        'Acceptable Documents (Less than 3 months)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    ...documentsLast3Months.map(
                          (e) => DropdownMenuItem<String>(
                        value: e,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          e,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                     DropdownMenuItem<String>(
                      enabled: false,
                      child: Text(
                        'Acceptable Documents (Less than 6 months)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    ...documentsLast6Months.map(
                          (e) => DropdownMenuItem<String>(
                        value: e,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          e,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],

                  decoration: InputDecoration(
                    hintText: 'Select Document',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                  ),

                  buttonStyleData: ButtonStyleData(
                    height: 25,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),

                  menuItemStyleData: MenuItemStyleData(
                    height: 48,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),

                  iconStyleData: IconStyleData(
                    icon: Icon(Icons.expand_more_rounded, size: 20),
                    iconEnabledColor: Colors.blueAccent,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),
            Text(
              "Upload Proof of Address Document *",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: s.chosenFileName ?? 'No file chosen',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: Icon(Icons.attach_file, size: 20),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[50],
                    foregroundColor: Colors.black87,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg', 'doc', 'docx'],
                    );

                    if (result != null && result.files.isNotEmpty) {
                      setState(() {
                        s.chosenFileName = result.files.single.name;
                      });

                      // You can access the file using result.files.single.path
                      // Implement your upload logic here
                    }
                  },
                  label: Text("Choose File"),
                ),
              ],
            ),

          ],
        ],


        if (index > 0) ...[
          SizedBox(height :10),
          Divider(),

          Text('You have not lived at your current residence for more than 3 years so please provide your previous address',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Was this address in the UK? *',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                styledRadioOption<bool>(
                  value: true,
                  groupValue: s.wasLivedInUK,
                  onChanged: (val) => setState(() => s.wasLivedInUK = val),
                  label: "Yes ",
                  activeColor: Colors.green,
                ),
                Container(
                  height: 28,
                  width: 1,
                  color: Colors.grey[400],
                ),
                styledRadioOption<bool>(
                  value: false,
                  groupValue: s.wasLivedInUK,
                  onChanged: (val) => setState(() => s.wasLivedInUK = val),
                  label: "No ",
                  activeColor: Colors.red,
                ),
              ],
            ),
          ),


          if (s.wasLivedInUK == true)...[

            SizedBox(height: 10),
            Divider(),
            Text("What is their residential address? *", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: s.postcodeCtrl,
                    decoration: _inputDec('Enter Postcode'),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  Color(0xff006eff),
                    foregroundColor: Colors.white,
                    padding:  EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => _fetchAddresses(s),
                  child:  Icon(Icons.search, size: 24),
                ),
              ],
            ),


            // ––– Address dropdown –––
            if (s.addressList.isNotEmpty) ...[
              SizedBox(height: 10),
              Text('Select Address from Dropdown List *',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              DropdownButtonFormField2<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 1.5),
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                hint: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select Your Address',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ),
                value: s.selectedFullAddress,
                items: s.addressList
                    .map((addr) => DropdownMenuItem(
                  value: addr,
                  child: Text(addr, overflow: TextOverflow.ellipsis),
                ))
                    .toList(),
                onChanged: (val) {
                  if (val == null) return;
                  final parts = val.split(',').map((e) => e.trim()).toList();
                  setState(() {
                    s.selectedFullAddress = val;
                    s.line1Ctrl.text = parts.isNotEmpty ? parts[0] : '';
                    s.line2Ctrl.text = parts.length > 1 ? parts[1] : '';
                    s.cityCtrl.text = parts.length > 2 ? parts[parts.length - 2] : '';
                    s.countyCtrl.text = parts.length > 3 ? parts.last : '';
                    s.postcodeFilledCtrl.text = s.postcodeCtrl.text.trim().toUpperCase();
                  });
                },
                buttonStyleData: ButtonStyleData(
                  height: 25,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 300, // 👈 This is your dropdown height
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12), // 👈 Rounded corners for dropdown
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                menuItemStyleData: MenuItemStyleData(
                  height: 48,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
                iconStyleData: IconStyleData(
                  icon: Icon(Icons.expand_more_rounded, size: 20),
                  iconEnabledColor: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 5),
            ],

            // ––– Detailed address fields –––
            if (s.selectedFullAddress != null) ...[
              Divider(),
              Text('Please check your address and edit if necessary',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              SizedBox(height: 10),
              _addrField(s.flatCtrl, 'Flat Number'),
              _addrField(s.houseNoCtrl, 'House Number'),
              _addrField(s.houseNameCtrl, 'House Name'),
              _addrField(s.line1Ctrl, 'Address Line 1'),
              _addrField(s.line2Ctrl, 'Address Line 2'),
              _addrField(s.cityCtrl, 'City / Town'),
              _addrField(s.countyCtrl, 'County'),
              _addrField(s.postcodeFilledCtrl, 'Postcode', readOnly: true),


              Divider(),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "What are the terms of residency at your current property *",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ..._buildResidencyRadioTiles(s),
                ],
              ),



              Divider(),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Moved In Month
                  Text('Moved In Month *', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  DropdownButtonFormField2<String>(
                    isExpanded: true,
                    value: s.movedInMonth,

                    onChanged: (val) {
                      s.movedInMonth = val;
                      _checkAddressDate(s, index);
                    },
                    hint: Text(
                      'Select Month',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                    items: _months.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          e,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      );
                    }).toList(),

                    // 🎯 Proper field decoration
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
                      ),
                    ),

                    // 🎯 Button styling (open/closed state)
                    buttonStyleData: ButtonStyleData(
                      height: 25,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // Use this if your version supports it:
                      //  alignment: Alignment.centerLeft,
                    ),

                    // 🎯 Dropdown menu styling
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),

                    // 🎯 Menu item styling
                    menuItemStyleData: MenuItemStyleData(
                      height: 48,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),

                    // 🎯 Dropdown icon
                    iconStyleData: IconStyleData(
                      icon: Icon(Icons.expand_more_rounded, size: 20),
                      iconEnabledColor: Colors.blueAccent,
                    ),
                  ),



                  SizedBox(height: 12),

                  // Moved In Year
                  Text('Moved In Year *', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  DropdownButtonFormField2<String>(
                    isExpanded: true,
                    value: s.movedInYear,
                    onChanged: (val) {
                      s.movedInYear = val;
                      _checkAddressDate(s, index);
                    },

                    hint: Text(
                      'Select Year',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                    items: _years.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          e,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      );
                    }).toList(),

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
                      ),
                    ),

                    buttonStyleData: ButtonStyleData(
                      height: 25,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),

                    menuItemStyleData: MenuItemStyleData(
                      height: 48,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),

                    iconStyleData: IconStyleData(
                      icon: Icon(Icons.expand_more_rounded, size: 20),
                      iconEnabledColor: Colors.blueAccent,
                    ),
                  ),



                  // Conditional Rental Arrears Section
                  if ([
                    "Renting from landlord or letting agent",
                    "Council or social or housing association",
                    "Student Accommodation",
                    "Other",
                  ].contains(s.residencyType))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Divider(),

                        Text(
                          'Have you had any rental arrears in the past 3 years? *',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 12),
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              styledRadioOption<String>(
                                value: "Yes",
                                groupValue: s.rentalArrears,
                                onChanged: (val) => setState(() => s.rentalArrears = val!),
                                label: "Yes ",
                                activeColor: Colors.red,
                              ),
                              Container(
                                height: 28,
                                width: 1,
                                color: Colors.grey[400],
                              ),
                              styledRadioOption<String>(
                                value: "No",
                                groupValue: s.rentalArrears,
                                onChanged: (val) => setState(() => s.rentalArrears = val!),
                                label: "No ",
                                activeColor: Colors.green,
                              ),
                              Container(
                                height: 28,
                                width: 1,
                                color: Colors.grey[400],
                              ),
                              styledRadioOption<String>(
                                value: "Not applicable",
                                groupValue: s.rentalArrears,
                                onChanged: (val) => setState(() => s.rentalArrears = val!),
                                label: "N/A ",
                                activeColor: Colors.orange,
                              ),
                            ],
                          ),
                        ),


                        // Show TextFormField only if "Yes"
                        if (s.rentalArrears == "Yes") ...[
                          SizedBox(height: 12),
                          Text(
                            'Please tell us about your rental arrears (£) *',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: s.arrearsAmountCtrl,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              hintText: "Arrears (£)",
                              hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade400),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.blue, width: 1.5),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade200),
                              ),
                            ),
                          ),

                        ],

                        if (["Other",].contains(s.residencyType))

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text("Additional information or comments *", style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: s.additionalInfoCtrl,
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: "Additional Info",
                                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade400),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.blue, width: 1.5),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade200),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),

                  SizedBox(height: 10),
                  Divider(),

                  Text(
                    "Please upload a clear copy of a document from the list below which is addressed to you and contains the date as well as your current address",
                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  // Proof of Address
                  Text('Proof of address type *', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  DropdownButtonFormField2<String>(
                    isExpanded: true,
                    value: (s.proofType != null &&
                        s.proofType!.isNotEmpty &&
                        [...documentsLast3Months, ...documentsLast6Months].contains(s.proofType))
                        ? s.proofType
                        : null,
                    onChanged: (val) => setState(() => s.proofType = val),

                    hint: Text(
                      'Select Document',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),

                    items: [
                      // Group 1 Header
                      DropdownMenuItem<String>(
                        enabled: false,
                        child: Text(
                          'Acceptable Documents (Less than 3 months)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
                        ),
                      ),
                      // Group 1 Items
                      ...documentsLast3Months.map(
                            (e) => DropdownMenuItem<String>(
                          value: e,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            e,
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),

                      // Group 2 Header
                      DropdownMenuItem<String>(
                        enabled: false,
                        child: Text(
                          'Acceptable Documents (Less than 6 months)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
                        ),
                      ),
                      // Group 2 Items
                      ...documentsLast6Months.map(
                            (e) => DropdownMenuItem<String>(
                          value: e,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            e,
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ],

                    decoration: InputDecoration(
                      hintText: 'Select Document',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),

                    buttonStyleData: ButtonStyleData(
                      height: 25,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      height: 48,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    iconStyleData: IconStyleData(
                      icon: Icon(Icons.expand_more_rounded, size: 20),
                      iconEnabledColor: Colors.blueAccent,
                    ),
                  ),


                  SizedBox(height: 12),
                  Text(
                    "Upload Proof of Address Document *",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: s.chosenFileName ?? 'No file chosen',
                            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade400),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.blue, width: 1.5),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey[50],
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                        icon: Icon(Icons.attach_file, size: 20),
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg', 'doc', 'docx'],
                          );

                          if (result != null && result.files.isNotEmpty) {
                            setState(() {
                              s.chosenFileName = result.files.single.name;
                            });

                            // Implement your upload logic here
                            // You can access the file using result.files.single.path


                          }
                        },
                        label: Text("Choose File"),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ],

          if (s.wasLivedInUK==false)...[
            SizedBox(height:10),
            Divider(),
            Text('Please enter your address correct in the below fields *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            SizedBox(height: 5),
            _addrField(s.flatCtrl, 'Flat Number'),
            _addrField(s.houseNoCtrl, 'House Number'),
            _addrField(s.houseNameCtrl, 'House Name'),
            _addrField(s.line1Ctrl, 'Address Line 1'),
            _addrField(s.line2Ctrl, 'Address Line 2'),
            _addrField(s.cityCtrl, 'City / Town'),
            _addrField(s.countyCtrl, 'County'),
            _addrField(s.postcodeFilledCtrl, 'Postcode'),


            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Country', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                DropdownButtonFormField2<String>(
                  isExpanded: true,
                  value: countries.contains(s.selectedCountry) ? s.selectedCountry : null,
                  onChanged: (val) => setState(() => s.selectedCountry = val!),

                  hint: Text(
                    'Select Country',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),

                  items: countries.map((e) {
                    return DropdownMenuItem<String>(
                      value: e,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        e,
                        style: TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),

                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    hintText: 'Select Country',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                  ),

                  buttonStyleData: ButtonStyleData(
                    height: 25,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),

                  menuItemStyleData: MenuItemStyleData(
                    height: 48,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),

                  iconStyleData: IconStyleData(
                    icon: Icon(Icons.expand_more_rounded, size: 20),
                    iconEnabledColor: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "What are the terms of residency at your current property *",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                ..._buildResidencyRadioTiles(s),
              ],
            ),

            Divider(),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Moved In Month
                Text('Moved In Month *', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                DropdownButtonFormField2<String>(
                  isExpanded: true,
                  value: s.movedInMonth,

                  onChanged: (val) {
                    s.movedInMonth = val;
                    _checkAddressDate(s, index);
                  },
                  hint: Text(
                    'Select Month',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  items: _months.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        e,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    );
                  }).toList(),

                  // 🎯 Proper field decoration
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                  ),

                  // 🎯 Button styling (open/closed state)
                  buttonStyleData: ButtonStyleData(
                    height: 25,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    // Use this if your version supports it:
                    //  alignment: Alignment.centerLeft,
                  ),

                  // 🎯 Dropdown menu styling
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),

                  // 🎯 Menu item styling
                  menuItemStyleData: MenuItemStyleData(
                    height: 48,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),

                  // 🎯 Dropdown icon
                  iconStyleData: IconStyleData(
                    icon: Icon(Icons.expand_more_rounded, size: 20),
                    iconEnabledColor: Colors.blueAccent,
                  ),
                ),



                SizedBox(height: 12),

                // Moved In Year
                Text('Moved In Year *', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                DropdownButtonFormField2<String>(
                  isExpanded: true,
                  value: s.movedInYear,
                  onChanged: (val) {
                    s.movedInYear = val;
                    _checkAddressDate(s, index);
                  },

                  hint: Text(
                    'Select Year',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  items: _years.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        e,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    );
                  }).toList(),

                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                  ),

                  buttonStyleData: ButtonStyleData(
                    height: 25,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),

                  menuItemStyleData: MenuItemStyleData(
                    height: 48,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),

                  iconStyleData: IconStyleData(
                    icon: Icon(Icons.expand_more_rounded, size: 20),
                    iconEnabledColor: Colors.blueAccent,
                  ),
                ),

                // Conditional Rental Arrears Section
                if ([
                  "Renting from landlord or letting agent",
                  "Council or social or housing association",
                  "Student Accommodation",
                  "Other",
                ].contains(s.residencyType))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Divider(),

                      Text(
                        'Have you had any rental arrears in the past 3 years? *',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12),
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            styledRadioOption<String>(
                              value: "Yes",
                              groupValue: s.rentalArrears,
                              onChanged: (val) => setState(() => s.rentalArrears = val!),
                              label: "Yes ",
                              activeColor: Colors.red,
                            ),
                            Container(
                              height: 28,
                              width: 1,
                              color: Colors.grey[400],
                            ),
                            styledRadioOption<String>(
                              value: "No",
                              groupValue: s.rentalArrears,
                              onChanged: (val) => setState(() => s.rentalArrears = val!),
                              label: "No ",
                              activeColor: Colors.green,
                            ),
                            Container(
                              height: 28,
                              width: 1,
                              color: Colors.grey[400],
                            ),
                            styledRadioOption<String>(
                              value: "Not applicable",
                              groupValue: s.rentalArrears,
                              onChanged: (val) => setState(() => s.rentalArrears = val!),
                              label: "N/A ",
                              activeColor: Colors.orange,
                            ),
                          ],
                        ),
                      ),


                      // Show TextFormField only if "Yes"
                      if (s.rentalArrears == "Yes") ...[
                        SizedBox(height: 12),
                        Text(
                          'Please tell us about your rental arrears (£) *',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: s.arrearsAmountCtrl,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            hintText: "Arrears (£)",
                            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade400),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.blue, width: 1.5),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                        ),

                      ],

                      if (["Other",].contains(s.residencyType))

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Text("Additional information or comments *", style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            TextFormField(
                              controller: s.additionalInfoCtrl,
                              decoration: InputDecoration(
                                hintText: "Additional Info",
                                hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade400),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.blue, width: 1.5),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade200),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                SizedBox(height: 10),
                Divider(),

                Text(
                  "Please upload a clear copy of a document from the list below which is addressed to you and contains the date as well as your current address",
                  style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                // Proof of Address
                Text('Proof of address type *', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                DropdownButtonFormField2<String>(
                  isExpanded: true,
                  value: (s.proofType != null &&
                      s.proofType!.isNotEmpty &&
                      [...documentsLast3Months, ...documentsLast6Months].contains(s.proofType))
                      ? s.proofType
                      : null,

                  onChanged: (val) => setState(() => s.proofType = val),

                  hint: Text(
                    'Select Document',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),

                  items: [
                    DropdownMenuItem<String>(
                      enabled: false,
                      child: Text(
                        'Acceptable Documents (Less than 3 months)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    ...documentsLast3Months.map(
                          (e) => DropdownMenuItem<String>(
                        value: e,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          e,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                     DropdownMenuItem<String>(
                      enabled: false,
                      child: Text(
                        'Acceptable Documents (Less than 6 months)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    ...documentsLast6Months.map(
                          (e) => DropdownMenuItem<String>(
                        value: e,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          e,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],

                  decoration: InputDecoration(
                    hintText: 'Select Document',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                  ),

                  buttonStyleData: ButtonStyleData(
                    height: 25,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),

                  menuItemStyleData: MenuItemStyleData(
                    height: 48,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),

                  iconStyleData: IconStyleData(
                    icon: Icon(Icons.expand_more_rounded, size: 20),
                    iconEnabledColor: Colors.blueAccent,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),
            Text(
              "Upload Proof of Address Document *",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: s.chosenFileName ?? 'No file chosen',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: Icon(Icons.attach_file, size: 20),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[50],
                    foregroundColor: Colors.black87,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg', 'doc', 'docx'],
                    );

                    if (result != null && result.files.isNotEmpty) {
                      setState(() {
                        s.chosenFileName = result.files.single.name;
                      });

                      // You can access the file using result.files.single.path
                      // Implement your upload logic here
                    }
                  },
                  label: Text("Choose File"),
                ),
              ],
            ),


          ],
        ],

      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
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
            SizedBox(height: 4),

            ListView.builder(
              itemCount: _sections.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _buildSection(_sections[index], index);
              },
            ),


            Divider(),
            SizedBox(height: 10),

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
                    onPressed: () {}, // Submit logic here
                    child: Text("Next"),
                  ),
                ]
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }




  // Reusable address text‑field
  Widget _addrField(TextEditingController c, String label,
      {bool readOnly = false}) => Padding(
    padding:  EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style:  TextStyle(fontWeight: FontWeight.bold)),
         SizedBox(height: 6),
        TextFormField(
          controller: c,
          readOnly: readOnly,
          decoration: _inputDec(label),
        ),
      ],
    ),
  );

  Widget styledRadioOption<T>({
    required T value,
    required T? groupValue,
    required void Function(T?) onChanged,
    required String label,
    required Color activeColor,
  }) {
    return IntrinsicWidth(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: groupValue == value ? activeColor : Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              fillColor: MaterialStateProperty.resolveWith<Color>(
                    (states) => states.contains(MaterialState.selected)
                    ? activeColor
                    : Colors.grey,
              ),
            ),
            Text(label),
             SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  Widget _radioTile(AddressSectionModel s, String label) {
    final bool isSelected = s.residencyType == label;
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 6.0),
      child: Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Colors.grey,
          radioTheme: RadioThemeData(
            fillColor: MaterialStateProperty.resolveWith<Color>(
                  (states) => states.contains(MaterialState.selected)
                  ? Colors.blue
                  : Colors.grey,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color:
              isSelected ? Colors.blue.shade200 : Colors.grey.shade300,
            ),
          ),
          child: RadioListTile<String>(
            contentPadding:  EdgeInsets.symmetric(horizontal: 12),
            title: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.blue : Colors.black87,
              ),
            ),
            value: label,
            groupValue: s.residencyType,
            onChanged: (val) => setState(() => s.residencyType = val!),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildResidencyRadioTiles(AddressSectionModel s) {
    return _residencyTypes.map((label) => _radioTile(s, label)).toList();
  }
}