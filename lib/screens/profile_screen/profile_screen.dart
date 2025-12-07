import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mserp/customeDesigns/custom_toolbar.dart';
import 'package:mserp/networkSupport/base/GlobalApiResponseState.dart';
import 'package:mserp/screens/profile_screen/bloc/profile_bloc.dart';
import 'package:mserp/screens/profile_screen/profile_repo/profile_repository.dart';
import 'package:mserp/themes/app_cololors.dart';
import 'package:mserp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProfileRepository>(
          create: (context) => ProfileRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                ProfileBloc(profileRepository: ProfileRepository()),
          ),
        ],
        child: const ProfileView(),
      ),
    );
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    context.read<ProfileBloc>().add(GetProfile());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkPrimaryColor
          : AppColors.colorWhite,
      appBar: const CustomToolbar(title: "Profile"),
      body: BlocBuilder<ProfileBloc, GlobalApiResponseState>(
        builder: (context, state) {
          if (state.status == GlobalApiStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == GlobalApiStatus.error) {
            return Center(child: Text(state.message));
          }

          if (state.status == GlobalApiStatus.completed) {
            if (state is ProfileStateSuccess) {
              final profile = state.data.data!;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    _header(profile, isDark),
                    const SizedBox(height: 16),
                    _infoCard(profile, isDark),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }
          }

          return const SizedBox();
        },
      ),
    );
  }

  /// HEADER WITH GRADIENT + AVATAR
  Widget _header(profile, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18, top: 18),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkPrimaryLightColor
              : AppColors.colorWhite,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.only(top: 40, bottom: 20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 45,
              child: profile.pic == null
                  ? const Icon(Icons.person, size: 50, color: Colors.white)
                  : ClipOval(
                      child: Image.network(profile.pic, fit: BoxFit.cover),
                    ),
            ),
            const SizedBox(height: 10),
            Text(
              profile.name ?? "No Name",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Theme.of(context).primaryColor,
              ),
            ),
            Text(
              profile.userType?.toUpperCase() ?? "",
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  /// INFO CARD
  Widget _infoCard(profile, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkPrimaryLightColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        children: [
          _tile("Email", profile.email, Icons.email, isDark),
          _tile("Phone", profile.phone ?? "Not Available", Icons.phone, isDark),
          _tile("User Type", profile.userType ?? "-", Icons.badge, isDark),
          _tile(
            "Balance",
            "Rs. ${profile.balance}",
            Icons.account_balance,
            isDark,
          ),
          _tile(
            "Active",
            profile.isActive == true ? "Yes" : "No",
            Icons.verified_user,
            isDark,
          ),
          _tile(
            "Created At",
            profile.createdAt?.toString() ?? "-",
            Icons.date_range,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _tile(String title, String value, IconData icon, bool isDark) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: isDark
                ? AppColors.colorWhite
                : Theme.of(context).primaryColor,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.colorWhite : AppColors.colorBlack,
            ),
          ),
          subtitle: Text(value),
        ),
        Divider(color: Colors.grey.shade300),
      ],
    );
  }
}
