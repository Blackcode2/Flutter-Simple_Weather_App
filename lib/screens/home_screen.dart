import 'package:flutter/material.dart';
import 'package:simple_weather_app/data/my_location.dart';
import 'package:simple_weather_app/data/network.dart';

const apiKey = '96a7a3badb65203ce37caf781740308b';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late dynamic weatherData;
  String cityName = '--';
  double temp = 0.0;
  String weatherMain = '--';
  String weatherDescription = '--';

  @override
  void initState() {
    super.initState();
    getMyLocation();
  }

  Future<void> getMyLocation() async {
    Mylocation myLocation = Mylocation(context: context);
    await myLocation.checkPermission();
    await getWeatherData(myLocation.lat, myLocation.lon);
  }

  Future<dynamic> getWeatherData(double lat, double lon) async {
    Network network = Network(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric');
    weatherData = await network.getJsonData();
    setState(() {
      cityName = weatherData['name'];
      weatherMain = weatherData['weather'][0]['main'];
      weatherDescription = weatherData['weather'][0]['description'];
      temp = weatherData['main']['temp'];
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
            onPressed: () {},
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
      body: Container(
        height: size.height * 0.75,
        width: size.width,
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
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
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(
            height: 70,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
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
                WeatherIcon(weatherMain: weatherMain),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  weatherDescription,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  temp == 0.0 ? '--' : '${temp.round()}°C',
                  style: const TextStyle(color: Colors.white, fontSize: 60),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 45,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
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
    );
  }
}

class WeatherIcon extends StatefulWidget {
  final String weatherMain;
  const WeatherIcon({Key? key, required this.weatherMain}) : super(key: key);

  @override
  State<WeatherIcon> createState() => _WeatherIconState();
}

class _WeatherIconState extends State<WeatherIcon> {
  @override
  Widget build(BuildContext context) {
    if(widget.weatherMain == '--') {
      return const Text(
        '--',
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
      );
    } else if(widget.weatherMain == 'Clear') {
      return const Icon(
        Icons.sunny,
        color: Colors.amberAccent,
        size: 100.0,
      );
    } else if(widget.weatherMain == 'Rain' || widget.weatherMain == 'Drizzle') {
      return const Icon(
        Icons.water_drop_outlined,
        color: Colors.blue,
        size: 100.0,
      );
    } else if(widget.weatherMain == 'Thunderstorm') {
      return const Icon(
        Icons.thunderstorm_outlined,
        color: Colors.grey,
        size: 100.0,
      );
    } else if(widget.weatherMain == 'Snow') {
      return const Icon(
        Icons.ac_unit_outlined,
        color: Colors.white,
        size: 100.0,
      );
    } else if(widget.weatherMain == 'Atmosphere') {
      return const Icon(
        Icons.water_outlined,
        color: Colors.grey,
        size: 100.0,
      );
    } else if(widget.weatherMain == 'Clouds') {
      return const Icon(
        Icons.cloud,
        color: Colors.grey,
        size: 100.0,
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

