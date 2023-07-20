import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/Social_cubit/cubit.dart';
import 'package:social_app/cubit/cubit_mode/cubit.dart';
import 'package:social_app/cubit/cubit_mode/state.dart';
import 'package:social_app/module/layout/social_layout.dart';

import 'package:social_app/shared/components.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/network/cache_helper.dart';


import 'firebase_options.dart';

import 'module/login/login_screen.dart';


//ahk7319@gmail.com




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var token = await FirebaseMessaging.instance.getToken();
  print(token);

  // FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  FirebaseMessaging.onMessage.listen((event)
  {
    print('on message');
    print(event.data.toString());
    showToast(text: "on message", state: ToastStates.SUCCESS);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event)
  {
    print('on Message open app');
    print(event.data.toString());
    showToast(text: "on Message open app", state: ToastStates.SUCCESS);
  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandle);
  await CacheHelper.init();
  //bool? isDark = CacheHelper.getData(key: 'isDark');
  Widget widget;
  uId = CacheHelper.getData(key: 'uId');
  if (uId != null)
    {
      widget = SocialLayout();
    }else
      {
        widget = LoginScreen();
      }
  runApp( MyApp(
    //isDark: isDark,
    startWidget: widget,
  ));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {

  bool? isDark;
  late Widget startWidget;
  MyApp({this.isDark,required this.startWidget});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context )=> AppCubit()..changeMode(fromShared: isDark,),
        ),
        BlocProvider(
            create: (BuildContext context)=> SocialCubit()..getUserData()..getPosts()..getUsers(),
        ),
      ],
      child: BlocConsumer<AppCubit,AppState>(
        listener: (context , state){},
        builder: (context , state){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primarySwatch: Colors.blue,
                scaffoldBackgroundColor: Colors.white,
                appBarTheme: const AppBarTheme(
                    systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Colors.white ,
                      statusBarBrightness: Brightness.dark,
                    ),
                    backgroundColor: Colors.white,
                    elevation: 0.0,
                    titleTextStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    iconTheme: IconThemeData(
                        color: Colors.black
                    )
                ),
                textTheme: const TextTheme(
                  bodyText1: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  subtitle1: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Colors.blue,
                  elevation: 20,
                )

            ),
            darkTheme: ThemeData(
              scaffoldBackgroundColor: Colors.black12,
              appBarTheme: const AppBarTheme(
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.black12 ,
                    statusBarBrightness: Brightness.dark,
                  ),
                  backgroundColor: Colors.black12,
                  elevation: 0.0,
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  iconTheme: IconThemeData(
                      color: Colors.white
                  )

              ),
              textTheme: const TextTheme(
                bodyText1: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                subtitle1: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Colors.deepOrange,
                  unselectedItemColor: Colors.grey,
                  elevation: 20,
                  backgroundColor: Colors.black38
              ),
            ),
            themeMode: /*AppCubit.get(context).isDark? ThemeMode.dark:*/ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}
Future<void> firebaseMessagingBackgroundHandle (RemoteMessage message) async
{
  print('on Background message');
  print(message.data.toString());

  showToast(text: "on Background message", state: ToastStates.SUCCESS);
}