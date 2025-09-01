import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fyp/Views/map_screen.dart';
import 'package:fyp/Views/chicago_laws_Screen.dart';
import 'package:fyp/Views/crime_report_Screen.dart';
import 'package:fyp/Views/safety_tips_Screen.dart';
import 'package:fyp/services/crime_report_Service.dart';
import 'package:fyp/utils/constant/colors.dart';
import 'package:fyp/utils/widgets/build_toast.dart';
import 'package:fyp/utils/widgets/home_screen_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> imgList = [
    'assets/img1.png',
    'assets/img2.png',
    'assets/img3.png',
  ];
  int activeIndex = 0;
  final CarouselSliderController controller = CarouselSliderController();

  // For crime reports
  List<dynamic> crimeReports = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // In your _fetchData() method in HomeScreen.dart
  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final reports = await CrimeReportService.getCrimeReports();

      setState(() {
        crimeReports = reports;
        // Handle the new response format
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
      BuildToast.toastMessages('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.security, color: Colors.white, size: 28),
            const SizedBox(width: 10),
            Text(
              'Crime Analytics',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Keep the community safest................!",
                style: GoogleFonts.lora(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 14),
              CarouselSlider.builder(
                carouselController: controller,
                itemCount: imgList.length,
                itemBuilder: (context, index, realIndex) {
                  final image = imgList[index];
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 122, 145, 115),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        image,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: Center(
                              child: Icon(Icons.image_not_supported, size: 50),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 200,
                  viewportFraction: 1,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  onPageChanged: (index, reason) {
                    setState(() {
                      activeIndex = index;
                    });
                  },
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  "Quick Actions",
                  style: GoogleFonts.lora(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CrimeReportScreen(),
                        ),
                      );
                    },
                    child: buildActionButton(
                      icon: Icons.report,
                      color: Colors.red[400]!,
                      label: "Report",
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapScreen()),
                      );
                    },
                    child: buildActionButton(
                      icon: Icons.map_outlined,
                      color: Colors.blue[400]!,
                      label: "Map",
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChicagoLawsScreen(),
                        ),
                      );
                    },
                    child: buildActionButton(
                      icon: Icons.gavel_rounded,
                      color: Colors.teal[400]!,
                      label: "Laws",
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SafetyTipsScreen(),
                        ),
                      );
                    },
                    child: buildActionButton(
                      icon: Icons.safety_check,
                      color: Colors.purple[400]!,
                      label: "Safety Tips",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                "Crime Statistics",
                style: GoogleFonts.lora(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildStatCard(
                    value: "78%",
                    color: Colors.amber[400]!,
                    label: "Theft",
                  ),
                  buildStatCard(
                    value: "62%",
                    color: Colors.orange[400]!,
                    label: "Assault",
                  ),
                  buildStatCard(
                    value: "35%",
                    color: Colors.blue[400]!,
                    label: "Burglary",
                  ),
                  buildStatCard(
                    value: "28%",
                    color: Colors.green[400]!,
                    label: "Fraud",
                  ),
                ],
              ),
              SizedBox(height: 14),
              Container(
                margin: const EdgeInsets.all(8),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.people_alt,
                          color: Colors.blue[600],
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Community Alerts",
                          style: GoogleFonts.lora(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Loading community alerts...',
                      style: GoogleFonts.lora(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Reported Incidents",
                    style: GoogleFonts.lora(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  if (crimeReports.isNotEmpty)
                    Text(
                      "Total: ${crimeReports.length}",
                      style: GoogleFonts.lora(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8),
              _buildCrimeReportsSection(),
            ],
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
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[400], size: 24),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Failed to load reports",
                    style: GoogleFonts.lora(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.red[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Please check your connection and try again",
                    style: GoogleFonts.lora(
                      fontSize: 12,
                      color: Colors.red[600],
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: _fetchData,
              child: Text(
                "Retry",
                style: TextStyle(color: AppColors.primaryColor),
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
              "No reports yet",
              style: GoogleFonts.lora(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Be the first to report an incident",
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
          "Showing ${crimeReports.length} report(s)",
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
