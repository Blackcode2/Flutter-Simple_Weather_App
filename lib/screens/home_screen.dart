import 'dart:async';
import 'package:flutter/material.dart';
import 'package:simple_weather_app/data/my_location.dart';
import 'package:simple_weather_app/data/network.dart';
import 'package:simple_weather_app/screens/search_screen.dart';

const apiKey = '';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late dynamic weatherData;
  dynamic hourlyWeatherData;
  String hourlyData = 'jj';
  String cityName = '--';
  double temp = 0.0;
  String weatherMain = '--';
  String weatherDescription = '--';
  Map hourlyWeatherMap = {};

  @override
  void initState() {
    super.initState();
    getMyLocation();
  }

  Future<void> getMyLocation() async {
    double lat;
    double lon;
    Mylocation myLocation = Mylocation(context: context);
    await myLocation
        .checkPermission(); // If the next line code is excuted even though this function is not done, there will be no location infromation so that await keword is needed.
    lat = myLocation.lat;
    lon = myLocation.lon;
    await getWeatherData(lat, lon);
  }

  Future<dynamic> getWeatherData(double? lat, double? lon) async {
    Network network = Network(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric');
    Network network2 = Network(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&cnt=4&appid=$apiKey&units=metric');
    weatherData = await network.getJsonData();
    hourlyWeatherData = await network2.getJsonData();
    setState(() {
      cityName = weatherData['name'];
      weatherMain = weatherData['weather'][0]['main'];
      weatherDescription = weatherData['weather'][0]['description'];
      temp = weatherData['main']['temp'];
      hourlyWeatherMap['first'] = {
        'temp': hourlyWeatherData['list'][0]['main']['temp'],
        'weather': hourlyWeatherData['list'][0]['weather'][0]['main'],
        'date': hourlyWeatherData['list'][0]['dt_txt'].substring(11, 16),
      };
      hourlyWeatherMap['second'] = {
        'temp': hourlyWeatherData['list'][1]['main']['temp'],
        'weather': hourlyWeatherData['list'][1]['weather'][0]['main'],
        'date': hourlyWeatherData['list'][1]['dt_txt'].substring(11, 16),
      };
      hourlyWeatherMap['third'] = {
        'temp': hourlyWeatherData['list'][2]['main']['temp'],
        'weather': hourlyWeatherData['list'][2]['weather'][0]['main'],
        'date': hourlyWeatherData['list'][2]['dt_txt'].substring(11, 16),
      };
      hourlyWeatherMap['fourth'] = {
        'temp': hourlyWeatherData['list'][3]['main']['temp'],
        'weather': hourlyWeatherData['list'][3]['weather'][0]['main'],
        'date': hourlyWeatherData['list'][3]['dt_txt'].substring(11, 16),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xff081b25),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            onPressed: () {
              showSearch(context: context, delegate: Search());
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            iconSize: 30.0,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: size.height * 0.70,
            width: size.width,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              gradient: LinearGradient(
                colors: [
                  Color(0xff955cd1),
                  Color(0xff3fa2fa),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.2, 0.85],
              ),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                height: size.height * 0.05,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      cityName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    WeatherIcon(
                        weatherMain: weatherMain,
                        imageHeight: 140,
                        imageWidth: 140),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      weatherDescription,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      temp == 0.0 ? '--' : '${temp.round()}°C',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.my_location,
                          color: Colors.white,
                          size: 28,
                        )),
                  ),
                ],
              )
            ]),
          ),
          // below card information
          Padding(
            padding: const EdgeInsets.fromLTRB(7, 7, 7, 7),
            child: SizedBox(
              height: size.height * 0.27,
              width: size.width,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  HourlyWeatherCard(
                      hourlyWeatherMap: hourlyWeatherMap['first']),
                  HourlyWeatherCard(
                      hourlyWeatherMap: hourlyWeatherMap['second']),
                  HourlyWeatherCard(
                      hourlyWeatherMap: hourlyWeatherMap['third']),
                  HourlyWeatherCard(
                      hourlyWeatherMap: hourlyWeatherMap['fourth']),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class WeatherIcon extends StatefulWidget {
  final String weatherMain;
  final double imageHeight;
  final double imageWidth;
  const WeatherIcon(
      {Key? key,
      required this.weatherMain,
      required this.imageHeight,
      required this.imageWidth})
      : super(key: key);

  @override
  State<WeatherIcon> createState() => _WeatherIconState();
}

class _WeatherIconState extends State<WeatherIcon> {
  Widget iconImage(
      {required String name, required double height, required double width}) {
    return Image.asset(
      name,
      height: height,
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.weatherMain == '--') {
      return const Text(
        '--',
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
      );
    } else if (widget.weatherMain == 'Clear') {
      return iconImage(
        name: 'assets/sun.png',
        width: widget.imageWidth,
        height: widget.imageHeight,
      );
    } else if (widget.weatherMain == 'Rain' ||
        widget.weatherMain == 'Drizzle') {
      return iconImage(
        name: 'assets/rain.png',
        width: widget.imageWidth,
        height: widget.imageHeight,
      );
    } else if (widget.weatherMain == 'Thunderstorm') {
      return iconImage(
        name: 'assets/storm.png',
        width: widget.imageWidth,
        height: widget.imageHeight,
      );
    } else if (widget.weatherMain == 'Snow') {
      return iconImage(
        name: 'assets/snow.png',
        width: widget.imageWidth,
        height: widget.imageHeight,
      );
    } else if (widget.weatherMain == 'Mist' || widget.weatherMain == 'Smoke') {
      return iconImage(
        name: 'assets/mist&wind.png',
        width: widget.imageWidth,
        height: widget.imageHeight,
      );
    } else if (widget.weatherMain == 'Clouds') {
      return iconImage(
        name: 'assets/cloud.png',
        width: widget.imageWidth,
        height: widget.imageHeight,
      );
    }

    return const Text(
      '--',
      style: TextStyle(
        color: Colors.white,
        fontSize: 30,
      ),
    );
  } //build
}

class HourlyWeatherCard extends StatefulWidget {
  final Map? hourlyWeatherMap;
  const HourlyWeatherCard({required this.hourlyWeatherMap, Key? key})
      : super(key: key);

  @override
  State<HourlyWeatherCard> createState() => _HourlyWeatherCardState();
}

class _HourlyWeatherCardState extends State<HourlyWeatherCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (widget.hourlyWeatherMap?['weather'] == null) {
      return Card(
        shape: RoundedRectangleBorder(
          //모서리를 둥글게 하기 위해 사용
          borderRadius: BorderRadius.circular(18.0),
        ),
        color: const Color(0xff955cd1),
        child: SizedBox(
          height: size.height,
          width: size.width * 0.30,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      return Card(
        shape: RoundedRectangleBorder(
          //모서리를 둥글게 하기 위해 사용
          borderRadius: BorderRadius.circular(18.0),
        ),
        color: const Color(0xff955cd1),
        child: SizedBox(
          height: size.height,
          width: size.width * 0.30,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                widget.hourlyWeatherMap!['date'],
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              WeatherIcon(
                weatherMain: widget.hourlyWeatherMap!['weather'],
                imageHeight: 70,
                imageWidth: 70,
              ),
              Text(
                '${widget.hourlyWeatherMap!['temp'].round()}°C',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
