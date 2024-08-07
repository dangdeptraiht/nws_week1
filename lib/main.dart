import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const Timeblah());
}

class Timeblah extends StatelessWidget {
  const Timeblah({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return MaterialApp(
      title: 'Time and Map',
      theme: theme.copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.redAccent,
        ),
      ),
      home: const MyHomePage(
        title: 'Time increased by sec and Hanoi displayed',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int h = 0;
  int m = 0;
  int s = 0;
  late final MapController _mapController;
  final LatLng currentLatLng = LatLng(21.0285, 105.8542);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    h = DateTime.now().hour;
    m = DateTime.now().minute;
    s = DateTime.now().second;
    Timer.periodic(const Duration(seconds: 1), (Timer t) => getTime());
  }

  void getTime() {
    setState(() {
      h = DateTime.now().hour;
      m = DateTime.now().minute;
      s = DateTime.now().second;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                '${h < 10 ? "0$h" : h}:${m < 10 ? "0$m" : m}:${s < 10 ? "0$s" : s}',
                style: const TextStyle(fontSize: 25.0),
              ),
              const SizedBox(height: 10.0),
              Text(
                (h >= 12) ? "P.M" : "A.M",
                style: const TextStyle(fontSize: 25.0),
              ),
              const SizedBox(height: 20.0),
              Container(
                height: 400.0,
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: currentLatLng,
                    initialZoom: 16,
                    interactionOptions: const InteractionOptions(
                      flags: ~InteractiveFlag.doubleTapZoom,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName:
                      'dev.fleaflet.flutter_map.example',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
