import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Wthr(),
    debugShowCheckedModeBanner: false,
  ));
}

class Wthr extends StatefulWidget {
  const Wthr({Key? key}) : super(key: key);

  @override
  State<Wthr> createState() => _WthrState();
}

class _WthrState extends State<Wthr> {
  Temperatures? myWthrdata;
  List<String> cities = [
    'Surat',
    'Vadodara',
    'Rajkot',
    'Bhavnagar',
    'Jamnagar',
    'Junagadh',
    'Anand',
    'Bharuch',
    'Morbi',
    'Gandhidham',
    'Veraval',
  ];

  @override
  void initState() {
    super.initState();
    MYapicalling('Surat');
  }

  String fornoon = "Images/fornoon.JPG";
  String Night = "Images/night.JPG";
  late String img;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "WeatherWise",
            style: TextStyle(fontSize: 25, fontFamily: "num", color: Color(0xff141E46)),
          ),
          centerTitle: true,
          backgroundColor: Colors.orange,
        ),
        drawer: Drawer(
          backgroundColor: Colors.white60,
          child: ListView.builder(
            itemCount: cities.length + 1, // +1 for the header
            itemBuilder: (context, index) {
              if (index == 0) {
                return DrawerHeader(
                  child: Text(
                    'Cities',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }
              final city = cities[index - 1]; // Adjust index for header
              return ListTile(
                title: Text(city),
                onTap: () {
                  MYapicalling(city);
                  Navigator.pop(context); // Close the drawer
                },
              );
            },
          ),
        ),
        body: myWthrdata != null
            ? Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            "Images/021e4d180be416909f473c2ed9d5e3f9.jpg"),
                        fit: BoxFit.cover)),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Stack(
                      children: [
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                          child: Container(color: Colors.black.withOpacity(0)),
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${myWthrdata!.location!.city}",
                                  style: TextStyle(
                                      fontSize: constraints.maxWidth * 0.11,
                                      fontFamily: "modeska",
                                      color: Color(0xffDDE6ED)),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "TODAY",
                                  style: TextStyle(
                                      fontSize: constraints.maxWidth * 0.05,
                                      fontFamily: "modeska",
                                      color: Colors.white54),
                                )
                              ],
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              "${myWthrdata!.currentObservation!.condition!.temperature}c°",
                              style: TextStyle(
                                  fontSize: constraints.maxWidth * 0.22,
                                  fontFamily: "num",
                                  color: Color(0xff141E46)),
                            ),
                            Text(
                              "${myWthrdata!.currentObservation!.condition!.text}",
                              style: TextStyle(
                                  fontFamily: "modeska",
                                  fontSize: constraints.maxWidth * 0.04,
                                  color: Colors.white54),
                            ),
                            Expanded(child: SizedBox()),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: constraints.maxWidth * 0.07),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Wind speed",
                                    style: TextStyle(
                                        fontFamily: "modeska",
                                        fontSize: constraints.maxWidth * 0.07,
                                        color: Colors.white54),
                                  ),
                                  Expanded(child: SizedBox()),
                                  Text(
                                    "${myWthrdata!.currentObservation!.wind!.speed}Kmph",
                                    style: TextStyle(
                                        fontFamily: "num2",
                                        fontSize: constraints.maxWidth * 0.07,
                                        color: Colors.white54),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: constraints.maxWidth * 0.07),
                              child: Divider(
                                color: Colors.white12,
                                thickness: 3,
                                height: constraints.maxHeight * 0.05,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: constraints.maxWidth * 0.07),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Direction",
                                    style: TextStyle(
                                        fontFamily: "modeska",
                                        fontSize: constraints.maxWidth * 0.07,
                                        color: Colors.white54),
                                  ),
                                  Expanded(child: SizedBox()),
                                  SizedBox(width: constraints.maxWidth * 0.07),
                                  Text(
                                    "${myWthrdata!.currentObservation!.wind!.direction}",
                                    style: TextStyle(
                                        fontFamily: "num2",
                                        fontSize: constraints.maxWidth * 0.07,
                                        color: Colors.white54),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: constraints.maxWidth * 0.07),
                              child: Divider(
                                color: Colors.white12,
                                thickness: 3,
                                height: constraints.maxHeight * 0.05,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: constraints.maxWidth * 0.07),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Pressure",
                                    style: TextStyle(
                                        fontFamily: "modeska",
                                        fontSize: constraints.maxWidth * 0.07,
                                        color: Colors.white54),
                                  ),
                                  Expanded(child: SizedBox()),
                                  Text(
                                    "${myWthrdata!.currentObservation!.atmosphere!.pressure}",
                                    style: TextStyle(
                                        fontFamily: "num2",
                                        fontSize: constraints.maxWidth * 0.07,
                                        color: Colors.white54),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: constraints.maxWidth * 0.07),
                              child: Divider(
                                color: Colors.white12,
                                thickness: 3,
                                height: constraints.maxHeight * 0.05,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: constraints.maxWidth * 0.07),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Sunrise",
                                    style: TextStyle(
                                        fontFamily: "modeska",
                                        fontSize: constraints.maxWidth * 0.07,
                                        color: Colors.white54),
                                  ),
                                  Expanded(child: SizedBox()),
                                  Text(
                                    "${myWthrdata!.currentObservation!.astronomy!.sunrise}",
                                    style: TextStyle(
                                        fontFamily: "num2",
                                        fontSize: constraints.maxWidth * 0.07,
                                        color: Colors.white54),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: constraints.maxWidth * 0.07),
                              child: Divider(
                                color: Colors.white12,
                                thickness: 3,
                                height: constraints.maxHeight * 0.05,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: constraints.maxWidth * 0.07),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Sunset",
                                    style: TextStyle(
                                        fontFamily: "modeska",
                                        fontSize: constraints.maxWidth * 0.07,
                                        color: Colors.white54),
                                  ),
                                  Expanded(child: SizedBox()),
                                  SizedBox(width: constraints.maxWidth * 0.07),
                                  Text(
                                    "${myWthrdata!.currentObservation!.astronomy!.sunset}",
                                    style: TextStyle(
                                        fontFamily: "num2",
                                        fontSize: constraints.maxWidth * 0.07,
                                        color: Colors.white54),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: constraints.maxHeight * 0.03,
                            )
                          ],
                        ),
                      ],
                    );
                  },
                ),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> MYapicalling(String city) async {
    var url = Uri.parse(
        'https://yahoo-weather5.p.rapidapi.com/weather?location=$city&format=json&u=c');
    var response = await http.get(url, headers: {
      'X-RapidAPI-Key': '2f6a2533b1msh210a163c4a68e35p1612a2jsn6b505cdf6a13',
      'X-RapidAPI-Host': 'yahoo-weather5.p.rapidapi.com'
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    Map<String, dynamic> map = jsonDecode(response.body);
    setState(() {
      myWthrdata = Temperatures.fromJson(map);
    });
  }
}

class Temperatures {
  Location? location;
  CurrentObservation? currentObservation;
  List<Forecasts>? forecasts;

  Temperatures({this.location, this.currentObservation, this.forecasts});

  Temperatures.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    currentObservation = json['current_observation'] != null
        ? new CurrentObservation.fromJson(json['current_observation'])
        : null;
    if (json['forecasts'] != null) {
      forecasts = <Forecasts>[];
      json['forecasts'].forEach((v) {
        forecasts!.add(new Forecasts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    if (this.currentObservation != null) {
      data['current_observation'] = this.currentObservation!.toJson();
    }
    if (this.forecasts != null) {
      data['forecasts'] = this.forecasts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Location {
  String? city;
  int? woeid;
  String? country;
  double? lat;
  double? long;
  String? timezoneId;

  Location(
      {this.city,
      this.woeid,
      this.country,
      this.lat,
      this.long,
      this.timezoneId});

  Location.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    woeid = json['woeid'];
    country = json['country'];
    lat = json['lat'];
    long = json['long'];
    timezoneId = json['timezone_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['woeid'] = this.woeid;
    data['country'] = this.country;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['timezone_id'] = this.timezoneId;
    return data;
  }
}

class CurrentObservation {
  int? pubDate;
  Wind? wind;
  Atmosphere? atmosphere;
  Astronomy? astronomy;
  Condition? condition;

  CurrentObservation(
      {this.pubDate,
      this.wind,
      this.atmosphere,
      this.astronomy,
      this.condition});

  CurrentObservation.fromJson(Map<String, dynamic> json) {
    pubDate = json['pubDate'];
    wind = json['wind'] != null ? new Wind.fromJson(json['wind']) : null;
    atmosphere = json['atmosphere'] != null
        ? new Atmosphere.fromJson(json['atmosphere'])
        : null;
    astronomy = json['astronomy'] != null
        ? new Astronomy.fromJson(json['astronomy'])
        : null;
    condition = json['condition'] != null
        ? new Condition.fromJson(json['condition'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pubDate'] = this.pubDate;
    if (this.wind != null) {
      data['wind'] = this.wind!.toJson();
    }
    if (this.atmosphere != null) {
      data['atmosphere'] = this.atmosphere!.toJson();
    }
    if (this.astronomy != null) {
      data['astronomy'] = this.astronomy!.toJson();
    }
    if (this.condition != null) {
      data['condition'] = this.condition!.toJson();
    }
    return data;
  }
}

class Wind {
  int? chill;
  String? direction;
  int? speed;

  Wind({this.chill, this.direction, this.speed});

  Wind.fromJson(Map<String, dynamic> json) {
    chill = json['chill'];
    direction = json['direction'];
    speed = json['speed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chill'] = this.chill;
    data['direction'] = this.direction;
    data['speed'] = this.speed;
    return data;
  }
}

class Atmosphere {
  int? humidity;
  int? visibility;
  int? pressure;

  Atmosphere({this.humidity, this.visibility, this.pressure});

  Atmosphere.fromJson(Map<String, dynamic> json) {
    humidity = json['humidity'];
    visibility = json['visibility'];
    pressure = json['pressure'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['humidity'] = this.humidity;
    data['visibility'] = this.visibility;
    data['pressure'] = this.pressure;
    return data;
  }
}

class Astronomy {
  String? sunrise;
  String? sunset;

  Astronomy({this.sunrise, this.sunset});

  Astronomy.fromJson(Map<String, dynamic> json) {
    sunrise = json['sunrise'];
    sunset = json['sunset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sunrise'] = this.sunrise;
    data['sunset'] = this.sunset;
    return data;
  }
}

class Condition {
  int? temperature;
  String? text;
  int? code;

  Condition({this.temperature, this.text, this.code});

  Condition.fromJson(Map<String, dynamic> json) {
    temperature = json['temperature'];
    text = json['text'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['temperature'] = this.temperature;
    data['text'] = this.text;
    data['code'] = this.code;
    return data;
  }
}

class Forecasts {
  String? day;
  int? date;
  int? high;
  int? low;
  String? text;
  int? code;

  Forecasts({this.day, this.date, this.high, this.low, this.text, this.code});

  Forecasts.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    date = json['date'];
    high = json['high'];
    low = json['low'];
    text = json['text'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['date'] = this.date;
    data['high'] = this.high;
    data['low'] = this.low;
    data['text'] = this.text;
    data['code'] = this.code;
    return data;
  }
}
