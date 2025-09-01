import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fyp/utils/constant/colors.dart';

class CrimePredictionScreen extends StatelessWidget {
  final List<dynamic> predictions;
  final String timestamp;
  final bool isError;
  final String? errorMessage;

  const CrimePredictionScreen({
    super.key,
    required this.predictions,
    required this.timestamp,
    this.isError = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Risk Analysis',
          style: GoogleFonts.lora(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body:
          isError || predictions.every((p) => p['error'] == 'Model not loaded')
          ? _buildErrorState(context)
          : _buildPredictionsView(context),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.orange[400]),
            SizedBox(height: 16),
            Text(
              'Service Unavailable',
              style: GoogleFonts.lora(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              isError
                  ? (errorMessage ?? 'Failed to fetch predictions')
                  : 'Prediction model is currently offline',
              style: GoogleFonts.lora(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Back',
                style: GoogleFonts.lora(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionsView(BuildContext context) {
    return Column(
      children: [
        // Summary text
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            _generateSummaryText(),
            style: GoogleFonts.lora(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // Header with timestamp
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.schedule, color: AppColors.primaryColor, size: 20),
              SizedBox(width: 8),
              Text(
                'Analysis completed',
                style: GoogleFonts.lora(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
              Text(
                _formatTimestamp(timestamp),
                style: GoogleFonts.lora(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        // Results list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: predictions.length,
            itemBuilder: (context, index) {
              final prediction = predictions[index];
              if (prediction['error'] != null) {
                return _buildErrorCard(index, prediction['error']);
              }
              return _buildPredictionCard(index, prediction);
            },
          ),
        ),
      ],
    );
  }

  String _generateSummaryText() {
    if (predictions.isEmpty) {
      return 'No predictions available.';
    }

    final validPredictions = predictions
        .where((p) => p['error'] == null)
        .toList();
    if (validPredictions.isEmpty) {
      return 'All predictions failed due to model issues.';
    }

    final riskCounts = {'high': 0, 'medium': 0, 'low': 0};
    validPredictions.forEach((p) {
      final riskLevel = _calculateRiskLevel(p['confidence']);
      riskCounts[riskLevel] = (riskCounts[riskLevel] ?? 0) + 1;
    });

    final topCrime = validPredictions
        .map((p) => p['predicted_crime'])
        .toList()
        .fold<Map<String, int>>({}, (acc, crime) {
          acc[crime] = (acc[crime] ?? 0) + 1;
          return acc;
        })
        .entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    return 'Analysis of ${validPredictions.length} locations shows ${riskCounts['high']} high, ${riskCounts['medium']} medium, and ${riskCounts['low']} low risk areas, with $topCrime being the most common predicted crime.';
  }

  Widget _buildErrorCard(int index, String error) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[100]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: Colors.red[400], size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Location ${index + 1}: Analysis failed',
              style: GoogleFonts.lora(fontSize: 14, color: Colors.red[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionCard(int index, Map<String, dynamic> prediction) {
    final riskLevel = _calculateRiskLevel(prediction['confidence']);
    final riskColor = _getRiskColor(riskLevel);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with location and risk level
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: riskColor.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: riskColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    _getRiskIcon(riskLevel),
                    color: riskColor,
                    size: 16,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location ${index + 1}',
                        style: GoogleFonts.lora(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '${prediction['latitude'].toStringAsFixed(4)}, ${prediction['longitude'].toStringAsFixed(4)}',
                        style: GoogleFonts.lora(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: riskColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    riskLevel.toUpperCase(),
                    style: GoogleFonts.lora(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Prediction details
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Primary prediction
                Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: AppColors.primaryColor,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Most Likely:',
                      style: GoogleFonts.lora(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        prediction['predicted_crime'],
                        style: GoogleFonts.lora(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Text(
                      '${(prediction['confidence'] * 100).toStringAsFixed(0)}%',
                      style: GoogleFonts.lora(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: riskColor,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                // Top predictions
                if (prediction['top_predictions'] != null &&
                    prediction['top_predictions'].isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Risk Breakdown:',
                        style: GoogleFonts.lora(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      ...prediction['top_predictions']
                          .take(3)
                          .map<Widget>(
                            (pred) => Padding(
                              padding: EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: _getCrimeTypeColor(
                                        pred['crime_type'],
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      pred['crime_type'],
                                      style: GoogleFonts.lora(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${(pred['probability'] * 100).toStringAsFixed(0)}%',
                                    style: GoogleFonts.lora(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp).toLocal();
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inHours < 1) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inDays < 1) {
        return '${difference.inHours}h ago';
      } else {
        return '${dateTime.day}/${dateTime.month} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      return 'Recently';
    }
  }

  String _calculateRiskLevel(double confidence) {
    if (confidence >= 0.8) return 'high';
    if (confidence >= 0.6) return 'medium';
    return 'low';
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel) {
      case 'high':
        return Colors.red[600]!;
      case 'medium':
        return Colors.orange[600]!;
      case 'low':
        return Colors.green[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  IconData _getRiskIcon(String riskLevel) {
    switch (riskLevel) {
      case 'high':
        return Icons.warning;
      case 'medium':
        return Icons.info;
      case 'low':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }

  Color _getCrimeTypeColor(String crimeType) {
    switch (crimeType.toLowerCase()) {
      case 'theft':
      case 'robbery':
        return Colors.orange[400]!;
      case 'assault':
      case 'violence':
        return Colors.red[400]!;
      case 'burglary':
        return Colors.purple[400]!;
      case 'fraud':
        return Colors.blue[400]!;
      case 'vandalism':
        return Colors.teal[400]!;
      default:
        return Colors.grey[400]!;
    }
  }
}
