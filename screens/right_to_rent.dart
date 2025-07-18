import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NationalityForm extends StatefulWidget {
  @override
  _NationalityFormState createState() => _NationalityFormState();
}

class _NationalityFormState extends State<NationalityForm> {
  String? selectedNationality;
  String? selectedDocument;
  final formKey = GlobalKey<FormState>();
  DateTime? dob;
  final TextEditingController fileNameController = TextEditingController();

  @override
  void dispose() {
    fileNameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, DateTime? initialDate, ValueSetter<DateTime?> setDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != initialDate) {
      setDate(picked);
    }
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      String fileName = result.files.single.name;
      fileNameController.text = fileName;
    }
  }

  final List<String> nationalities = [/* (Same list as before) */
    'British', 'Afghan', 'Albanian', 'Algerian', 'American', 'Andorran', 'Angolan',
    'Antiguans', 'Argentinean', 'Armenian', 'Australian', 'Austrian', 'Azerbaijani',
    'Bahamian', 'Bahraini', 'Bangladeshi', 'Barbadian', 'Barbudans', 'Batswana',
    'Belarusian', 'Belgian', 'Belizean', 'Beninese', 'Bhutanese', 'Bolivian',
    'Bosnian', 'Brazilian',  'Bruneian', 'Bulgarian', 'Burkinabe',
    'Burmese', 'Burundian', 'Cambodian', 'Cameroonian', 'Canadian', 'Cape Verdean',
    'Central African', 'Chadian', 'Chilean', 'Chinese', 'Colombian', 'Comoran',
    'Congolese', 'Costa Rican', 'Croatian', 'Cuban', 'Cypriot', 'Czech',
    'Danish', 'Djibouti', 'Dominican', 'East Timorese', 'Ecuadorian', 'Egyptian',
    'Emirati', 'Equatorial Guinean', 'Eritrean', 'Estonian', 'Ethiopian',
    'Fijian', 'Filipino', 'Finnish', 'French', 'Gabonese', 'Gambian', 'Georgian',
    'German', 'Ghanaian', 'Greek', 'Grenadian', 'Guatemalan', 'Guinea-Bissauan',
    'Guinean', 'Guyanese', 'Haitian', 'Herzegovinian', 'Honduran', 'Hungarian',
    'I-Kiribati', 'Icelander', 'Indian', 'Indonesian', 'Iranian', 'Iraqi',
    'Irish', 'Israeli', 'Italian', 'Ivorian', 'Jamaican', 'Japanese', 'Jordanian',
    'Kazakh', 'Kenyan', 'Kittian and Nevisian', 'Kuwaiti', 'Kyrgyz', 'Laotian',
    'Latvian', 'Lebanese', 'Liberian', 'Libyan', 'Liechtensteiner', 'Lithuanian',
    'Luxembourger', 'Macedonian', 'Malagasy', 'Malawian', 'Malaysian', 'Maldivian',
    'Malian', 'Maltese', 'Marshallese', 'Mauritanian', 'Mauritian', 'Mexican',
    'Micronesian', 'Moldovan', 'Monacan', 'Mongolian', 'Moroccan', 'Mosotho',
    'Motswana', 'Mozambican', 'Namibian', 'Nauruan', 'Nepalese', 'New Zealander',
    'Nicaraguan', 'Nigerian', 'Nigerien', 'North Korean', 'Northern Irish',
    'Norwegian', 'Omani', 'Pakistani', 'Palauan', 'Palestinian', 'Panamanian',
    'Papua New Guinean', 'Paraguayan', 'Peruvian', 'Polish', 'Portuguese', 'Qatari',
    'Romanian', 'Russian', 'Rwandan', 'Saint Lucian', 'Salvadoran', 'Samoan',
    'San Marinese', 'Sao Tomean', 'Saudi', 'Scottish', 'Senegalese', 'Serbian',
    'Seychellois', 'Sierra Leonean', 'Singaporean', 'Slovak', 'Slovenian',
    'Solomon Islander', 'Somali', 'South African', 'South Korean', 'Spanish',
    'Sri Lankan', 'Sudanese', 'Surinamer', 'Swazi', 'Swedish', 'Swiss', 'Syrian',
    'Tajik', 'Tanzanian', 'Thai', 'Togolese', 'Tongan', 'Trinidadian or Tobagonian',
    'Tunisian', 'Turkish', 'Turkmen', 'Tuvaluan', 'Ugandan', 'Ukrainian',
    'Uruguayan', 'Uzbekistani', 'Venezuelan', 'Vietnamese', 'Welsh', 'Yemenite',
    'Zambian', 'Zimbabwean'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
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
                    child: Text('Step In Electronics Limited (S7 1FD)', softWrap: true),
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 8),

              Text("Tell us about your nationality",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                'In this section you need to tell us about your nationality and prove you have a legal right to rent a property.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 20),

              Text('Please select your nationality *',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedNationality,
                hint: Text('Select your nationality'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedNationality = newValue;
                  });
                },
                items: nationalities.map((value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                validator: (value) => value == null ? 'Please select your nationality' : null,
              ),

              SizedBox(height: 10),
              Divider(),

              Text('Please upload one of the documents listed below *',
                  style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold)),
              Divider(),
              SizedBox(height: 5),

              Text('Select the document type from the dropdown list *',
                  style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedDocument,
                hint: Text('-----  Please Select  -----'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDocument = newValue;
                  });
                },
                items: ['Passport', 'Driving License'].map((value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                validator: (value) => value == null ? 'Please select a document type' : null,
              ),

              SizedBox(height: 10),
              Divider(),
              Text(
                'Please upload a clear copy of your personal identification document which should clearly show your image and personal details. Your document should not be out of date. Please ensure your document is an image file and not any other format.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 10),

              Text("Upload your document *",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: fileNameController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "No file chosen",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: pickFile,
                    icon: Icon(Icons.attach_file, size: 20),
                    label: Text("Choose File"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[50],
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 5),

              if (selectedNationality != null && selectedNationality != 'British') ...[
                Text('You need to provide a right to rent share code',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(
                  'As you are a foreign national, you need to provide a share code to prove you have a legal right to rent in England and Wales. This code must be provided so your landlord complies with the law. Your share code must have been issued within the last 90 days. A share code is 9 alphanumeric digits and usually starts with an "R".',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 20),

                Text('Please provide your share code *',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter your share code',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  validator: (value) {
                    if (selectedNationality != 'British' && (value == null || value.isEmpty)) {
                      return 'Share code is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                Text('Date of Birth *',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                InkWell(
                  onTap: () => _selectDate(context, dob, (date) {
                    setState(() {
                      dob = date;
                    });
                  }),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    child: Text(
                      dob != null
                          ? DateFormat('yyyy-MM-dd').format(dob!)
                          : "Select Date",
                      style: TextStyle(color: dob != null ? Colors.black : Colors.grey[600]),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Divider(),
              ],
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pushNamed(context, '/index7');
                    }
                  },
                  child: Text('Next'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                    backgroundColor: Colors.green[800],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}