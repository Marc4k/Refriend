import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:refriend/cubit/groupList_cubit.dart';
import 'package:refriend/cubit/homeLoading_cubit.dart';
import 'package:refriend/cubit/profilPicture_cubit.dart.dart';
import 'package:refriend/models/user.dart';
import 'package:refriend/screens/SignUpIn/welcomeScreen.dart';
import 'package:refriend/screens/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //get a Stream of the user
    final user = Provider.of<MyUser>(context);
    //return either Home or GetStartet Screen

    if (user == null) {
      return WelcomeScreen();
    } else {
      //user
      return MultiBlocProvider(providers: [
        BlocProvider<GroupDataCubit>(
          create: (BuildContext context) => GroupDataCubit()..getYourGroups(),
        ),
      ], child: Homescreen());
    }
  }
}
