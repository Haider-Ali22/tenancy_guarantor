import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class IncomeFormScreen extends StatefulWidget {
  final Function(String) onChanged;

  const IncomeFormScreen({super.key, required this.onChanged});

  @override
  _IncomeFormScreenState createState() => _IncomeFormScreenState();
}

class _IncomeFormScreenState extends State<IncomeFormScreen> {
  String value = '';

  final _formKey = GlobalKey<FormState>();

  String? employmentType;
  String? employmentType1;
  String? businessName;
  bool? isUkAddress;
  String? jobTitle;
  String? startDate;
  String? refereeName;
  String?  accountantName;
  String? refereeEmail;
  String? refereeConfirmEmail;
  String? refereePhone;
  String? incomeType;
  String? basicHourlyRate;
  String? guaranteedHours;
  String? probationLength;
  bool? onProbation;
  bool? underDisciplinary;
  bool? employmentFuture;
  PlatformFile? selectedFile;

  bool? hasAccountant;
  bool? accountantinUK;






  String? disciplinaryStatus; // tracks selected label


  String? employmentStatus; // tracks selected label



  Future<void> pickBankStatement() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        selectedFile = result.files.first;
      });
    }
  }
  Future<void> pickTaxReturns() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        selectedFile = result.files.first;
      });
    }
  }

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  Future<void> _selectDate(
      BuildContext context,
      TextEditingController controller,
      bool isStartDate,
      ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (selectedStartDate ?? DateTime.now())
          : (selectedEndDate ?? DateTime.now()),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}/${picked.month}/${picked.year}";

        if (isStartDate) {
          selectedStartDate = picked;
        } else {
          selectedEndDate = picked;
        }
      });
    }
  }

  TextEditingController annualSalaryController = TextEditingController();
  String? annualSalary ;

  TextEditingController annualIncomeController = TextEditingController();
  String? annualIncome ;


  TextEditingController hourlyRateController = TextEditingController();


  @override
  void initState() {
    super.initState();
    hourlyRateController.addListener(() {
      setState(() {}); // Triggers rebuild when text changes
    });
  }


  @override
  void dispose() {
    hourlyRateController.dispose();
    super.dispose();
  }

  TextEditingController addressController = TextEditingController();
  TextEditingController postcodeController = TextEditingController();



  List<String> addressList = [];
  String? selectedAddress;
  String address = '';
  String postcode='';
  String selectedPostcode = '';




  String getAddressApiKey = 'qNVLBUHKo0S0xiV7asTxKQ9741'; // Replace with your API Key



  Future<void> fetchAddresses(String postcode) async {
    final url = Uri.parse(
      'https://api.getAddress.io/find/${postcode.trim()}?api-key=$getAddressApiKey',
    );

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      setState(() {
        addressList = List<String>.from(json['addresses']);

      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch address for postcode")),
      );
    }
  }



  List<IncomeSection> incomeSections = [];

  String? selectedIncomeType;
  String? selectedGuarantee;
  String? selectedFrequency;
  String incomeAmount = '';

  bool showDropdown = false;
  bool showExtraFields = false;

  final List<String> incomeTypes = [
     'Additional Job',
     'Bonus',
     'Commission',
     'Overtime',
     'Pension',
     'Working Tax Credit',
     'Child Tax Credit',
     'Disability Living Allowance / PIP',
     'Child Maintenance',
     'Bursary',
     'Stipends',
     'Sponsorship',
     'Carer\'s Allowance',
     'Housing benefit',
     'Income Support',
     'Job-seekers Allowance',
     'Universal Credit',
     'Student Loan'
  ];

  final List<String> guaranteeTypes = ['Guaranteed', 'Non-Guaranteed'];
  final List<String> frequencies = ['Weekly', 'Monthly', 'Annually'];

  void resetForm() {
    setState(() {
      selectedIncomeType = null;
      selectedGuarantee = null;
      selectedFrequency = null;
      incomeAmount = '';
      showDropdown = false;
      showExtraFields = false;
    });
  }

  void addIncomeSection() {
  setState(() {
  incomeSections.add(IncomeSection());
  });
  }

  void removeIncomeSection(int index) {
  setState(() {
  incomeSections.removeAt(index);
  });
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
              SizedBox(height: 4),

              Text('Tell us about your income', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),

              Text("In this section we would like you to tell us about your income. Please ensure you answer these questions honestly and accurately. This will avoid any delays or negative results with your reference. If you do not know the answers to any questions, you can save the form and return to it later.", style: TextStyle(color: Colors.grey.shade600),),

              SizedBox(height: 5),
              Divider(),
              SizedBox(height: 5),

              Text("Employment or Income Type *", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Column(
                children: [
                  "Permanent employee",
                  "Self employed or business owner",
                  "Contract worker",
                  "Temporary employee",
                  "Retired",
                  "Homemaker",
                  "Unemployed or other income",
                  "Zero-hours employee",
                  "Student",
                ].map(
                      (e) => Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor: Colors.grey, // unselected radio
                      radioTheme: RadioThemeData(
                        fillColor: WidgetStateProperty.all(Colors.grey), // selected radio
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200], // light grey background
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: RadioListTile<String>(
                        title: Text(e),
                        value: e,
                        groupValue: employmentType,
                        activeColor: Colors.grey, // radio selected color
                        onChanged: (val) {
                          setState(() {
                            employmentType = val!;
                          });
                        },
                      ),
                    ),
                  ),
                ).toList(),
              ),

              SizedBox(height:10),
              Divider(),

              if (employmentType == "Homemaker" || employmentType == "Student" || employmentType == "Unemployed or other income")...[
                Text('Please provide the start date *', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _selectDate(context, startDateController, true),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: startDateController,
                      decoration: InputDecoration(
                        hintText: "Select date",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
              ],





              if (employmentType == "Permanent employee"  || employmentType == "Contract worker" || employmentType == "Temporary employee" || employmentType == "Zero-hours employee") ...[

                if (employmentType == "Zero-hours employee")...[

                  Text('Please provide the start date *', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _selectDate(context, startDateController, true),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: startDateController,
                        decoration: InputDecoration(
                          hintText: "Select date",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],

                Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Business name of your employer *",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Business Name",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => businessName = val,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(),


              if(employmentType == "Contract worker") ...[
                ///////

                Text('Please provide the start date *', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _selectDate(context, startDateController, true),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: startDateController,
                      decoration: InputDecoration(
                        hintText: "Select date",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ),
                ),

              SizedBox(height: 10),

                Text(
                  "Your contract end date *",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _selectDate(context, endDateController, false),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: endDateController,
                      decoration: InputDecoration(
                        hintText: "Select end date",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Divider(),
              ],


              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Is your employer's address in the UK? *",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // YES option
                      Flexible(
                        child: IntrinsicWidth(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isUkAddress == true ? Colors.green : Colors.grey,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Row(
                              children: [
                                Radio<bool>(
                                  value: true,
                                  groupValue: isUkAddress,
                                  onChanged: (val) {
                                    setState(() {
                                      isUkAddress = val;
                                      // Reset address only if switching from false to true
                                      if (isUkAddress == true) {
                                        addressList = [];
                                        selectedAddress = null;
                                        postcode = '';
                                        selectedPostcode = '';
                                      }
                                    });
                                  },
                                  fillColor: WidgetStateProperty.resolveWith<Color>(
                                        (states) => states.contains(WidgetState.selected)
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                ),
                                Text("Yes"),
                                SizedBox(width: 12),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(height: 28, width: 1, color: Colors.grey[400]),
                      SizedBox(width: 8),

                      // NO option
                      Flexible(
                        child: IntrinsicWidth(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isUkAddress == false ? Colors.red : Colors.grey,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Row(
                              children: [
                                Radio<bool>(
                                  value: false,
                                  groupValue: isUkAddress,
                                  onChanged: (val) {
                                    setState(() {
                                      isUkAddress = val;
                                      // Clear UK address-related fields
                                      addressList = [];
                                      selectedAddress = null;
                                      postcode = '';
                                      selectedPostcode = '';
                                    });
                                  },
                                  fillColor: WidgetStateProperty.resolveWith<Color>(
                                        (states) => states.contains(WidgetState.selected)
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
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


                  Column(
                    children: [


                      // UK address section
                      if (isUkAddress == true) ...[
                        SizedBox(height: 10),
                        Divider(),

                        Text(
                          "What is their address? *",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Postcode",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onChanged: (val) {
                                  postcode = val;
                                },
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
                                if (postcode.trim().isNotEmpty) {
                                  selectedPostcode = postcode;
                                  postcodeController.text = postcode.toUpperCase(); // 👈 paste it in uppercase
                                  fetchAddresses(postcode);
                                }
                              },
                              child: Icon(Icons.search, size: 25),
                            ),
                            SizedBox(height: 10),
                            Divider(),
                          ],
                        ),

                        // Dropdown for address selection
                        if (addressList.isNotEmpty) ...[
                          SizedBox(height: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text('Select Address From Dropdown List',  textAlign : TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: selectedAddress,
                                decoration: InputDecoration(
                                  hintText: "Select Address",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                                items: addressList
                                    .map((e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e, overflow: TextOverflow.ellipsis),
                                ))
                                    .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    selectedAddress = val!;
                                    addressController.text = val;
                                    // ✅ use the previously stored postcode (set during search)
                                    postcodeController.text = selectedPostcode.toUpperCase();
                                  });
                                },
                              ),
                            ],
                          ),
                        ],

// Final read-only fields
                        if (selectedAddress != null) ...[
                          SizedBox(height: 12),
                          // Address Field

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Address', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: addressController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: "Address",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 8),

                      // Postcode Field

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('PostCode', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: postcodeController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: "Postcode",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],

                      // ✅ Manual entry for NON-UK address
                      if (isUkAddress == false) ...[
                        SizedBox(height: 10),
                        Divider(),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Please enter address *", style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: "Enter full address",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                              ),
                              onChanged: (val) {
                                addressController.text = val;
                              },
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
          SizedBox(height: 10),
          Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  // Job Title
                  Text('Please provide your job title or position *', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Job title or position",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                    onChanged: (val) => jobTitle = val,
                  ),

                  SizedBox(height: 12),

                  // Start Date
                  Text('Please provide the start date *', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _selectDate(context, startDateController, true),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: startDateController,
                        decoration: InputDecoration(
                          hintText: "Select date",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 12),

                  // Referee Name
                  Text('Please provide an appropriate referee name *', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Referee name",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                    onChanged: (val) => refereeName = val,
                  ),

                  SizedBox(height: 12),

                  // Referee Email
                  Text('Please provide their business email address *', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Referee business email",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                    onChanged: (val) => refereeEmail = val,
                  ),

                  SizedBox(height: 12),
                  Divider(),

                  Text("Your reference may be automatically declined if you provide an incorrect email address.", style: TextStyle( fontSize : 16 ,fontWeight: FontWeight.bold)),

                  SizedBox(height: 12),

                  // Confirm Referee Email
                  Text('Please confirm their business email address *', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Confirm referee email",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                    onChanged: (val) => refereeConfirmEmail = val,
                  ),

                  SizedBox(height: 12),

                  // Referee Phone
                  Text('Please provide their telephone number *', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Referee phone number",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                    onChanged: (val) => refereePhone = val,
                  ),
                ],
              ),

              SizedBox(height: 10),
              Divider(),


              Text(
                "How is your income paid?",
                style: TextStyle(fontSize : 16,fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "You can add several different incomes to your application. Please start by providing your main income.",
                style: TextStyle(fontSize : 12,fontWeight: FontWeight.w500, color: Colors.grey),
              ),
              SizedBox(height: 10),

              Text(
                "Is your income annual salary or hourly? *",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Annual Salary Button
                  Flexible(
                    child: IntrinsicWidth(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: incomeType == "Annual salary" ? Colors.green : Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: "Annual salary",
                              groupValue: incomeType,
                              onChanged: (val) => setState(() => incomeType = val!),
                              fillColor: WidgetStateProperty.resolveWith<Color>(
                                    (states) => states.contains(WidgetState.selected)
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                            Text("Annual salary"),
                            SizedBox(width: 12),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 8),
                  Container(height: 28, width: 2, color: Colors.grey[400]),
                  SizedBox(width: 8),

                  // Hourly Rate Button
                  Flexible(
                    child: IntrinsicWidth(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: incomeType == "Hourly rate" ? Colors.red : Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: "Hourly rate",
                              groupValue: incomeType,
                              onChanged: (val) => setState(() => incomeType = val!),
                              fillColor: WidgetStateProperty.resolveWith<Color>(
                                    (states) => states.contains(WidgetState.selected)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            Text("Hourly rate"),
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

              Column(
                children: [

                  // Hourly Rate Layout
                  if (incomeType == "Hourly rate") ...[



                    Text('Basic hourly rate (£) *', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: hourlyRateController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Hourly Rate",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                        prefixText: hourlyRateController.text.isNotEmpty ? "£ " : null, // 👈 Show £ only if not empty
                      ),
                      onChanged: (val) => basicHourlyRate = val,
                    ),

                    SizedBox(height: 12),
                    Text('Guaranteed minimum hours per week *', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Hours",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                      onChanged: (val) => guaranteedHours = val,
                    ),
                    SizedBox(height: 10),
                    Divider(),
                  ],

                  // Annual Salary Layout

                  if (incomeType == "Annual salary") ...[


                    Text('Basic annual salary  (£) *', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: annualSalaryController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Annual Salary",
                        prefixText: annualSalaryController.text.isNotEmpty ? "£ " : null, // Show £ only after typing begins
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                      onChanged: (val) => setState(() {
                        annualSalary = val;
                      }),
                    ),
                    SizedBox(height: 10),
                    Divider(),

                  ],

                ],
              ),



              if (employmentType == "Permanent employee" || employmentType == "Contract worker")...[

                Text(
                  "Proof of income",
                  style: TextStyle(fontSize : 16,fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "Please upload a clear copy of your bank statement showing your main income being received. Your bank statement should not be more than one month out of date. Please ensure your bank statement is in a PDF format.",
                  style: TextStyle(fontSize : 12,fontWeight: FontWeight.w500, color: Colors.grey),
                ),
                SizedBox(height: 10),

                Text(
                  "Upload bank statement (PDF) *",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    // File name display field
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: TextEditingController(text: selectedFile?.name ?? ''),
                        decoration: InputDecoration(
                          hintText: "No file selected",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    // Upload button
                    ElevatedButton.icon(
                      icon: Icon(Icons.attach_file, size: 20),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey[50],
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      onPressed: pickBankStatement,
                      label: Text("Choose File"),
                    ),
                  ],
                ),

                SizedBox(height: 10),
                Divider(),

              ],



              Text(
                "Additional information",
                style: TextStyle(fontSize : 16,fontWeight: FontWeight.bold),
              ),
              SizedBox(height:5),

              /// ✅ Probationary Period
              Text("Are you subject to a probationary period? *", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    styledRadioOption<bool>(
                      value: true,
                      groupValue: onProbation,
                      onChanged: (val) => setState(() => onProbation = val),
                      label: "Yes",
                      activeColor: Colors.green,
                    ),

                    Container(width: 1, height: 28, color: Colors.grey[400]),

                    styledRadioOption<bool>(
                      value: false,
                      groupValue: onProbation,
                      onChanged: (val) => setState(() => onProbation = val),
                      label: "No",
                      activeColor: Colors.red,
                    ),
                  ],
                ),
              ),

              if (onProbation == true)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Divider(),
                    Text(
                      'Length of probationary period (months) *',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Months",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onChanged: (val) => probationLength = val,
                    ),



                  ],
                ),
              SizedBox(height: 10),
              Divider(),


              /// ✅ Disciplinary Action
              Text("Are you subject to disciplinary action? *", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,

                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    styledRadioOption<String>(
                      value: "Yes",
                      groupValue: disciplinaryStatus,
                      onChanged: (val) => setState(() {
                        disciplinaryStatus = val!;
                        underDisciplinary = true;
                      }),
                      label: "Yes",
                      activeColor: Colors.green,
                    ),

                    Container(width: 1, height: 28, color: Colors.grey[400]),

                    styledRadioOption<String>(
                      value: "No",
                      groupValue: disciplinaryStatus,
                      onChanged: (val) => setState(() {
                        disciplinaryStatus = val!;
                        underDisciplinary = false;
                      }),
                      label: "No",
                      activeColor: Colors.red,
                    ),

                    Container(width: 1, height: 28, color: Colors.grey[400]),

                    styledRadioOption<String>(
                      value: "Don't know",
                      groupValue: disciplinaryStatus,
                      onChanged: (val) => setState(() {
                        disciplinaryStatus = val!;
                        underDisciplinary = null;
                      }),
                      label: "Don't know",
                      activeColor: Colors.orange,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),
              Divider(),

              /// ✅ Employment Likely to Continue
              Text("Is your employment likely to continue for the foreseeable future? *", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center, // ⬅ ensures items are centered
                  spacing: 8, // space between items

                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // YES
                    styledRadioOption<String>(
                      value: "Yes",
                      groupValue: employmentStatus,
                      onChanged: (val) => setState(() {
                        employmentStatus = val!;
                        employmentFuture = true;
                      }),
                      label: "Yes",
                      activeColor: Colors.green,
                    ),

                    // Divider
                    Container(width: 1, height: 28, color: Colors.grey[400]),

                    // NO
                    styledRadioOption<String>(
                      value: "No",
                      groupValue: employmentStatus,
                      onChanged: (val) => setState(() {
                        employmentStatus = val!;
                        employmentFuture = false;
                      }),
                      label: "No",
                      activeColor: Colors.red,
                    ),

                    // Divider
                    Container(width: 1, height: 28, color: Colors.grey[400]),

                    // DON'T KNOW
                    styledRadioOption<String>(
                      value: "Don't know",
                      groupValue: employmentStatus,
                      onChanged: (val) => setState(() {
                        employmentStatus = val!;
                        employmentFuture = null;
                      }),
                      label: "Don't know",
                      activeColor: Colors.orange,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 15),
              ],


              if (employmentType == "Self employed or business owner") ...[

                Text('Please provide the start date *', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _selectDate(context, startDateController, true),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: startDateController,
                      decoration: InputDecoration(
                        hintText: "Select date",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12),
                Divider(),

                Text("Do you have an accountant? *", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      styledRadioOption<bool>(
                        value: true,
                        groupValue: hasAccountant,
                        onChanged: (val) => setState(() => hasAccountant = val),
                        label: "Yes ",
                        activeColor: Colors.green,
                      ),
                      Container(
                          width: 1,
                          height: 28,
                          color: Colors.grey[400]
                      ),
                      styledRadioOption<bool>(
                        value: false,
                        groupValue: hasAccountant,
                        onChanged: (val) => setState(() => hasAccountant = val),
                        label: "No ",
                        activeColor: Colors.red,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10),
                Divider(),


                if(hasAccountant == true) ...[


                  Text('Accountant Name *', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),

                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Accountant Name",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                    onChanged: (val) => accountantName = val,
                  ),

                  SizedBox(height: 10),
                  Divider(),
                  Text('Is your accountant address in the UK? *', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        styledRadioOption<bool>(
                          value: true,
                          groupValue: accountantinUK,
                          onChanged: (val) => setState(() => accountantinUK = val),
                          label: "Yes ",
                          activeColor: Colors.green,
                        ),
                        Container(
                            width: 1,
                            height: 28,
                            color: Colors.grey[400]
                        ),
                        styledRadioOption<bool>(
                          value: false,
                          groupValue: accountantinUK,
                          onChanged: (val) => setState(() => accountantinUK = val),
                          label: "No ",
                          activeColor: Colors.red,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  // ✅ Manual entry for NON-UK address
                  if (accountantinUK == false) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Please enter address *", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Enter full address",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                          onChanged: (val) {
                            addressController.text = val;
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(),
                  ],

                  if(accountantinUK == true) ...[


                    Column(
                      children: [
                        // UK address section
                          Text(
                            "What is their address? *",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "Postcode",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onChanged: (val) {
                                    postcode = val;
                                  },
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
                                  if (postcode.trim().isNotEmpty) {
                                    selectedPostcode = postcode;
                                    postcodeController.text = postcode.toUpperCase(); // 👈 paste it in uppercase
                                    fetchAddresses(postcode);
                                  }
                                },
                                child: Icon(Icons.search, size: 25),
                              ),
                              SizedBox(height: 10),
                              Divider(),
                            ],
                          ),

                          // Dropdown for address selection
                          if (addressList.isNotEmpty) ...[
                            SizedBox(height: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text('Select Address From Dropdown List',  textAlign : TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  value: selectedAddress,
                                  decoration: InputDecoration(
                                    hintText: "Select Address",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                  items: addressList
                                      .map((e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(e, overflow: TextOverflow.ellipsis),
                                  ))
                                      .toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedAddress = val!;
                                      addressController.text = val;

                                      // ✅ use the previously stored postcode (set during search)
                                      postcodeController.text = selectedPostcode.toUpperCase();
                                    });
                                  },
                                ),
                              ],
                            ),

                          ],
                        // Final read-only fields
                          if (selectedAddress != null) ...[
                            SizedBox(height: 12),
                            // Address Field

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Address', style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                TextFormField(
                                  controller: addressController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    hintText: "Address",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 8),

                            // Postcode Field

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('PostCode', style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                TextFormField(
                                  controller: postcodeController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    hintText: "Postcode",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Divider(),
                          ],
                      ],
                    ),
                  ],

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Referee Name
                      Text('Please provide an appropriate referee name *', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Referee name",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                        onChanged: (val) => refereeName = val,
                      ),

                      SizedBox(height: 12),

                      // Referee Email
                      Text('Please provide their business email address *', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Referee business email",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                        onChanged: (val) => refereeEmail = val,
                      ),

                      SizedBox(height: 12),
                      Divider(),

                      Text("Your reference may be automatically declined if you provide an incorrect email address.", style: TextStyle( fontSize : 16 ,fontWeight: FontWeight.bold)),

                      SizedBox(height: 12),

                      // Confirm Referee Email
                      Text('Please confirm their business email address *', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Confirm referee email",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                        onChanged: (val) => refereeConfirmEmail = val,
                      ),

                      SizedBox(height: 12),

                      // Referee Phone
                      Text('Please provide their telephone number *', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "Referee phone number",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                        onChanged: (val) => refereePhone = val,
                      ),
                    ],
                  ),

                  SizedBox(height: 10),
                  Divider(),


                  Text(
                    "How is your income paid?",
                    style: TextStyle(fontSize : 16,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "You can add several different incomes to your application. Please start by providing your main income.",
                    style: TextStyle(fontSize : 12,fontWeight: FontWeight.w500, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Is your income annual salary or hourly? *",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Annual Salary Button
                      Flexible(
                        child: IntrinsicWidth(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: incomeType == "Annual salary" ? Colors.green : Colors.grey,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Row(
                              children: [
                                Radio<String>(
                                  value: "Annual salary",
                                  groupValue: incomeType,
                                  onChanged: (val) => setState(() => incomeType = val!),
                                  fillColor: WidgetStateProperty.resolveWith<Color>(
                                        (states) => states.contains(WidgetState.selected)
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                ),
                                Text("Annual salary"),
                                SizedBox(width: 12),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 8),
                      Container(height: 28, width: 2, color: Colors.grey[400]),
                      SizedBox(width: 8),

                      // Hourly Rate Button
                      Flexible(
                        child: IntrinsicWidth(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: incomeType == "Hourly rate" ? Colors.red : Colors.grey,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Row(
                              children: [
                                Radio<String>(
                                  value: "Hourly rate",
                                  groupValue: incomeType,
                                  onChanged: (val) => setState(() => incomeType = val!),
                                  fillColor: WidgetStateProperty.resolveWith<Color>(
                                        (states) => states.contains(WidgetState.selected)
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                ),
                                Text("Hourly rate"),
                                SizedBox(width: 12),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),


                  Column(
                    children: [
                      // Hourly Rate Layout
                      if (incomeType == "Hourly rate") ...[
                        SizedBox(height: 12),
                        Text('Basic hourly rate (£) *', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: hourlyRateController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Hourly Rate",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                            prefixText: hourlyRateController.text.isNotEmpty ? "£ " : null, // 👈 Show £ only if not empty
                          ),
                          onChanged: (val) => basicHourlyRate = val,
                        ),

                        SizedBox(height: 12),
                        Text('Guaranteed minimum hours per week *', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Hours",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                          onChanged: (val) => guaranteedHours = val,
                        ),
                      ],

                      // Annual Salary Layout

                      if (incomeType == "Annual salary") ...[
                        SizedBox(height: 12),
                        Text('Basic annual salary  (£) *', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: annualSalaryController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Annual Salary",
                            prefixText: annualSalaryController.text.isNotEmpty ? "£ " : null, // Show £ only after typing begins
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                          onChanged: (val) => setState(() {
                            annualSalary = val;
                          }),
                        ),

                      ],
                      SizedBox(height: 10),
                      Divider(),
                    ],
                  ),


                ],


              if(hasAccountant == false) ...[

                Text('Please confirm your total annual income', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextFormField(
                  controller: annualIncomeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Annual Income",
                    prefixText: annualIncomeController.text.isNotEmpty ? "£ " : null, // Show £ only after typing begins
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  onChanged: (val) => setState(() {
                    annualIncome = val;
                  }),
                ),
                SizedBox(height: 10),

                Text(
                  "Please upload a copy of your last 2 year's tax returns",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    // File name display field
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: TextEditingController(text: selectedFile?.name ?? ''),
                        decoration: InputDecoration(
                          hintText: "No file selected",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    // Upload button
                    ElevatedButton.icon(
                      icon: Icon(Icons.attach_file, size: 20),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey[50],
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      onPressed: pickTaxReturns,
                      label: Text("Choose File"),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Divider(),

               ],
              ],





              ////////////////////////////////////////
              if (employmentType == "Self employed or business owner") ...[

                Text(
                  "Proof of income",
                  style: TextStyle(fontSize : 16,fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "Please upload a clear copy of your bank statement showing your main income being received. Your bank statement should not be more than one month out of date. Please ensure your bank statement is in a PDF format.",
                  style: TextStyle(fontSize : 12,fontWeight: FontWeight.w500, color: Colors.grey),
                ),
                SizedBox(height: 10),

                Text(
                  "Upload bank statement (PDF) *",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    // File name display field
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: TextEditingController(text: selectedFile?.name ?? ''),
                        decoration: InputDecoration(
                          hintText: "No file selected",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    // Upload button
                    ElevatedButton.icon(
                      icon: Icon(Icons.attach_file, size: 20),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey[50],
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      onPressed: pickBankStatement,
                      label: Text("Choose File"),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Divider(),
              ],




              if (employmentType == "Retired") ...[

                Text('Please provide the start date *', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _selectDate(context, startDateController, true),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: startDateController,
                      decoration: InputDecoration(
                        hintText: "Select date",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),
                Text('Total Pension Income (£) *', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextFormField(
                  controller: annualIncomeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Pension Income",
                    prefixText: annualIncomeController.text.isNotEmpty ? "£ " : null, // Show £ only after typing begins
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  onChanged: (val) => setState(() {
                    annualIncome = val;
                  }),
                ),

                SizedBox(height: 10),
                Text(
                  "Please upload a copy of your most recent P60/DWP pension award letter.",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    // File name display field
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: TextEditingController(text: selectedFile?.name ?? ''),
                        decoration: InputDecoration(
                          hintText: "No file selected",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    // Upload button
                    ElevatedButton.icon(
                      icon: Icon(Icons.attach_file, size: 20),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey[50],
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      onPressed: pickBankStatement,
                      label: Text("Attach File"),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Divider(),


                Text(
                  "Proof of income",
                  style: TextStyle(fontSize : 16,fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "Please upload a clear copy of your bank statement showing your main income being received. Your bank statement should not be more than one month out of date. Please ensure your bank statement is in a PDF format.",
                  style: TextStyle(fontSize : 12,fontWeight: FontWeight.w500, color: Colors.grey),
                ),
                SizedBox(height: 10),

                Text(
                  "Upload bank statement (PDF) *",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    // File name display field
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: TextEditingController(text: selectedFile?.name ?? ''),
                        decoration: InputDecoration(
                          hintText: "No file selected",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    // Upload button
                    ElevatedButton.icon(
                      icon: Icon(Icons.attach_file, size: 20),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey[50],
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      onPressed: pickBankStatement,
                      label: Text("Choose File"),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
              ],

/////////////////////////////////////// Additional income section

              ...incomeSections.asMap().entries.map((entry) {
                final index = entry.key;
                final section = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Additional Income *", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: section.incomeType,
                      decoration: InputDecoration(
                        hintText: '--- Select ---',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                      icon: Icon(Icons.arrow_drop_down),
                      style: TextStyle(color: Colors.black87, fontSize: 16),
                      dropdownColor: Colors.white,
                      onChanged: (val) {
                        setState(() {
                          section.incomeType = val;
                          section.showExtraFields = val != null;
                        });
                      },
                      items: incomeTypes
                          .map((e) => DropdownMenuItem(child: Text(e), value: e))
                          .toList(),
                      validator: (val) => val == null ? 'Required' : null,
                    ),
                    SizedBox(height: 10),
                    Divider(),

                    if (!section.showExtraFields) ...[
                      ElevatedButton(
                        onPressed: () => removeIncomeSection(index),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                        child: Text("Remove"),
                      ),
                      SizedBox(height: 10),
                      Divider(),
                    ],

                    if (section.showExtraFields) ...[
                      if (section.incomeType == 'Additional Job') ...[
                        Text('Tell us about your income', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),

                        Text("In this section we would like you to tell us about your income. Please ensure you answer these questions honestly and accurately. This will avoid any delays or negative results with your reference. If you do not know the answers to any questions, you can save the form and return to it later.", style: TextStyle(color: Colors.grey.shade600),),

                        SizedBox(height: 5),
                        Divider(),
                        SizedBox(height: 5),

                        Text("Employment or Income Type *", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Column(
                          children: [
                            "Permanent employee",
                            "Self employed or business owner",
                            "Contract worker",
                            "Temporary employee",
                            "Retired",
                            "Homemaker",
                            "Unemployed or other income",
                            "Zero-hours employee",
                            "Student",
                          ].map(
                                (e) => Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor: Colors.grey, // unselected radio
                                radioTheme: RadioThemeData(
                                  fillColor: WidgetStateProperty.all(Colors.grey), // selected radio
                                ),
                              ),
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200], // light grey background
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: RadioListTile<String>(
                                  title: Text(e),
                                  value: e,
                                  groupValue: employmentType1,
                                  activeColor: Colors.grey, // radio selected color
                                  onChanged: (val) {
                                    setState(() {
                                      employmentType1 = val!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ).toList(),
                        ),

                        SizedBox(height:10),
                        Divider(),

                        if (employmentType1 == "Homemaker" || employmentType1 == "Student" || employmentType1 == "Unemployed or other income")...[
                          Text('Please provide the start date *', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => _selectDate(context, startDateController, true),
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: startDateController,
                                decoration: InputDecoration(
                                  hintText: "Select date",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Divider(),
                          SizedBox(height: 10),

                        ],





                        if (employmentType1 == "Permanent employee"  || employmentType1 == "Contract worker" || employmentType1 == "Temporary employee" || employmentType1 == "Zero-hours employee") ...[

                          if (employmentType1 == "Zero-hours employee")...[

                            Text('Please provide the start date *', style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _selectDate(context, startDateController, true),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: startDateController,
                                  decoration: InputDecoration(
                                    hintText: "Select date",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),



                          ],

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Business name of your employer *",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Business Name",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (val) => businessName = val,
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(),


                          if(employmentType1 == "Contract worker") ...[
                            ///////

                            Text('Please provide the start date *', style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _selectDate(context, startDateController, true),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: startDateController,
                                  decoration: InputDecoration(
                                    hintText: "Select date",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 10),

                            Text(
                              "Your contract end date *",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _selectDate(context, endDateController, false),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: endDateController,
                                  decoration: InputDecoration(
                                    hintText: "Select end date",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 10),
                            Divider(),


                          ],


                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Is your employer's address in the UK? *",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // YES option
                                  Flexible(
                                    child: IntrinsicWidth(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: isUkAddress == true ? Colors.green : Colors.grey,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                        child: Row(
                                          children: [
                                            Radio<bool>(
                                              value: true,
                                              groupValue: isUkAddress,
                                              onChanged: (val) {
                                                setState(() {
                                                  isUkAddress = val;
                                                  // Reset address only if switching from false to true
                                                  if (isUkAddress == true) {
                                                    addressList = [];
                                                    selectedAddress = null;
                                                    postcode = '';
                                                    selectedPostcode = '';
                                                  }
                                                });
                                              },
                                              fillColor: WidgetStateProperty.resolveWith<Color>(
                                                    (states) => states.contains(WidgetState.selected)
                                                    ? Colors.green
                                                    : Colors.grey,
                                              ),
                                            ),
                                            Text("Yes"),
                                            SizedBox(width: 12),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Container(height: 28, width: 1, color: Colors.grey[400]),
                                  SizedBox(width: 8),

                                  // NO option
                                  Flexible(
                                    child: IntrinsicWidth(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: isUkAddress == false ? Colors.red : Colors.grey,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                        child: Row(
                                          children: [
                                            Radio<bool>(
                                              value: false,
                                              groupValue: isUkAddress,
                                              onChanged: (val) {
                                                setState(() {
                                                  isUkAddress = val;
                                                  // Clear UK address-related fields
                                                  addressList = [];
                                                  selectedAddress = null;
                                                  postcode = '';
                                                  selectedPostcode = '';
                                                });
                                              },
                                              fillColor: WidgetStateProperty.resolveWith<Color>(
                                                    (states) => states.contains(WidgetState.selected)
                                                    ? Colors.red
                                                    : Colors.grey,
                                              ),
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


                              Column(
                                children: [


                                  // UK address section
                                  if (isUkAddress == true) ...[
                                    SizedBox(height: 10),
                                    Divider(),

                                    Text(
                                      "What is their address? *",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),

                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              hintText: "Postcode",
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                            ),
                                            onChanged: (val) {
                                              postcode = val;
                                            },
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
                                            if (postcode.trim().isNotEmpty) {
                                              selectedPostcode = postcode;
                                              postcodeController.text = postcode.toUpperCase(); // 👈 paste it in uppercase
                                              fetchAddresses(postcode);
                                            }
                                          },
                                          child: Icon(Icons.search, size: 25),
                                        ),
                                        SizedBox(height: 10),
                                        Divider(),
                                      ],
                                    ),

                                    // Dropdown for address selection
                                    if (addressList.isNotEmpty) ...[
                                      SizedBox(height: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Text('Select Address From Dropdown List',  textAlign : TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(height: 8),
                                          DropdownButtonFormField<String>(
                                            isExpanded: true,
                                            value: selectedAddress,
                                            decoration: InputDecoration(
                                              hintText: "Select Address",
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                            ),
                                            items: addressList
                                                .map((e) => DropdownMenuItem<String>(
                                              value: e,
                                              child: Text(e, overflow: TextOverflow.ellipsis),
                                            ))
                                                .toList(),
                                            onChanged: (val) {
                                              setState(() {
                                                selectedAddress = val!;
                                                addressController.text = val;

                                                // ✅ use the previously stored postcode (set during search)
                                                postcodeController.text = selectedPostcode.toUpperCase();
                                              });
                                            },
                                          ),
                                        ],
                                      ),

                                    ],

                                  // Final read-only fields
                                    if (selectedAddress != null) ...[
                                      SizedBox(height: 12),
                                      // Address Field

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Address', style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(height: 8),
                                          TextFormField(
                                            controller: addressController,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              hintText: "Address",
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 8),

                                      // Postcode Field

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('PostCode', style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(height: 8),
                                          TextFormField(
                                            controller: postcodeController,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              hintText: "Postcode",
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],

                                  // ✅ Manual entry for NON-UK address
                                  if (isUkAddress == false) ...[
                                    SizedBox(height: 10),
                                    Divider(),

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Please enter address *", style: TextStyle(fontWeight: FontWeight.bold)),
                                        SizedBox(height: 10),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            hintText: "Enter full address",
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                          ),
                                          onChanged: (val) {
                                            addressController.text = val;
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              // Job Title
                              Text('Please provide your job title or position *', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Job title or position",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                                onChanged: (val) => jobTitle = val,
                              ),

                              SizedBox(height: 12),

                              // Start Date
                              Text('Please provide the start date *', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              GestureDetector(
                                onTap: () => _selectDate(context, startDateController, true),
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: startDateController,
                                    decoration: InputDecoration(
                                      hintText: "Select date",
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 12),

                              // Referee Name
                              Text('Please provide an appropriate referee name *', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Referee name",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                                onChanged: (val) => refereeName = val,
                              ),

                              SizedBox(height: 12),

                              // Referee Email
                              Text('Please provide their business email address *', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Referee business email",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                                onChanged: (val) => refereeEmail = val,
                              ),

                              SizedBox(height: 12),
                              Divider(),

                              Text("Your reference may be automatically declined if you provide an incorrect email address.", style: TextStyle( fontSize : 16 ,fontWeight: FontWeight.bold)),

                              SizedBox(height: 12),

                              // Confirm Referee Email
                              Text('Please confirm their business email address *', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Confirm referee email",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                                onChanged: (val) => refereeConfirmEmail = val,
                              ),

                              SizedBox(height: 12),

                              // Referee Phone
                              Text('Please provide their telephone number *', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              TextFormField(
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: "Referee phone number",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                                onChanged: (val) => refereePhone = val,
                              ),
                            ],
                          ),

                          SizedBox(height: 10),
                          Divider(),


                          Text(
                            "How is your income paid?",
                            style: TextStyle(fontSize : 16,fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "You can add several different incomes to your application. Please start by providing your main income.",
                            style: TextStyle(fontSize : 12,fontWeight: FontWeight.w500, color: Colors.grey),
                          ),
                          SizedBox(height: 10),

                          Text(
                            "Is your income annual salary or hourly? *",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Annual Salary Button
                              Flexible(
                                child: IntrinsicWidth(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: incomeType == "Annual salary" ? Colors.green : Colors.grey,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Radio<String>(
                                          value: "Annual salary",
                                          groupValue: incomeType,
                                          onChanged: (val) => setState(() => incomeType = val!),
                                          fillColor: WidgetStateProperty.resolveWith<Color>(
                                                (states) => states.contains(WidgetState.selected)
                                                ? Colors.green
                                                : Colors.grey,
                                          ),
                                        ),
                                        Text("Annual salary"),
                                        SizedBox(width: 12),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: 8),
                              Container(height: 28, width: 2, color: Colors.grey[400]),
                              SizedBox(width: 8),

                              // Hourly Rate Button
                              Flexible(
                                child: IntrinsicWidth(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: incomeType == "Hourly rate" ? Colors.red : Colors.grey,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Radio<String>(
                                          value: "Hourly rate",
                                          groupValue: incomeType,
                                          onChanged: (val) => setState(() => incomeType = val!),
                                          fillColor: WidgetStateProperty.resolveWith<Color>(
                                                (states) => states.contains(WidgetState.selected)
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                        ),
                                        Text("Hourly rate"),
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

                          Column(
                            children: [

                              // Hourly Rate Layout
                              if (incomeType == "Hourly rate") ...[



                                Text('Basic hourly rate (£) *', style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                TextFormField(
                                  controller: hourlyRateController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: "Hourly Rate",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                    prefixText: hourlyRateController.text.isNotEmpty ? "£ " : null, // 👈 Show £ only if not empty
                                  ),
                                  onChanged: (val) => basicHourlyRate = val,
                                ),

                                SizedBox(height: 12),
                                Text('Guaranteed minimum hours per week *', style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: "Hours",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                  onChanged: (val) => guaranteedHours = val,
                                ),
                                SizedBox(height: 10),
                                Divider(),
                              ],

                              // Annual Salary Layout

                              if (incomeType == "Annual salary") ...[


                                Text('Basic annual salary  (£) *', style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                TextFormField(
                                  controller: annualSalaryController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: "Annual Salary",
                                    prefixText: annualSalaryController.text.isNotEmpty ? "£ " : null, // Show £ only after typing begins
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                  onChanged: (val) => setState(() {
                                    annualSalary = val;
                                  }),
                                ),
                                SizedBox(height: 10),
                                Divider(),

                              ],

                            ],
                          ),



                          if (employmentType1 == "Permanent employee" || employmentType1 == "Contract worker")...[

                            Text(
                              "Proof of income",
                              style: TextStyle(fontSize : 16,fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Please upload a clear copy of your bank statement showing your main income being received. Your bank statement should not be more than one month out of date. Please ensure your bank statement is in a PDF format.",
                              style: TextStyle(fontSize : 12,fontWeight: FontWeight.w500, color: Colors.grey),
                            ),
                            SizedBox(height: 10),

                            Text(
                              "Upload bank statement (PDF) *",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                // File name display field
                                Expanded(
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: TextEditingController(text: selectedFile?.name ?? ''),
                                    decoration: InputDecoration(
                                      hintText: "No file selected",
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                // Upload button
                                ElevatedButton.icon(
                                  icon: Icon(Icons.attach_file, size: 20),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueGrey[50],
                                    foregroundColor: Colors.black87,
                                    elevation: 0,
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                  ),
                                  onPressed: pickBankStatement,
                                  label: Text("Choose File"),
                                ),
                              ],
                            ),

                            SizedBox(height: 10),
                            Divider(),

                          ],



                          Text(
                            "Additional information",
                            style: TextStyle(fontSize : 16,fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height:5),

                          /// ✅ Probationary Period
                          Text("Are you subject to a probationary period? *", style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Center(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 8,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                styledRadioOption<bool>(
                                  value: true,
                                  groupValue: onProbation,
                                  onChanged: (val) => setState(() => onProbation = val),
                                  label: "Yes",
                                  activeColor: Colors.green,
                                ),

                                Container(width: 1, height: 28, color: Colors.grey[400]),

                                styledRadioOption<bool>(
                                  value: false,
                                  groupValue: onProbation,
                                  onChanged: (val) => setState(() => onProbation = val),
                                  label: "No",
                                  activeColor: Colors.red,
                                ),
                              ],
                            ),
                          ),

                          if (onProbation == true)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Divider(),
                                Text(
                                  'Length of probationary period (months) *',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: "Months",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onChanged: (val) => probationLength = val,
                                ),



                              ],
                            ),
                          SizedBox(height: 10),
                          Divider(),


                          /// ✅ Disciplinary Action
                          Text("Are you subject to disciplinary action? *", style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Center(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 8,

                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                styledRadioOption<String>(
                                  value: "Yes",
                                  groupValue: disciplinaryStatus,
                                  onChanged: (val) => setState(() {
                                    disciplinaryStatus = val!;
                                    underDisciplinary = true;
                                  }),
                                  label: "Yes",
                                  activeColor: Colors.green,
                                ),

                                Container(width: 1, height: 28, color: Colors.grey[400]),

                                styledRadioOption<String>(
                                  value: "No",
                                  groupValue: disciplinaryStatus,
                                  onChanged: (val) => setState(() {
                                    disciplinaryStatus = val!;
                                    underDisciplinary = false;
                                  }),
                                  label: "No",
                                  activeColor: Colors.red,
                                ),

                                Container(width: 1, height: 28, color: Colors.grey[400]),

                                styledRadioOption<String>(
                                  value: "Don't know",
                                  groupValue: disciplinaryStatus,
                                  onChanged: (val) => setState(() {
                                    disciplinaryStatus = val!;
                                    underDisciplinary = null;
                                  }),
                                  label: "Don't know",
                                  activeColor: Colors.orange,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 10),
                          Divider(),

                          /// ✅ Employment Likely to Continue
                          Text("Is your employment likely to continue for the foreseeable future? *", style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Center(
                            child: Wrap(
                              alignment: WrapAlignment.center, // ⬅ ensures items are centered
                              spacing: 8, // space between items

                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                // YES
                                styledRadioOption<String>(
                                  value: "Yes",
                                  groupValue: employmentStatus,
                                  onChanged: (val) => setState(() {
                                    employmentStatus = val!;
                                    employmentFuture = true;
                                  }),
                                  label: "Yes",
                                  activeColor: Colors.green,
                                ),

                                // Divider
                                Container(width: 1, height: 28, color: Colors.grey[400]),

                                // NO
                                styledRadioOption<String>(
                                  value: "No",
                                  groupValue: employmentStatus,
                                  onChanged: (val) => setState(() {
                                    employmentStatus = val!;
                                    employmentFuture = false;
                                  }),
                                  label: "No",
                                  activeColor: Colors.red,
                                ),

                                // Divider
                                Container(width: 1, height: 28, color: Colors.grey[400]),

                                // DON'T KNOW
                                styledRadioOption<String>(
                                  value: "Don't know",
                                  groupValue: employmentStatus,
                                  onChanged: (val) => setState(() {
                                    employmentStatus = val!;
                                    employmentFuture = null;
                                  }),
                                  label: "Don't know",
                                  activeColor: Colors.orange,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Divider(),
                          SizedBox(height: 15),
                        ],


                        if (employmentType1 == "Self employed or business owner") ...[

                          Text('Please provide the start date *', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => _selectDate(context, startDateController, true),
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: startDateController,
                                decoration: InputDecoration(
                                  hintText: "Select date",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 12),
                          Divider(),

                          Text("Do you have an accountant? *", style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Center(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 8,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                styledRadioOption<bool>(
                                  value: true,
                                  groupValue: hasAccountant,
                                  onChanged: (val) => setState(() => hasAccountant = val),
                                  label: "Yes ",
                                  activeColor: Colors.green,
                                ),
                                Container(
                                    width: 1,
                                    height: 28,
                                    color: Colors.grey[400]
                                ),
                                styledRadioOption<bool>(
                                  value: false,
                                  groupValue: hasAccountant,
                                  onChanged: (val) => setState(() => hasAccountant = val),
                                  label: "No ",
                                  activeColor: Colors.red,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 10),
                          Divider(),


                          if(hasAccountant == true) ...[


                            Text('Accountant Name *', style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),

                            TextFormField(
                              decoration: InputDecoration(
                                hintText: "Accountant Name",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                              ),
                              onChanged: (val) => accountantName = val,
                            ),

                            SizedBox(height: 10),
                            Divider(),
                            Text('Is your accountant address in the UK? *', style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Center(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 8,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  styledRadioOption<bool>(
                                    value: true,
                                    groupValue: accountantinUK,
                                    onChanged: (val) => setState(() => accountantinUK = val),
                                    label: "Yes ",
                                    activeColor: Colors.green,
                                  ),
                                  Container(
                                      width: 1,
                                      height: 28,
                                      color: Colors.grey[400]
                                  ),
                                  styledRadioOption<bool>(
                                    value: false,
                                    groupValue: accountantinUK,
                                    onChanged: (val) => setState(() => accountantinUK = val),
                                    label: "No ",
                                    activeColor: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Divider(),
                            // ✅ Manual entry for NON-UK address
                            if (accountantinUK == false) ...[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Please enter address *", style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "Enter full address",
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                    ),
                                    onChanged: (val) {
                                      addressController.text = val;
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Divider(),
                            ],

                            if(accountantinUK == true) ...[


                              Column(
                                children: [
                                  // UK address section
                                  Text(
                                    "What is their address? *",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),

                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            hintText: "Postcode",
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                          ),
                                          onChanged: (val) {
                                            postcode = val;
                                          },
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
                                          if (postcode.trim().isNotEmpty) {
                                            selectedPostcode = postcode;
                                            postcodeController.text = postcode.toUpperCase(); // 👈 paste it in uppercase
                                            fetchAddresses(postcode);
                                          }
                                        },
                                        child: Icon(Icons.search, size: 25),
                                      ),
                                      SizedBox(height: 10),
                                      Divider(),
                                    ],
                                  ),

                                  // Dropdown for address selection
                                  if (addressList.isNotEmpty) ...[
                                    SizedBox(height: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Text('Select Address From Dropdown List',  textAlign : TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold)),
                                        SizedBox(height: 8),
                                        DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          value: selectedAddress,
                                          decoration: InputDecoration(
                                            hintText: "Select Address",
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                          ),
                                          items: addressList
                                              .map((e) => DropdownMenuItem<String>(
                                            value: e,
                                            child: Text(e, overflow: TextOverflow.ellipsis),
                                          ))
                                              .toList(),
                                          onChanged: (val) {
                                            setState(() {
                                              selectedAddress = val!;
                                              addressController.text = val;

                                              // ✅ use the previously stored postcode (set during search)
                                              postcodeController.text = selectedPostcode.toUpperCase();
                                            });
                                          },
                                        ),
                                      ],
                                    ),

                                  ],
                                  // Final read-only fields
                                  if (selectedAddress != null) ...[
                                    SizedBox(height: 12),
                                    // Address Field

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Address', style: TextStyle(fontWeight: FontWeight.bold)),
                                        SizedBox(height: 8),
                                        TextFormField(
                                          controller: addressController,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            hintText: "Address",
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 8),

                                    // Postcode Field

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('PostCode', style: TextStyle(fontWeight: FontWeight.bold)),
                                        SizedBox(height: 8),
                                        TextFormField(
                                          controller: postcodeController,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            hintText: "Postcode",
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Divider(),
                                  ],
                                ],
                              ),
                            ],

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Referee Name
                                Text('Please provide an appropriate referee name *', style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "Referee name",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                  onChanged: (val) => refereeName = val,
                                ),

                                SizedBox(height: 12),

                                // Referee Email
                                Text('Please provide their business email address *', style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "Referee business email",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                  onChanged: (val) => refereeEmail = val,
                                ),

                                SizedBox(height: 12),
                                Divider(),

                                Text("Your reference may be automatically declined if you provide an incorrect email address.", style: TextStyle( fontSize : 16 ,fontWeight: FontWeight.bold)),

                                SizedBox(height: 12),

                                // Confirm Referee Email
                                Text('Please confirm their business email address *', style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "Confirm referee email",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                  onChanged: (val) => refereeConfirmEmail = val,
                                ),

                                SizedBox(height: 12),

                                // Referee Phone
                                Text('Please provide their telephone number *', style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                TextFormField(
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: "Referee phone number",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                  onChanged: (val) => refereePhone = val,
                                ),
                              ],
                            ),

                            SizedBox(height: 10),
                            Divider(),


                            Text(
                              "How is your income paid?",
                              style: TextStyle(fontSize : 16,fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "You can add several different incomes to your application. Please start by providing your main income.",
                              style: TextStyle(fontSize : 12,fontWeight: FontWeight.w500, color: Colors.grey),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Is your income annual salary or hourly? *",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Annual Salary Button
                                Flexible(
                                  child: IntrinsicWidth(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: incomeType == "Annual salary" ? Colors.green : Colors.grey,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Radio<String>(
                                            value: "Annual salary",
                                            groupValue: incomeType,
                                            onChanged: (val) => setState(() => incomeType = val!),
                                            fillColor: WidgetStateProperty.resolveWith<Color>(
                                                  (states) => states.contains(WidgetState.selected)
                                                  ? Colors.green
                                                  : Colors.grey,
                                            ),
                                          ),
                                          Text("Annual salary"),
                                          SizedBox(width: 12),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(width: 8),
                                Container(height: 28, width: 2, color: Colors.grey[400]),
                                SizedBox(width: 8),

                                // Hourly Rate Button
                                Flexible(
                                  child: IntrinsicWidth(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: incomeType == "Hourly rate" ? Colors.red : Colors.grey,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Radio<String>(
                                            value: "Hourly rate",
                                            groupValue: incomeType,
                                            onChanged: (val) => setState(() => incomeType = val!),
                                            fillColor: WidgetStateProperty.resolveWith<Color>(
                                                  (states) => states.contains(WidgetState.selected)
                                                  ? Colors.red
                                                  : Colors.grey,
                                            ),
                                          ),
                                          Text("Hourly rate"),
                                          SizedBox(width: 12),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),


                            Column(
                              children: [
                                // Hourly Rate Layout
                                if (incomeType == "Hourly rate") ...[
                                  SizedBox(height: 12),
                                  Text('Basic hourly rate (£) *', style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  TextFormField(
                                    controller: hourlyRateController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "Hourly Rate",
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                      prefixText: hourlyRateController.text.isNotEmpty ? "£ " : null, // 👈 Show £ only if not empty
                                    ),
                                    onChanged: (val) => basicHourlyRate = val,
                                  ),

                                  SizedBox(height: 12),
                                  Text('Guaranteed minimum hours per week *', style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "Hours",
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                    ),
                                    onChanged: (val) => guaranteedHours = val,
                                  ),
                                ],

                                // Annual Salary Layout

                                if (incomeType == "Annual salary") ...[
                                  SizedBox(height: 12),
                                  Text('Basic annual salary  (£) *', style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  TextFormField(
                                    controller: annualSalaryController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "Annual Salary",
                                      prefixText: annualSalaryController.text.isNotEmpty ? "£ " : null, // Show £ only after typing begins
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                    ),
                                    onChanged: (val) => setState(() {
                                      annualSalary = val;
                                    }),
                                  ),

                                ],
                                SizedBox(height: 10),
                                Divider(),
                              ],
                            ),


                          ],


                          if(hasAccountant == false) ...[

                            Text('Please confirm your total annual income', style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            TextFormField(
                              controller: annualIncomeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Annual Income",
                                prefixText: annualIncomeController.text.isNotEmpty ? "£ " : null, // Show £ only after typing begins
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                              ),
                              onChanged: (val) => setState(() {
                                annualIncome = val;
                              }),
                            ),
                            SizedBox(height: 10),

                            Text(
                              "Please upload a copy of your last 2 year's tax returns",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                // File name display field
                                Expanded(
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: TextEditingController(text: selectedFile?.name ?? ''),
                                    decoration: InputDecoration(
                                      hintText: "No file selected",
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                // Upload button
                                ElevatedButton.icon(
                                  icon: Icon(Icons.attach_file, size: 20),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueGrey[50],
                                    foregroundColor: Colors.black87,
                                    elevation: 0,
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                  ),
                                  onPressed: pickTaxReturns,
                                  label: Text("Choose File"),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Divider(),

                          ],
                        ],





                        ////////////////////////////////////////
                        if (employmentType1 == "Self employed or business owner") ...[

                          Text(
                            "Proof of income",
                            style: TextStyle(fontSize : 16,fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Please upload a clear copy of your bank statement showing your main income being received. Your bank statement should not be more than one month out of date. Please ensure your bank statement is in a PDF format.",
                            style: TextStyle(fontSize : 12,fontWeight: FontWeight.w500, color: Colors.grey),
                          ),
                          SizedBox(height: 10),

                          Text(
                            "Upload bank statement (PDF) *",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              // File name display field
                              Expanded(
                                child: TextFormField(
                                  readOnly: true,
                                  controller: TextEditingController(text: selectedFile?.name ?? ''),
                                  decoration: InputDecoration(
                                    hintText: "No file selected",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              // Upload button
                              ElevatedButton.icon(
                                icon: Icon(Icons.attach_file, size: 20),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey[50],
                                  foregroundColor: Colors.black87,
                                  elevation: 0,
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                ),
                                onPressed: pickBankStatement,
                                label: Text("Choose File"),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(),
                        ],




                        if (employmentType1 == "Retired") ...[

                          Text('Please provide the start date *', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => _selectDate(context, startDateController, true),
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: startDateController,
                                decoration: InputDecoration(
                                  hintText: "Select date",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 10),
                          Text('Total Pension Income (£) *', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: annualIncomeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Pension Income",
                              prefixText: annualIncomeController.text.isNotEmpty ? "£ " : null, // Show £ only after typing begins
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                            ),
                            onChanged: (val) => setState(() {
                              annualIncome = val;
                            }),
                          ),

                          SizedBox(height: 10),
                          Text(
                            "Please upload a copy of your most recent P60/DWP pension award letter.",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              // File name display field
                              Expanded(
                                child: TextFormField(
                                  readOnly: true,
                                  controller: TextEditingController(text: selectedFile?.name ?? ''),
                                  decoration: InputDecoration(
                                    hintText: "No file selected",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              // Upload button
                              ElevatedButton.icon(
                                icon: Icon(Icons.attach_file, size: 20),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey[50],
                                  foregroundColor: Colors.black87,
                                  elevation: 0,
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                ),
                                onPressed: pickBankStatement,
                                label: Text("Attach File"),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(),


                          Text(
                            "Proof of income",
                            style: TextStyle(fontSize : 16,fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Please upload a clear copy of your bank statement showing your main income being received. Your bank statement should not be more than one month out of date. Please ensure your bank statement is in a PDF format.",
                            style: TextStyle(fontSize : 12,fontWeight: FontWeight.w500, color: Colors.grey),
                          ),
                          SizedBox(height: 10),

                          Text(
                            "Upload bank statement (PDF) *",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              // File name display field
                              Expanded(
                                child: TextFormField(
                                  readOnly: true,
                                  controller: TextEditingController(text: selectedFile?.name ?? ''),
                                  decoration: InputDecoration(
                                    hintText: "No file selected",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              // Upload button
                              ElevatedButton.icon(
                                icon: Icon(Icons.attach_file, size: 20),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey[50],
                                  foregroundColor: Colors.black87,
                                  elevation: 0,
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                ),
                                onPressed: pickBankStatement,
                                label: Text("Choose File"),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(),
                          SizedBox(height: 10),
                        ],
                      ] else ...[
                        Text("Please state whether income is *", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: section.guarantee,
                          decoration: InputDecoration(
                            hintText: '--- Select ---',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                          onChanged: (val) => setState(() => section.guarantee = val),
                          items: guaranteeTypes
                              .map((e) => DropdownMenuItem(child: Text(e), value: e))
                              .toList(),
                        ),
                        SizedBox(height: 10),
                        Text("Additional Income Amount *", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            setState(() => value = val);
                            widget.onChanged(val);
                          },
                          decoration: InputDecoration(
                            hintText: "Amount (£)",
                            prefixText: value.isNotEmpty ? '£ ' : null,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text("Is this amount received *", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: section.frequency,
                          decoration: InputDecoration(
                            hintText: '--- Select ---',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                          onChanged: (val) => setState(() => section.frequency = val),
                          items: frequencies
                              .map((e) => DropdownMenuItem(child: Text(e), value: e))
                              .toList(),
                        ),
                        SizedBox(height: 10),
                      ],

                      /// 👇 Remove button after all extra fields
                      ElevatedButton(
                        onPressed: () => removeIncomeSection(index),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                        child: Text("Remove"),
                      ),
                      SizedBox(height: 10),
                      Divider(),
                    ],
                  ],
                );
              }),


              // Button to Add More Sections
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "Do you wish to add an additional income e.g. bonuses, commission, additional employment, benefits, pensions etc.?",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: addIncomeSection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[900],
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Add Income"),
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 10),




              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Submit logic here
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                    backgroundColor: Colors.green[800],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("Next", style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }




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
          mainAxisSize: MainAxisSize.min,  // Important for proper sizing
          children: [
            Radio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              fillColor: WidgetStateProperty.resolveWith<Color>(
                    (states) => states.contains(WidgetState.selected)
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


  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool?>('onProbation', onProbation));
  }

}

class IncomeSection {
  String? incomeType;
  bool showExtraFields = false;
  String? guarantee;
  String? frequency;
  String? employmentType;
  String? amount ;
}