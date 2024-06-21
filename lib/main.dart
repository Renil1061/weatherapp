import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    // Initial weather data for the first city in the list
    MYapicalling('Surat');
  }

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
              image: AssetImage("Images/021e4d180be416909f473c2ed9d5e3f9.jpg"),
              fit: BoxFit.cover,
            ),
          ),
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
                      SizedBox(height: constraints.maxHeight * 0.1),
                      Text(
                        "${myWthrdata!.location!.city}",
                        style: TextStyle(
                          fontSize: constraints.maxWidth * 0.11,
                          fontFamily: "modeska",
                          color: Color(0xffDDE6ED),
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      Text(
                        "TODAY",
                        style: TextStyle(
                          fontSize: constraints.maxWidth * 0.05,
                          fontFamily: "modeska",
                          color: Colors.white54,
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Text(
                        "${myWthrdata!.currentObservation!.condition!.temperature}°C",
                        style: TextStyle(
                          fontSize: constraints.maxWidth * 0.22,
                          fontFamily: "num",
                          color: Color(0xff141E46),
                        ),
                      ),
                      Text(
                        "${myWthrdata!.currentObservation!.condition!.text}",
                        style: TextStyle(
                          fontFamily: "modeska",
                          fontSize: constraints.maxWidth * 0.04,
                          color: Colors.white54,
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      weatherInfoRow(
                        constraints,
                        "Wind speed",
                        "${myWthrdata!.currentObservation!.wind!.speed}Kmph",
                      ),
                      weatherInfoRow(
                        constraints,
                        "Direction",
                        "${myWthrdata!.currentObservation!.wind!.direction}",
                      ),
                      weatherInfoRow(
                        constraints,
                        "Pressure",
                        "${myWthrdata!.currentObservation!.atmosphere!.pressure}",
                      ),
                      weatherInfoRow(
                        constraints,
                        "Sunrise",
                        "${myWthrdata!.currentObservation!.astronomy!.sunrise}",
                      ),
                      weatherInfoRow(
                        constraints,
                        "Sunset",
                        "${myWthrdata!.currentObservation!.astronomy!.sunset}",
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),
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

  Widget weatherInfoRow(BoxConstraints constraints, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.07),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: "modeska",
                  fontSize: constraints.maxWidth * 0.07,
                  color: Colors.white54,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontFamily: "num2",
                  fontSize: constraints.maxWidth * 0.07,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.white12,
            thickness: 3,
            height: constraints.maxHeight * 0.02,
          ),
        ],
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

  Temperatures({this.location, this.currentObservation});

  Temperatures.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    currentObservation = json['current_observation'] != null
        ? CurrentObservation.fromJson(json['current_observation'])
        : null;
  }
}

class Location {
  String? city;

  Location({this.city});

  Location.fromJson(Map<String, dynamic> json) {
    city = json['city'];
  }
}

class CurrentObservation {
  Condition? condition;
  Wind? wind;
  Atmosphere? atmosphere;
  Astronomy? astronomy;

  CurrentObservation({this.condition, this.wind, this.atmosphere, this.astronomy});

  CurrentObservation.fromJson(Map<String, dynamic> json) {
    condition = json['condition'] != null
        ? Condition.fromJson(json['condition'])
        : null;
    wind = json['wind'] != null
        ? Wind.fromJson(json['wind'])
        : null;
    atmosphere = json['atmosphere'] != null
        ? Atmosphere.fromJson(json['atmosphere'])
        : null;
    astronomy = json['astronomy'] != null
        ? Astronomy.fromJson(json['astronomy'])
        : null;
  }
}

class Condition {
  int? temperature;
  String? text;

  Condition({this.temperature, this.text});

  Condition.fromJson(Map<String, dynamic> json) {
    temperature = json['temperature'];
    text = json['text'];
  }
}

class Wind {
  int? speed;
  String? direction;

  Wind({this.speed, this.direction});

  Wind.fromJson(Map<String, dynamic> json) {
    speed = json['speed'];
    direction = json['direction'];
  }
}

class Atmosphere {
  int? pressure;

  Atmosphere({this.pressure});

  Atmosphere.fromJson(Map<String, dynamic> json) {
    pressure = json['pressure'];
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
}
