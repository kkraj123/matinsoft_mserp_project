import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mserp/networkSupport/ErrorHandler.dart';
import 'package:mserp/networkSupport/base/GlobalApiResponseState.dart';
import 'package:mserp/screens/authentication_view/login_screen/model/LoginAuthModel.dart';
import 'package:mserp/screens/flutter_icons.dart';
import 'package:mserp/screens/home_screen/bloc/home_bloc.dart';
import 'package:mserp/screens/home_screen/children_items_screen.dart';
import 'package:mserp/screens/home_screen/handle_click_items.dart';
import 'package:mserp/screens/home_screen/home_repository/home_repository.dart';
import 'package:mserp/screens/home_screen/model/CategoryItemsResponse.dart';
import 'package:mserp/screens/home_screen/model/CheckInCheckOutModel.dart';
import 'package:mserp/screens/home_screen/scanner_view/ScannerScreen.dart';
import 'package:mserp/screens/view_time_sheet/TImeSheetScreen.dart';
import 'package:mserp/supports/LoadingDialog.dart';
import 'package:mserp/supports/share_preference_manager.dart';
import 'package:mserp/themes/app_cololors.dart';
import 'package:mserp/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:remixicon/remixicon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool attendanceDialog = false;

  void onAppBarButtonClick() {
    setState(() {
      if (!attendanceDialog) {
        attendanceDialog = true;
      } else {
        attendanceDialog = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<HomeRepository>(
          create: (context) => HomeRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc(homeRepository: HomeRepository()),
          ),
        ],
        child: HomeView(attendanceDialog: attendanceDialog),
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  bool attendanceDialog;

  HomeView({super.key, this.attendanceDialog = false});

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  late Timer _timer;
  String _currentTime = "";
  String _currentDate = "";
  LoginAuthModel? oAuth;
  String _checkInOutText = "in";

  List<ModulesList> categoryListItems = [];

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
    authTokenPrint();
    SharedPreferenceManager.getCheckInCheckOut().then((value) {
      if (value == null) {
        SharedPreferenceManager.setCheckInCheckOut("in");
        setState(() {
          _checkInOutText = value ?? "in";
        });
      }
    });
    context.read<HomeBloc>().add(CategoryFetch());
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime = _formatTime(now);
      _currentDate = _formatDate(now);
    });
  }

  String _formatDate(DateTime time) {
    return DateFormat('EEEE, MMMM d, yyyy').format(time);
  }

  String _formatTime(DateTime time) {
    int hour = time.hour;
    String amPm = hour >= 12 ? "PM" : "AM";
    hour = hour % 12 == 0 ? 12 : hour % 12; // convert 24h → 12h
    String minute = time.minute.toString().padLeft(2, '0');
    String second = time.second.toString().padLeft(2, '0');
    return "$hour:$minute:$second $amPm";
  }


  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkPrimaryColor
          : AppColors.colorWhite,
      body: BlocListener<HomeBloc, GlobalApiResponseState>(
        listener: (context, state) {
          switch(state.status){
            case GlobalApiStatus.loading:
              LoadingDialog.show(context, key: const ObjectKey("Check In Check Out......"));
              break;
            case GlobalApiStatus.completed:
              LoadingDialog.hide(context);
              if(state is CheckInCheckOutSuccessState){
                CheckInCheckOutModel ckInCkOutModel = state.data;
                String newType;
                if(ckInCkOutModel.message.contains("Check out successful")){
                  SharedPreferenceManager.setCheckInCheckOut("in");
                  newType = "in";
                }else{
                  SharedPreferenceManager.setCheckInCheckOut("out");
                  newType = "out";
                }
                SharedPreferenceManager.setCheckInCheckOut(newType);
                setState(() {
                  _checkInOutText = newType;
                });
              }
              else if(state is CategoryFetchSuccess){
                setState(() {
                  categoryListItems = state.data.modules;
                });
                print("category item fetch successfully :${state.data.modules.length}");
              }
              break;
            case GlobalApiStatus.error:
              LoadingDialog.hide(context);
              String newType;
              if(state.message.contains("Already checked in today")){
                SharedPreferenceManager.setCheckInCheckOut("out");
                newType = 'out';
              }else{
                SharedPreferenceManager.setCheckInCheckOut("in");
                newType = 'in';
              }
              SharedPreferenceManager.setCheckInCheckOut(newType);
              setState(() {
                _checkInOutText = newType;
              });
              ErrorHandler.errorHandle(state.message, "Something Wrong", context);
              break;
            default:
              LoadingDialog.hide(context);

          }
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: SingleChildScrollView(
            reverse: false,
            child: Column(
              children: [
                const SizedBox(height: 10),
                if (widget.attendanceDialog)
                  Container(
                    height: 380,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkPrimaryLightColor
                          : Theme.of(context).primaryColor.withAlpha(40),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: attendanceView(isDark),
                  ),
                 categoryListItemsView(categoryListItems, isDark),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget attendanceView(isDark) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            _currentDate,
            style: TextStyle(
              color: isDark ? AppColors.colorWhite : AppColors.colorBlack,
            ),
            textScaler: const TextScaler.linear(1.2),
          ),
          const SizedBox(height: 30),
          InkWell(
            onTap: () async {
              final scannedValue = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ScannerScreen()),
              );

              if (scannedValue != null) {
                String? type = await SharedPreferenceManager.getCheckInCheckOut();
                print("Retrieved type before scanning: $type");
                // type ??= "in";
                // print("🔹 Final type being sent: $type");

                context.read<HomeBloc>().add(
                  CheckInCheckOutPost(
                    bssid: "Matinsoftech",
                    code: scannedValue,
                    type: type ??= '',
                  ),
                );
                print("Scanned value: $scannedValue");
              }
            },
            child: Image.asset("assets/icons/scanner.png", width: 100),
          ),
          const SizedBox(height: 20),
          Text(
            "Scan Here",
            style: TextStyle(
              color: isDark ? AppColors.colorWhite : AppColors.colorBlack,
            ),
            textScaler: const TextScaler.linear(1.2),
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "You are currently",
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? AppColors.colorWhite : AppColors.colorBlack,
                ),
                textScaler: const TextScaler.linear(1),
              ),
              Text(
                " checked $_checkInOutText",
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? AppColors.colorWhite : _checkInOutText.contains("out") ? Colors.red : Colors.green,
                ),
                textScaler: const TextScaler.linear(1),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>const TimeSheetScreen()));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkPrimaryLightColor : Theme.of(context).primaryColor.withAlpha(40),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.colorGray.withAlpha(40), width: 1),
                ),
                child:Align(alignment: Alignment.center,child: Text("View Timesheet", textScaler:const TextScaler.linear(1), style: TextStyle(color: isDark ? AppColors.colorWhite : AppColors.colorBlack),))
                ,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void authTokenPrint() async {
    oAuth = await SharedPreferenceManager.getOAuth();
    print("authToken : ${oAuth!.token}");
  }

 Widget categoryListItemsView(List<ModulesList> categoryListItems, bool isDark) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        childAspectRatio: 1.4,
      ),
      itemCount: categoryListItems.length,
      itemBuilder: (context, index) {
        final item = categoryListItems[index];
        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: (){
            _handleCategoryItemTap(item, context);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: SizedBox(
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // Text container (fixed width for uniformity)
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    // shift right so circle overlaps
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      // takes full grid cell width
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkPrimaryLightColor
                            : Theme.of(
                          context,
                        ).primaryColor.withAlpha(60),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.only(
                        left: 50,
                        right: 12,
                      ),
                      // space for circle + text
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${item.name}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textScaler: const TextScaler.linear(1),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.colorWhite
                                  : AppColors.colorBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Circle avatar
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: isDark ? AppColors.colorWhite : Theme.of(context).primaryColor,
                    child: Icon(
                      getFlutterIcon(item.icon),
                      size: 32,
                      color: isDark ? AppColors.colorBlack : AppColors.colorWhite,
                    ),
                  )

                ],
              ),
            ),
          ),
        );
      },
    );
 }
  void _handleCategoryItemTap(ModulesList item, BuildContext context) {
    if (item.children != null && item.children!.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChildrenItemsScreen(
            parentName: item.name ?? "Items",
            children: item.children!,
          ),
        ),
      );
    } else {
      clickParentItem(item, context);
    }
  }


}

class HomeItems {
  final String title;
  final String subtitle;
  final String image;

  HomeItems({required this.title, required this.subtitle, required this.image});
}
