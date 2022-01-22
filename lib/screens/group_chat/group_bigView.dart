import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:refriend/constant/colors.dart';
import 'package:refriend/cubit/groupMembers_cubit.dart';
import 'package:refriend/database/database_group.dart';
import 'package:refriend/models/groupMembers.dart';
import 'package:refriend/services/group_service.dart';
import 'package:share/share.dart';

class GroupEventBigView extends StatefulWidget {
  const GroupEventBigView({Key key}) : super(key: key);

  @override
  _GroupEventBigViewState createState() => _GroupEventBigViewState();
}

GroupService _groupService = GroupService();

class _GroupEventBigViewState extends State<GroupEventBigView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundColor,
      ),
      backgroundColor: CustomColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
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
                onPressed: () {
                  Share.share('check out my website https://http://test.at/');
                },
                child: Text("Share invite link"))
          ],
        ),
      ),
    );
  }
}
