import 'package:flutter/material.dart';
import 'package:fyp/services/crime_report_Service.dart';
import 'package:fyp/utils/widgets/build_textFeild.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fyp/utils/constant/colors.dart';
import 'package:fyp/utils/widgets/build_buttons.dart';
import 'package:fyp/utils/widgets/build_toast.dart';

class CrimeReportScreen extends StatefulWidget {
  const CrimeReportScreen({super.key});

  @override
  State<CrimeReportScreen> createState() => _CrimeReportScreenState();
}

class _CrimeReportScreenState extends State<CrimeReportScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;
  String apiStatus = '';

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _crimeTypeController = TextEditingController();
  final TextEditingController _crimeLocationController =
      TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _crimeDescriptionController =
      TextEditingController();

  // Test API connection
  Future<void> testApiConnection() async {
    setState(() {
      loading = true;
      apiStatus = 'Testing connection to API...';
    });

    try {
      final result = await CrimeReportService.testApiConnection();
      setState(() {
        apiStatus = result;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> submitCrimeReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
    });

    final result = await CrimeReportService.submitCrimeReport(
      userName: _userNameController.text,
      email: _emailController.text,
      crimeType: _crimeTypeController.text,
      crimeLocation: _crimeLocationController.text,
      date: _dateController.text,
      time: _timeController.text,
      crimeDescription: _crimeDescriptionController.text,
    );

    BuildToast.toastMessages(result['message']);
    if (result['success']) {
      _formKey.currentState!.reset();
      _clearControllers();
    }

    setState(() {
      loading = false;
    });
  }

  void _clearControllers() {
    _userNameController.clear();
    _emailController.clear();
    _crimeTypeController.clear();
    _crimeLocationController.clear();
    _dateController.clear();
    _timeController.clear();
    _crimeDescriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Report a Crime',
          style: GoogleFonts.lora(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // API Test Button
                ElevatedButton.icon(
                  onPressed: testApiConnection,
                  icon: Icon(Icons.wifi, color: Colors.white),
                  label: Text(
                    'Test API Connection',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),

                SizedBox(height: 16),

                // API Status Display
                if (apiStatus.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      apiStatus,
                      style: GoogleFonts.lora(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                SizedBox(height: 20),

                Text(
                  'Crime Report Form',
                  style: GoogleFonts.lora(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                BuildTextfield(
                  hintText: 'Your Name',
                  controller: _userNameController,
                  icon: Icons.person,
                  validatorType: 'name',
                ),
                const SizedBox(height: 16),
                BuildTextfield(
                  hintText: 'Your Email',
                  controller: _emailController,
                  icon: Icons.email,
                  validatorType: 'email',
                ),
                const SizedBox(height: 16),
                BuildTextfield(
                  hintText: 'Type of Crime',
                  controller: _crimeTypeController,
                  icon: Icons.warning,
                  validatorType: 'required',
                ),
                const SizedBox(height: 16),
                BuildTextfield(
                  hintText: 'Crime Location',
                  controller: _crimeLocationController,
                  icon: Icons.location_on,
                  validatorType: 'required',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: BuildTextfield(
                        hintText: 'Date (YYYY-MM-DD)',
                        controller: _dateController,
                        icon: Icons.calendar_today,
                        validatorType: 'required',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: BuildTextfield(
                        hintText: 'Time (HH:MM)',
                        controller: _timeController,
                        icon: Icons.access_time,
                        validatorType: 'required',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _crimeDescriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Describe the crime (max 20 words)',
                    hintStyle: GoogleFonts.lora(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.primaryColor,
                        width: 2,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.description,
                      color: AppColors.primaryColor,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please describe the crime';
                    }
                    final wordCount = value.split(' ').length;
                    if (wordCount > 20) {
                      return 'Description must not exceed 20 words';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                BuildContainer(
                  borderColor: Colors.transparent,
                  backgroundColor: AppColors.primaryColor,
                  textColor: Colors.white,
                  text: 'Submit Report',
                  onTap: submitCrimeReport,
                  loading: loading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
