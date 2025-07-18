import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:tenancy_guarantor/screens/address_forms.dart';
import 'package:tenancy_guarantor/extra/adresses_form.dart';
import 'package:tenancy_guarantor/screens/income_form.dart';
import 'package:tenancy_guarantor/screens/kin_ship_form.dart';
import 'package:tenancy_guarantor/screens/profile_details.dart';
import 'package:tenancy_guarantor/screens/referencing_screen.dart';
import 'package:tenancy_guarantor/screens/right_to_rent.dart';
import 'package:tenancy_guarantor/screens/signature_form.dart';
import 'package:tenancy_guarantor/screens/stripe_payment.dart';

import '../consts.dart';

void main() async {
  await _setup();
  runApp(TenancyGuarantorApp());
}

Future<void> _setup() async{
   WidgetsFlutterBinding.ensureInitialized();
   Stripe.publishableKey = stripePublishableKey;
}

class TenancyGuarantorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TenancyStepperScreen(),
    );
  }
}

class TenancyStepperScreen extends StatefulWidget {
  @override
  _TenancyStepperScreenState createState() => _TenancyStepperScreenState();
}

class _TenancyStepperScreenState extends State<TenancyStepperScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;
  late final List<StepItem> _steps;

  @override
  void initState() {
    super.initState();
    _steps = [
      StepItem(
        selectedImagePath: 'assets/tab_icons/Checklist_active.png',
        unselectedImagePath: 'assets/tab_icons/Checklist.png',
        title: 'Check List',
        page: ReferenceApplicationScreen(onStepTapped: _onStepTapped),
      ),
      StepItem(
        selectedImagePath: 'assets/tab_icons/payment.png',
        unselectedImagePath: 'assets/tab_icons/payment_active.png',
        title: 'Payment',
        page: StripePaymentScreen(),
      ),
      StepItem(
        selectedImagePath: 'assets/tab_icons/basic_info_active.png',
        unselectedImagePath: 'assets/tab_icons/basic_info.png',
        title: 'Profile',
        page: RentalApplicationForm(),
      ),
      StepItem(
        selectedImagePath: 'assets/tab_icons/next_to_kin_active.png',
        unselectedImagePath: 'assets/tab_icons/next_to_kin.png',
        title: 'Next of Kin',
        page: NextOfKinForm(),
      ),
      StepItem(
        selectedImagePath: 'assets/tab_icons/address_detail_active.png',
        unselectedImagePath: 'assets/tab_icons/address_detail.png',
        title: 'Address',
        page: AddressHistoryFormPage(),
      ),
      StepItem(
        selectedImagePath: 'assets/tab_icons/income_active.png',
        unselectedImagePath: 'assets/tab_icons/income.png',
        title: 'Income',
        page: IncomeFormScreen(onChanged: (String ) {  },),
      ),
      StepItem(
        selectedImagePath: 'assets/tab_icons/right_to_rent_active.png',
        unselectedImagePath: 'assets/tab_icons/right_to_rent.png',
        title: 'Right to Rent',
        page: NationalityForm(),
      ),
      StepItem(
        selectedImagePath: 'assets/tab_icons/sign_active.png',
        unselectedImagePath: 'assets/tab_icons/sign.png',
        title: 'Signature',
        page: PropertyRentalForm(),
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onStepTapped(int index) {
    if (_currentStep != index) {
      setState(() => _currentStep = index);
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }



  void _onPageChanged(int index) {
    setState(() => _currentStep = index);
  }

  Widget _buildStepper() {
    return Container(
       padding: EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: _steps.asMap().entries.expand((entry) {
              final index = entry.key;
              final step = entry.value;
              final isCurrent = index == _currentStep;
              final isCompleted = index < _currentStep;

              // Step circle and label
              final stepWidget = GestureDetector(
                onTap: () => _onStepTapped(index),
                child: Tooltip(
                  message: step.title,
                  child: Container(
                    width: 90, // Fixed width for all steps
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCurrent
                                ? Colors.orange.shade100
                                : isCompleted
                                ? Colors.orange.shade50
                                : Colors.white,
                            border: Border.all(
                              color: isCurrent || isCompleted
                                  ? Colors.orangeAccent
                                  : Colors.grey,
                              width: 3,
                            ),
                          ),
                          child: Image.asset(
                            isCurrent || isCompleted
                                ? step.selectedImagePath
                                : step.unselectedImagePath,
                            width: 24,
                            height: 24,
                          ),
                        ),
                        SizedBox(height: 4),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 80),
                          child: Text(
                            step.title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                              color: isCurrent || isCompleted
                                  ? Colors.orange.shade400
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );

              // Add divider except after last step
              if (index == _steps.length - 1) {
                return [stepWidget];
              }

              return [
                stepWidget,
                Container(
                  width: 30,
                  height: 2,
                  color: isCompleted ? Colors.orangeAccent : Colors.grey[300],
                ),
              ];
            }).toList(),
          ),
        ),
      ),
    );
  }



  Future<bool> _onWillPop() async {
    if (_currentStep == 0) return true;

    setState(() => _currentStep--);
    _pageController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(65),
          child: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Image.asset(
              'assets/logo/TG.png',
              width: 190,
            ),
          ),
        ),

        body: Column(
          children: [
            _buildStepper(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: (_isLoading || _currentStep == _steps.length - 1)
                    ? NeverScrollableScrollPhysics()
                    : ClampingScrollPhysics(),
                itemCount: _steps.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) => _steps[index].page,
              ),
            ),
            if (_isLoading)
              LinearProgressIndicator(
                backgroundColor: Colors.purple.shade100,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
              ),
          ],
        ),
      ),
    );
  }
}

class StepItem {
  final String selectedImagePath;
  final String unselectedImagePath;
  final String title;
  final Widget page;

  StepItem({
    required this.selectedImagePath,
    required this.unselectedImagePath,
    required this.title,
    required this.page,
  });
}