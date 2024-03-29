import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:refriend/constant/colors.dart';
import 'package:refriend/constant/size.dart';
import 'package:refriend/cubit/groupEvent_cubit.dart';
import 'package:refriend/cubit/groupList_cubit.dart';
import 'package:refriend/cubit/groupMembers_cubit.dart';
import 'package:refriend/cubit/userData_cubit.dart';
import 'package:refriend/cubit/profilPicture_cubit.dart.dart';
import 'package:refriend/models/group.dart';
import 'package:refriend/screens/group_chat/groupEventChat.dart';
import 'package:refriend/screens/settings.dart';
import 'package:refriend/services/auth_service.dart';
import 'package:refriend/services/group_service.dart';

import 'package:refriend/widgets/refriendCustomWidgets.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math' as math;

class Homescreen extends StatefulWidget {
  static const _actionTitles = ['Create Post', 'Upload Photo', 'Upload Video'];

  const Homescreen({Key key}) : super(key: key);

  @override
  _HomescreenState createState() => _HomescreenState();
}

bool isLoadingJoinGroup = false;
String error = "";
final _inviteCodeController = TextEditingController();
GroupService _group_service = GroupService();

class _HomescreenState extends State<Homescreen> {
  AuthService _auth = AuthService();
  GroupService _groupService = GroupService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: CustomColors.backgroundColor2,
      body: Column(
        children: [
          customWave(context),
          Expanded(
            child: BlocBuilder<GroupDataCubit, List<Group>>(
              builder: (context, groupData) {
                if (groupData.isEmpty) {
                  return Container();
                } else {
                  return NotificationListener<OverscrollIndicatorNotification>(
                    onNotification:
                        (OverscrollIndicatorNotification overScroll) {
                      overScroll.disallowIndicator();
                      return false;
                    },
                    child: ListView.builder(
                      itemCount: groupData.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider<GroupEventCubit>(
                                          create: (BuildContext context) =>
                                              GroupEventCubit(
                                                  groupData[index].groupCode)
                                                ..getEvents(),
                                        ),
                                        BlocProvider<GroupMembersCubit>(
                                          create: (BuildContext context) =>
                                              GroupMembersCubit(
                                                  groupData[index].groupCode)
                                                ..getMembersData(),
                                        ),
                                      ],
                                      child: GroupEventChat(
                                        inviteCode: groupData[index].inviteCode,
                                        groupChatName: groupData[index].name,
                                        groupcode: groupData[index].groupCode,
                                        groupPictureUrl:
                                            groupData[index].groupImg,
                                      ),
                                    )));
                          },
                          child: listViewItemForMainScreen(
                            context,
                            groupData[index].name,
                            groupData[index].groupImg,
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),

//Floating Action Button

      floatingActionButton: ExpandableFab(
        distance: 110.0,
        children: [
          ActionButton(
            onPressed: () async {
              await Navigator.pushNamed(context, "/createGroup");

              context.read<GroupDataCubit>().getYourGroups();
            },
            icon: const Icon(Icons.add),
          ),
          ActionButton(
            onPressed: () async {
              await showModalBottomSheet(
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                  ),
                  backgroundColor: CustomColors.backgroundColor2,
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.42,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 35),
                              Text(
                                "Join a group",
                                style: GoogleFonts.righteous(
                                  textStyle: TextStyle(
                                    color: CustomColors.maincolor,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 25),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(25, 0, 25, 0),
                                  child: Text(
                                    "Group Code",
                                    style: GoogleFonts.roboto(
                                        color: CustomColors.fontColor,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(25, 5, 25, 5),
                                child: emailField(
                                    "Enter your Code", _inviteCodeController),
                              ),
                              Text(error,
                                  style: TextStyle(
                                      color: CustomColors.custom_pink)),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    fixedSize: Size(getHeight(context) / 10,
                                        getHeight(context) / 10),
                                    primary: CustomColors.custom_pink,
                                    elevation: 5,
                                    shape: CircleBorder()),
                                onPressed: () async {
                                  setState(() {
                                    isLoadingJoinGroup = true;
                                  });

                                  dynamic result = await _group_service
                                      .joinGroup(_inviteCodeController.text);
                                  if (result == null) {
                                    Fluttertoast.showToast(
                                        msg: "The Code is not valid!",
                                        toastLength: Toast.LENGTH_LONG,
                                        fontSize: 16.0);

                                    error = "";
                                    _inviteCodeController.clear();
                                    isLoadingJoinGroup = false;
                                  }
                                  if (result == true) {
                                    _inviteCodeController.clear();

                                    error = "";
                                    isLoadingJoinGroup = false;
                                    Fluttertoast.showToast(
                                        msg: "You joined the group!",
                                        toastLength: Toast.LENGTH_LONG,
                                        fontSize: 16.0);
                                    Navigator.pop(context);
                                  }
                                },
                                child: isLoadingJoinGroup
                                    ? SpinKitWave(
                                        color: Colors.white,
                                        size: 15,
                                      )
                                    : Icon(
                                        Icons.check,
                                        size: 50,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
              _inviteCodeController.clear();
              error = "";
              context.read<GroupDataCubit>().getYourGroups();
            },
            icon: const Icon(Icons.group_add),
          ),
          ActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                        providers: [
                          BlocProvider<ProfilPicture>(
                              create: (BuildContext context) =>
                                  ProfilPicture("")..getProfilPicture()),
                          BlocProvider<GetUserName>(
                              create: (BuildContext context) =>
                                  GetUserName()..getUserName()),
                        ],
                        child: Settings(),
                      )));
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
    ));
  }
}

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key key,
    this.initialOpen,
    this.distance,
    this.children,
  }) : super(key: key);

  final bool initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

//https://docs.flutter.dev/cookbook/effects/expandable-fab

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: CustomColors.custom_pink,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
              backgroundColor: CustomColors.custom_pink,
              onPressed: _toggle,
              child: const Icon(Icons.more_vert_outlined)),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    Key key,
    this.directionInDegrees,
    this.maxDistance,
    this.progress,
    this.child,
  }) : super(key: key);

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    Key key,
    this.onPressed,
    this.icon,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: CustomColors.custom_pink,
      elevation: 4.0,
      child: IconTheme.merge(
        data: theme.accentIconTheme,
        child: IconButton(
          onPressed: onPressed,
          icon: icon,
        ),
      ),
    );
  }
}
