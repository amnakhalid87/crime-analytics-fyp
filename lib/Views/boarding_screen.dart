import 'package:flutter/material.dart';
import 'package:fyp/Provider/onBoarding_provider.dart';
import 'package:fyp/Views/login_screen.dart';
import 'package:fyp/utils/constant/colors.dart';
import 'package:fyp/utils/textStrings/text_strings.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingScreen extends StatelessWidget {
  const BoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final pageProvider = Provider.of<OnboardingProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      body: PageView(
        controller: pageProvider.pageController,
        onPageChanged: (index) {
          pageProvider.updatePage();
        },
        children: List.generate(3, (index) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.08,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Animation
                  SizedBox(
                    height: screenHeight * 0.45,
                    child: Consumer<OnboardingProvider>(
                      builder: (context, provider, _) {
                        return Lottie.asset(
                          'assets/Animation${provider.currentPage + 1}.json',
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        );
                      },
                    ),
                  ),

                  // Title
                  SizedBox(height: screenHeight * 0.025),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                    ),
                    child: Consumer<OnboardingProvider>(
                      builder: (context, provider, _) {
                        return Text(
                          TextStrings.onBoardingTitles[provider.currentPage],
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  ),

                  // Subtitle
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06,
                      vertical: screenHeight * 0.035,
                    ),
                    child: Consumer<OnboardingProvider>(
                      builder: (context, provider, _) {
                        return Text(
                          TextStrings.onBoardingSubTitles[provider.currentPage],
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  ),

                  // Indicator
                  Consumer<OnboardingProvider>(
                    builder: (context, provider, _) {
                      return SmoothPageIndicator(
                        controller: provider.pageController,
                        count: 3,
                        effect: ExpandingDotsEffect(
                          expansionFactor: 4,
                          activeDotColor: AppColors.primaryColor,
                          dotColor: AppColors.secondarybtn,
                          dotHeight: 10,
                          dotWidth: 10,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: screenHeight * 0.035),

                  // Next Button
                  InkWell(
                    onTap: () {
                      if (pageProvider.currentPage < 2) {
                        pageProvider.pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.linear,
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Consumer<OnboardingProvider>(
                      builder: (context, provider, _) {
                        return Container(
                          width: double.infinity,
                          height: screenHeight * 0.065,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            provider.currentPage == 2 ? 'Get Started' : 'Next',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenHeight * 0.03,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
