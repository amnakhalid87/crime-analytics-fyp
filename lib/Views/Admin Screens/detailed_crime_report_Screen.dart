import 'package:flutter/material.dart';
import 'package:fyp/services/crime_report_Service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fyp/utils/constant/colors.dart';
import 'package:fyp/utils/widgets/build_toast.dart';

class DetailedCrimeReportScreen extends StatefulWidget {
  const DetailedCrimeReportScreen({super.key});

  @override
  State<DetailedCrimeReportScreen> createState() =>
      _DetailedCrimeReportScreenState();
}

class _DetailedCrimeReportScreenState extends State<DetailedCrimeReportScreen> {
  List<dynamic> crimeReports = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final reports = await CrimeReportService.getCrimeReports();
      setState(() {
        crimeReports = reports;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceFirst('Exception: ', '');
        isLoading = false;
      });
      BuildToast.toastMessages('Error loading crime reports: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.report, color: Colors.white, size: 28),
            const SizedBox(width: 10),
            Text(
              'Crime Reports',
              style: GoogleFonts.lora(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 2,
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Reported Incidents',
                  style: GoogleFonts.lora(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                _buildCrimeReportsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCrimeReportsSection() {
    if (isLoading) {
      return Container(
        height: 120,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          ),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red[100]!, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red[400], size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Failed to load reports',
                    style: GoogleFonts.lora(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.red[800],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              errorMessage,
              style: GoogleFonts.lora(fontSize: 12, color: Colors.red[600]),
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _fetchData,
                child: Text(
                  'Retry',
                  style: TextStyle(color: AppColors.primaryColor),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (crimeReports.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.assignment_outlined, size: 48, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'No reports yet',
              style: GoogleFonts.lora(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'No incidents have been reported yet.',
              style: GoogleFonts.lora(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: crimeReports.length,
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final report = crimeReports[index];
            return _buildReportCard(report);
          },
        ),
        SizedBox(height: 16),
        Divider(),
        SizedBox(height: 8),
        Text(
          'Showing ${crimeReports.length} report(s)',
          style: GoogleFonts.lora(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    report['crimeType']?.toString().toUpperCase() ??
                        'UNKNOWN CRIME',
                    style: GoogleFonts.lora(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    report['date'] ?? 'N/A',
                    style: GoogleFonts.lora(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    report['crimeLocation'] ?? 'Location not specified',
                    style: GoogleFonts.lora(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                SizedBox(width: 6),
                Text(
                  report['time'] ?? 'Time not specified',
                  style: GoogleFonts.lora(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              report['crimeDescription'] ?? 'No description provided',
              style: GoogleFonts.lora(fontSize: 14, color: Colors.grey[800]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 12),
            Divider(height: 1, color: Colors.grey[200]),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reported by: ${report['userName'] ?? 'Anonymous'}',
                  style: GoogleFonts.lora(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'ID: #${report['id']?.toString() ?? 'N/A'}',
                  style: GoogleFonts.lora(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
