import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherService {
  Future getWeather(int day, String lat, String long) async {
    Map weatherData;

    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/onecall?lat=$long&lon=$lat&exclude=hourly,minutely,current,alerts&appid=a47aaeca2081c4db3b2f739e0e594ce8&units=Metric');
    var response = await http.get(url);

    var json = await jsonDecode(response.body);

    var jsonResult = await json["daily"] as List;

    weatherData = jsonResult[day]["temp"];
    weatherData["weather"] = jsonResult[0]["weather"][0]["main"];

    return weatherData;
  }
}
//{day: 7.47, min: 4.28, max: 13.3, night: 4.28, eve: 9.02, morn: 6.05}
