class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Welcome to MSERP",
    image: "assets/icons/onboarding1.png",
    desc: "Automate and simplify operations",
  ),
  OnboardingContents(
    title: "Team Collaboration",
    image: "assets/icons/onboarding2.png",
    desc: "Connect users across roles",
  ),
  OnboardingContents(
    title: "Growth Insights",
    image: "assets/icons/onboarding3.png",
    desc: "track performance with analytics",
  ),
];
