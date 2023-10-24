import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherApp(),
    );
  }
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String cityName = '';
  String temperature = '';
  String description = '';
  final dio = Dio();
  final apiKey = '14c2d1c1779891269a6b44f15c107056'; 

  void getWeather() async {
    try {
      final response = await dio.get(

          'https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}');

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          temperature = data['main']['temp'].toString();
          description = data['weather'][0]['description'];
        });
      } else {
        setState(() {
          temperature = 'Error';
          description = 'City not found';
        });
      }
    } catch (e) {
      setState(() {
        temperature = 'Error';
        description = 'Connection error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                cityName = value;
              },
              decoration: InputDecoration(
                labelText: 'City Name',
              ),
            ),
            ElevatedButton(
              onPressed: getWeather,
              child: Text('Get Weather'),
            ),
            SizedBox(height: 20),
            Text('Temperature: $temperature °C'),
            Text('Description: $description'),
          ],
        ),
      ),
    );
  }
}
