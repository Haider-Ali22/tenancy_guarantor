import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RentalApplicationForm extends StatefulWidget {
  @override
  _RentalApplicationFormState createState() => _RentalApplicationFormState();
}

class _RentalApplicationFormState extends State<RentalApplicationForm> {
  final _formKey = GlobalKey<FormState>();

  String? title;
  String firstName = '';
  String middleName = '';
  String lastName = '';
  bool hasAlias = false;
  String previousNames = '';
  String relationshipStatus = '';
  String mobileNumber = '';
  String email = '';
  String confirmEmail = '';
  DateTime? dob;

  bool hasAdverseCredit = false;

  bool hasCCJs = false;
  int ccjCount = 0;
  double ccjTotalValue = 0.0;
  DateTime? ccjLastDate;

  bool isBankrupt = false;
  DateTime? bankruptcyDate;

  bool hasIVA = false;
  DateTime? ivaDate;
  double ivaTotalValue = 0.0;

  final List<String> relationshipOptions = [
    'Single',
    'Married',
    'Divorced',
    'Widowed',
    'Cohabiting',
    'Other'
  ];

  TextEditingController _ccjAmountController = TextEditingController();
  bool _hasText = false;

  TextEditingController _ivaAmountController = TextEditingController();
  bool _ivaHasText = false;



  @override
  void initState() {
    super.initState();
    _ccjAmountController.addListener(() {
      setState(() {
        _hasText = _ccjAmountController.text.isNotEmpty;
      });
    });

    _ivaAmountController.addListener(() {
      setState(() {
        _ivaHasText = _ivaAmountController.text.isNotEmpty;
      });
    });
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
                "Tell us about you:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Please answer all questions honestly and accurately to avoid any delays or negative results with your reference.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),


              SizedBox(height: 10),
            // Title Field - Label above Dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Please Select Your Title *",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: title,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        title = value!;
                      });
                    },
                    hint: Text("Select"),
                    items: ["Mr", "Mrs", "Miss", "Ms", "Dr", "Other"].map((t) {
                      return DropdownMenuItem(
                        value: t,
                        child: Text(t),
                      );
                    }).toList(),
                  ),
                ],
              ),

              SizedBox(height: 10),
              // First Name - Label above TextFormField
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What is your first name? *',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8), // spacing between label and field
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "First Name",
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Required";
                      return null;
                    },
                    onSaved: (value) {
                      firstName = value!;
                    },
                  ),
                ],
              ),

              SizedBox(height: 10),

              // Middle Name - Label above field with hint
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What is your middle name?  (if any)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Middle Name",
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onSaved: (value) {
                      middleName = value ?? '';
                    },
                  ),
                ],
              ),

              SizedBox(height: 10),

              // Last Name - Label above required field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What is your last name? *',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Last Name",
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Required";
                      return null;
                    },
                    onSaved: (value) {
                      lastName = value!;
                    },
                  ),
                ],
              ),

              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 5),

              // Other Names
              // Known by other names - with divider shown only when 'No' is selected
              // Other Names or Aliases - Row layout with conditional divider
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Are you known, or have you ever been known, by any other names or aliases? *",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // YES
                          Flexible(
                            child: IntrinsicWidth(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: hasAlias == true ? Colors.green : Colors.grey,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Row(
                                  children: [
                                    Radio<bool>(
                                      value: true,
                                      groupValue: hasAlias,
                                      onChanged: (value) {
                                        setState(() {
                                          hasAlias = value!;
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

                          // Divider line
                          Container(
                            height: 28,
                            width: 1,
                            color: Colors.grey[400],
                          ),

                          SizedBox(width: 8),

                          // NO
                          Flexible(
                            child: IntrinsicWidth(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: hasAlias == false ? Colors.red : Colors.grey,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Row(
                                  children: [
                                    Radio<bool>(
                                      value: false,
                                      groupValue: hasAlias,
                                      onChanged: (value) {
                                        setState(() {
                                          hasAlias = value!;
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

                    ],
                  ),


                  // ✅ Divider should appear regardless of Yes/No selection
                  if (hasAlias != null) ...[
                    SizedBox(height: 5),
                    Divider(),
                    SizedBox(height: 5),
                  ],

                  // ✅ Show input field + another divider only if "Yes" selected
                  if (hasAlias == true)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          'Maiden Name or other names *',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Other Name",
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                          validator: (value) {
                            if (hasAlias && (value == null || value.isEmpty)) return "Required";
                            return null;
                          },
                          onSaved: (value) {
                            previousNames = value!;
                          },
                        ),
                        SizedBox(height: 10),
                        Divider(),
                        SizedBox(height: 10),
                      ],
                    ),
                ],
              ),


              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "What is Your Relationship Status *",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: relationshipStatus.isEmpty ? null : relationshipStatus,
                    items: relationshipOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        relationshipStatus = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Select",
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),


              Column(
                children: [
                  // Mobile Number
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Provide Your Mobile Number *",
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
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Required";
                          return null;
                        },
                        onSaved: (value) {
                          mobileNumber = value!;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Personal Email
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Provide Your Email Address *",
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
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Required";
                          return null;
                        },
                        onSaved: (value) {
                          email = value!;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Confirm Email
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Please Confirm Your Email *",
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
                        validator: (value) {
                          if (value != email) return "Emails do not match";
                          return null;
                        },
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 10),

              // Date of Birth - Label above custom date picker
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Provide Your Date of Birth *",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDate(context, dob, (date) {
                      setState(() {
                        dob = date;
                      });
                    }),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      child: Text(
                        dob != null ? DateFormat('yyyy-MM-dd').format(dob!) : "Select Date",
                        style: TextStyle(
                          color: dob != null ? Colors.black : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 5),

              // Adverse Credit
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Have you had any adverse credit in the past 6 years?",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // YES Option
                      Flexible(
                        child: IntrinsicWidth(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: hasAdverseCredit == true ? Colors.green : Colors.grey,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Row(
                              children: [
                                Radio<bool>(
                                  value: true,
                                  groupValue: hasAdverseCredit,
                                  onChanged: (value) {
                                    setState(() {
                                      hasAdverseCredit = value!;
                                    });
                                  },
                                  fillColor: MaterialStateProperty.resolveWith<Color>(
                                        (states) => states.contains(MaterialState.selected)
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

                      // Divider line
                      Container(
                        height: 28,
                        width: 1,
                        color: Colors.grey[400],
                      ),

                      SizedBox(width: 8),

                      // NO Option
                      Flexible(
                        child: IntrinsicWidth(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: hasAdverseCredit == false ? Colors.red : Colors.grey,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Row(
                              children: [
                                Radio<bool>(
                                  value: false,
                                  groupValue: hasAdverseCredit,
                                  onChanged: (value) {
                                    setState(() {
                                      hasAdverseCredit = value!;
                                    });
                                  },
                                  fillColor: MaterialStateProperty.resolveWith<Color>(
                                        (states) => states.contains(MaterialState.selected)
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
                ],
              ),


// Only show divider if "No" is selected
              if (hasAdverseCredit == false) ...[
                SizedBox(height: 5),
                Divider(),
                SizedBox(height: 5),
              ],

// Show this section only if "Yes" is selected
              if (hasAdverseCredit == true) ...[
                SizedBox(height: 10),
                Text(
                  "Please complete this section if any of the following have occurred within the last 6 years.",
                  style: TextStyle(
                    color: Color(0xff888888),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 5),
                Divider(),
                SizedBox(height: 5),




              // CCJ or Decree
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Have you received any CCJs or Decrees?",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // YES Option
                        Flexible(
                          child: IntrinsicWidth(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: hasCCJs == true ? Colors.green : Colors.grey,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Row(
                                children: [
                                  Radio<bool>(
                                    value: true,
                                    groupValue: hasCCJs,
                                    onChanged: (value) {
                                      setState(() {
                                        hasCCJs = value!;
                                      });
                                    },
                                    fillColor: MaterialStateProperty.resolveWith<Color>(
                                          (states) => states.contains(MaterialState.selected)
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

                        // Divider line
                        Container(
                          height: 28,
                          width: 1,
                          color: Colors.grey[400],
                        ),

                        SizedBox(width: 8),

                        // NO Option
                        Flexible(
                          child: IntrinsicWidth(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: hasCCJs == false ? Colors.red : Colors.grey,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Row(
                                children: [
                                  Radio<bool>(
                                    value: false,
                                    groupValue: hasCCJs,
                                    onChanged: (value) {
                                      setState(() {
                                        hasCCJs = value!;
                                      });
                                    },
                                    fillColor: MaterialStateProperty.resolveWith<Color>(
                                          (states) => states.contains(MaterialState.selected)
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
                  ],
                ),


                SizedBox(height: 5),
                Divider(),
                SizedBox(height: 5),


                if (hasCCJs) ...[
                  // Number of CCJ's or Decrees - Label above field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Number of CCJ's or Decrees *",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Number of CCJ's or Decrees",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty ? "Required" : null,
                        onSaved: (value) => ccjCount = int.tryParse(value!) ?? 0,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Value of CCJs or Decrees *",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _ccjAmountController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          hintText: _hasText ? null : "Amount",
                          prefixText: _hasText ? "£ " : null,
                          prefixStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                        value == null || value.isEmpty ? "Required" : null,
                        onSaved: (value) =>
                        ccjTotalValue = double.tryParse(value!) ?? 0.0,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date of recent CCJ or Decree *",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      InkWell(
                        onTap: () => _selectDate(context, ccjLastDate, (date) {
                          setState(() => ccjLastDate = date);
                        }),
                        child: InputDecorator(
                          decoration: InputDecoration(border: OutlineInputBorder()),
                          child: Text(
                            ccjLastDate != null
                                ? DateFormat('yyyy-MM-dd').format(ccjLastDate!)
                                : "Select Date",
                            style: TextStyle(
                              color: ccjLastDate != null ? Colors.black : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),

                      if (hasCCJs) ...[
                        SizedBox(height: 10),
                        Divider(),
                        SizedBox(height: 5),
                      ],
                    ],
                  ),
                ],

                  // Bankruptcy

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Have you been declared bankrupt or sequestrated?",
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
                                  color: isBankrupt == true ? Colors.green : Colors.grey,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Row(
                                children: [
                                  Radio<bool>(
                                    value: true,
                                    groupValue: isBankrupt,
                                    onChanged: (value) {
                                      setState(() {
                                        isBankrupt = value!;
                                      });
                                    },
                                    fillColor: MaterialStateProperty.resolveWith<Color>(
                                          (states) => states.contains(MaterialState.selected)
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

                        // Divider line
                        Container(
                          height: 28,
                          width: 1,
                          color: Colors.grey[400],
                        ),

                        SizedBox(width: 8),

                        // NO option
                        Flexible(
                          child: IntrinsicWidth(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isBankrupt == false ? Colors.red : Colors.grey,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Row(
                                children: [
                                  Radio<bool>(
                                    value: false,
                                    groupValue: isBankrupt,
                                    onChanged: (value) {
                                      setState(() {
                                        isBankrupt = value!;
                                      });
                                    },
                                    fillColor: MaterialStateProperty.resolveWith<Color>(
                                          (states) => states.contains(MaterialState.selected)
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
                    SizedBox(height: 5),
                    Divider(),
                    SizedBox(height: 5),
                  ],
                ),


                // Conditional date picker if user selects "Yes"
                if (isBankrupt)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date of Bankruptcy or Sequestration *",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      InkWell(
                        onTap: () => _selectDate(context, bankruptcyDate, (date) {
                          setState(() => bankruptcyDate = date);
                        }),
                        child: InputDecorator(
                          decoration: InputDecoration(border: OutlineInputBorder()),
                          child: Text(
                            bankruptcyDate != null
                                ? DateFormat('yyyy-MM-dd').format(bankruptcyDate!)
                                : "Select Date",
                            style: TextStyle(
                              color: bankruptcyDate != null ? Colors.black : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(),
                      SizedBox(height: 5),
                    ],
                  ),

                // IVA / Trust Deeds
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Have you entered into any IVA's / Trust Deeds? *",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // YES Option
                        Flexible(
                          child: IntrinsicWidth(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: hasIVA == true ? Colors.green : Colors.grey,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Row(
                                children: [
                                  Radio<bool>(
                                    value: true,
                                    groupValue: hasIVA,
                                    onChanged: (value) {
                                      setState(() {
                                        hasIVA = value!;
                                      });
                                    },
                                    fillColor: MaterialStateProperty.resolveWith<Color>(
                                          (states) => states.contains(MaterialState.selected)
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

                        // Divider line
                        Container(
                          height: 28,
                          width: 1,
                          color: Colors.grey[400],
                        ),

                        SizedBox(width: 8),

                        // NO Option
                        Flexible(
                          child: IntrinsicWidth(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: hasIVA == false ? Colors.red : Colors.grey,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Row(
                                children: [
                                  Radio<bool>(
                                    value: false,
                                    groupValue: hasIVA,
                                    onChanged: (value) {
                                      setState(() {
                                        hasIVA = value!;
                                      });
                                    },
                                    fillColor: MaterialStateProperty.resolveWith<Color>(
                                          (states) => states.contains(MaterialState.selected)
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
                  ],
                ),


                SizedBox(height: 5),
                Divider(),
                SizedBox(height: 5),


                if (hasIVA) ...[

                  // IVA / Trust Deed Date - Label above date selector
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date entered into IVA / Trust Deed *",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      InkWell(
                        onTap: () => _selectDate(context, ivaDate, (date) {
                          setState(() => ivaDate = date);
                        }),
                        child: InputDecorator(
                          decoration: InputDecoration(border: OutlineInputBorder()),
                          child: Text(
                            ivaDate != null
                                ? DateFormat('yyyy-MM-dd').format(ivaDate!)
                                : "Select Date",
                            style: TextStyle(
                              color: ivaDate != null ? Colors.black : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Total Value of IVA / Trust Deed - Label above field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total value of the IVA / Trust Deed *",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _ivaAmountController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          hintText: _ivaHasText ? null : "Amount",
                          prefixText: _ivaHasText ? "£ " : null,
                          prefixStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                        value == null || value.isEmpty ? "Required" : null,
                        onSaved: (value) =>
                        ivaTotalValue = double.tryParse(value!) ?? 0.0,
                      ),
                      SizedBox(height: 10),
                      Divider(),
                      SizedBox(height: 10),
                    ],
                  ),
                ],
              ],

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Handle form submission
                        print("Form Submitted");
                      }
                    },
                    label: Text("Save & Continue"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: Colors.black45,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}