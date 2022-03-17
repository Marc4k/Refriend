import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:refriend/constant/colors.dart';
import 'package:refriend/constant/size.dart';
import 'package:refriend/services/group_service.dart';
import 'package:refriend/services/weather_service.dart';
import 'package:refriend/widgets/custom_widgets.dart';
import 'package:refriend/widgets/refriendCustomWidgets.dart';

class CreateEvent extends StatefulWidget {
  final String groupCode;

  CreateEvent({this.groupCode});

  @override
  _CreateEventState createState() => _CreateEventState();
}

//Services
GroupService _groupService = GroupService();
final _eventName = TextEditingController();
final _location = TextEditingController();
final _description = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
bool isLoading = false;
bool isLoadingWeather = false;
double gapDivider = 7.5;
DateTime pickedDate;
TimeOfDay pickedTime = TimeOfDay(hour: 0, minute: 0);
String dateFormated = "";
String dateFormatedForUpload = "";
bool showWidget = false;
bool showWeather = false;
bool showError = false;

Map weatherData = {
  "max": "",
  "min": "",
  "day": "",
  "night": "",
  "weather": "",
};

class _CreateEventState extends State<CreateEvent> {
  @override
  Widget build(BuildContext context) {
    double gap = getHeight(context) / 35;

    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: CustomColors.backgroundColor2,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              customWave(context),
              Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.fromLTRB(getwidth(context) / 40, 0, 0, 0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                            _description.clear();
                            _eventName.clear();
                            _location.clear();
                            showError = false;
                            showWidget = false;
                            showWeather = false;
                            isLoading = false;
                            isLoadingWeather = false;
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        )),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Create a event",
                      style: GoogleFonts.righteous(
                          color: CustomColors.fontColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(getwidth(context) / 20),
                child: Column(
                  children: [
                    usernameTextfield(
                        "Event Name", _eventName, "Please enter a event name"),
                    SizedBox(height: gap),
                    usernameTextfield(
                        "Location", _location, "Please enter a event location"),
                    SizedBox(height: gap),
                    Visibility(
                      visible: !showWidget,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              onPrimary: Colors.white,
                              primary: CustomColors.custom_pink),
                          onPressed: () async {
                            pickedDate = await showDatePicker(
                                context: context, //context of current state
                                initialDate: DateTime.now(),
                                firstDate: DateTime(
                                    2000), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101));

                            pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context, //context of current state
                            );

                            setState(() {
                              isLoadingWeather = true;
                            });

                            DateTime now = DateTime.now();

                            DateTime pickedDateOnly = DateTime(pickedDate.year,
                                pickedDate.month, pickedDate.day);
                            DateTime nowDateOnly =
                                DateTime(now.year, now.month, now.day);
                            var difference =
                                pickedDateOnly.difference(nowDateOnly).inDays;

                            if (difference > 7 || difference < 0) {
                              dateFormated =
                                  DateFormat.yMMMMEEEEd().format(pickedDate);

                              dateFormatedForUpload =
                                  DateFormat.yMd().format(pickedDate);
                              showWidget = true;
                              showError = false;

                              setState(() {
                                isLoadingWeather = false;
                                gapDivider = 7;
                              });
                            } else {
                              LocationPermission permission =
                                  await Geolocator.checkPermission();

                              if (permission == LocationPermission.denied) {
                                LocationPermission permission =
                                    await Geolocator.requestPermission();
                              }

                              if (permission == LocationPermission.whileInUse ||
                                  permission == LocationPermission.always) {
                                Position position =
                                    await Geolocator.getCurrentPosition(
                                        desiredAccuracy: LocationAccuracy.high);

                                weatherData = await WeatherService().getWeather(
                                    difference,
                                    position.longitude.toString(),
                                    position.latitude.toString());

                                setState(() {
                                  dateFormated = DateFormat.yMMMMEEEEd()
                                      .format(pickedDate);

                                  dateFormatedForUpload =
                                      DateFormat.yMd().format(pickedDate);
                                  showWidget = true;
                                  showError = false;

                                  showWeather = true;
                                  isLoadingWeather = false;
                                  gapDivider = 3;
                                });
                              } else {
                                dateFormated =
                                    DateFormat.yMMMMEEEEd().format(pickedDate);

                                dateFormatedForUpload =
                                    DateFormat.yMd().format(pickedDate);
                                showWidget = true;
                                showError = false;

                                setState(() {
                                  isLoadingWeather = false;
                                  gapDivider = 7;
                                });
                              }
                            }
                          },
                          child: Text("pick date and time")),
                    ),
                    Visibility(
                      visible: showError,
                      child: Text("Please pick a date and time",
                          style: TextStyle(color: CustomColors.custom_pink)),
                    ),
                    Stack(
                      children: [
                        Visibility(
                          visible: isLoadingWeather,
                          child: SpinKitCircle(
                            color: Colors.white,
                          ),
                        ),
                        Column(
                          children: [
                            Visibility(
                              visible: showWidget,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: getwidth(context) / 15,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: getwidth(context) / 80),
                                  Text(
                                    dateFormated,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  Spacer(),
                                  IconButton(
                                      onPressed: () async {
                                        DateTime pickedDate =
                                            await showDatePicker(
                                                context:
                                                    context, //context of current state
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(
                                                    2000), //DateTime.now() - not to allow to choose before today.
                                                lastDate: DateTime(2101));

                                        setState(() {
                                          isLoadingWeather = true;
                                          showWeather = false;
                                          showWidget = false;
                                        });

                                        DateTime now = DateTime.now();

                                        DateTime pickedDateOnly = DateTime(
                                            pickedDate.year,
                                            pickedDate.month,
                                            pickedDate.day);
                                        DateTime nowDateOnly = DateTime(
                                            now.year, now.month, now.day);
                                        var difference = pickedDateOnly
                                            .difference(nowDateOnly)
                                            .inDays;

                                        if (difference > 7 || difference < 0) {
                                          dateFormated = DateFormat.yMMMMEEEEd()
                                              .format(pickedDate);

                                          dateFormatedForUpload =
                                              DateFormat.yMd()
                                                  .format(pickedDate);
                                          showWidget = true;
                                          showError = false;

                                          setState(() {
                                            isLoadingWeather = false;
                                          });
                                        } else {
                                          LocationPermission permission =
                                              await Geolocator
                                                  .checkPermission();

                                          if (permission ==
                                              LocationPermission.denied) {
                                            LocationPermission permission =
                                                await Geolocator
                                                    .requestPermission();
                                          }

                                          if (permission ==
                                                  LocationPermission
                                                      .whileInUse ||
                                              permission ==
                                                  LocationPermission.always) {
                                            Position position = await Geolocator
                                                .getCurrentPosition(
                                                    desiredAccuracy:
                                                        LocationAccuracy.high);
                                            print("Longitude" +
                                                position.longitude.toString());
                                            print("Latitude" +
                                                position.latitude.toString());
                                            weatherData = await WeatherService()
                                                .getWeather(
                                                    difference,
                                                    position.longitude
                                                        .toString(),
                                                    position.latitude
                                                        .toString());

                                            setState(() {
                                              dateFormated =
                                                  DateFormat.yMMMMEEEEd()
                                                      .format(pickedDate);

                                              dateFormatedForUpload =
                                                  DateFormat.yMd()
                                                      .format(pickedDate);
                                              showWidget = true;
                                              showError = false;

                                              showWeather = true;
                                              isLoadingWeather = false;
                                            });
                                          } else {
                                            dateFormated =
                                                DateFormat.yMMMMEEEEd()
                                                    .format(pickedDate);

                                            dateFormatedForUpload =
                                                DateFormat.yMd()
                                                    .format(pickedDate);
                                            showWidget = true;
                                            showError = false;

                                            setState(() {
                                              isLoadingWeather = false;
                                              gapDivider = 7;
                                            });
                                          }
                                        }
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: getwidth(context) / 18,
                                      ))
                                ],
                              ),
                            ),
                            Visibility(
                              visible: showWidget,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time_rounded,
                                    size: getwidth(context) / 14,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: getwidth(context) / 80),
                                  Text(
                                    pickedTime.format(context),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  Spacer(),
                                  IconButton(
                                      onPressed: () async {
                                        pickedTime = await showTimePicker(
                                          initialTime: TimeOfDay.now(),
                                          context:
                                              context, //context of current state
                                        );

                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: getwidth(context) / 18,
                                      ))
                                ],
                              ),
                            ),
                            SizedBox(height: gap / 3),
                            Visibility(
                              visible: showWeather,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  weatherData["weather"],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                            SizedBox(height: gap / 3),
                            Visibility(
                              visible: showWeather,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.wb_sunny,
                                    color: Colors.white,
                                    size: getwidth(context) / 18,
                                  ),
                                  Text(
                                    weatherData["day"].toString() + "°C",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  SizedBox(width: gap),
                                  Icon(
                                    Icons.arrow_drop_up,
                                    color: Colors.white,
                                    size: getwidth(context) / 18,
                                  ),
                                  Text(
                                    weatherData["max"].toString() + "°C",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: gap / 3),
                            Visibility(
                              visible: showWeather,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.nightlight,
                                    color: Colors.white,
                                    size: getwidth(context) / 18,
                                  ),
                                  Text(
                                    weatherData["night"].toString() + "°C",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  SizedBox(width: gap),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                    size: getwidth(context) / 18,
                                  ),
                                  Text(
                                    weatherData["min"].toString() + "°C",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: gap),
                    customTextfield("more Infos", _description, 3, 3),
                    SizedBox(height: gap * gapDivider),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(
                              getHeight(context) / 10, getHeight(context) / 10),
                          primary: CustomColors.custom_pink,
                          elevation: 5,
                          shape: CircleBorder()),
                      onPressed: () async {
                        if (!_formKey.currentState.validate()) {
                          if (showWidget == true) {
                            setState(() {
                              gapDivider = 2;
                            });
                          }

                          if (showWidget == false) {
                            setState(() {
                              showError = true;
                            });
                          }

                          return;
                        } else {
                          if (showWidget == false) {
                            setState(() {
                              showError = true;
                            });

                            return;
                          }

                          await _groupService.uploadGroupEvent(
                              _eventName.text,
                              dateFormatedForUpload,
                              _location.text,
                              pickedDate,
                              _description.text,
                              widget.groupCode);

                          _eventName.clear();
                          _location.clear();

                          Navigator.pop(context);
                        }
                      },
                      child: isLoading
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
              )
            ],
          ),
        )),
      ),
    );
  }
}
