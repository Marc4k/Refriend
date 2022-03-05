import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:refriend/constant/colors.dart';
import 'package:refriend/constant/size.dart';
import 'package:refriend/cubit/groupEvent_cubit.dart';
import 'package:refriend/cubit/groupList_cubit.dart';
import 'package:refriend/cubit/groupMembers_cubit.dart';
import 'package:refriend/cubit/homeLoading_cubit.dart';
import 'package:refriend/database/database_group.dart';
import 'package:refriend/models/groupMembers.dart';
import 'package:refriend/screens/group_chat/groupEventChat.dart';
import 'package:refriend/screens/home.dart';
import 'package:refriend/services/group_service.dart';
import 'package:refriend/widgets/refriendCustomWidgets.dart';
import 'package:share/share.dart';

class GroupEventBigView extends StatefulWidget {
  String groupName;
  String inviteCode;
  String groupCode;
  GroupEventBigView({this.groupName, this.inviteCode, this.groupCode});

  @override
  _GroupEventBigViewState createState() => _GroupEventBigViewState();
}

GroupService _groupService = GroupService();

class _GroupEventBigViewState extends State<GroupEventBigView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor2,
      body: SafeArea(
        child: Column(
          children: [
            customWaveWithCustomText(context, widget.groupName),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.inviteCode,
                  style: GoogleFonts.righteous(
                      color: CustomColors.fontColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w400),
                ),
                IconButton(
                    onPressed: () => Share.share(
                        'Join my group on Refriend. Code: ${widget.inviteCode}'),
                    icon: Icon(
                      Icons.share,
                      color: Colors.white,
                    ))
              ],
            ),
            Text(
              "Members",
              style: GoogleFonts.publicSans(
                textStyle: TextStyle(
                  color: CustomColors.maincolor,
                  fontSize: 23,
                ),
              ),
            ),
            BlocBuilder<GroupMembersCubit, List<GroupMembers>>(
              builder: (context, members) {
                if (members.isEmpty) {
                  return SpinKitChasingDots(
                    color: Colors.white,
                    size: 35,
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            members[index].imageUrl)),
                                    SizedBox(width: 25),
                                    Text(
                                      members[index].name,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white, primary: CustomColors.custom_pink),
                onPressed: () async {
                  await GroupService().leaveGroup(widget.groupCode);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MultiBlocProvider(providers: [
                            BlocProvider<GroupDataCubit>(
                              create: (BuildContext context) =>
                                  GroupDataCubit()..getYourGroups(),
                            ),
                          ], child: Homescreen())));
                },
                child: Text("leave group")),
            SizedBox(
              height: getHeight(context) / 50,
            )
          ],
        ),
      ),
    );
  }
}
