import 'package:flutter/material.dart';
import 'package:spaced_trip_scheduler/models/location.dart';
import 'package:spaced_trip_scheduler/widgets/location_time_slider.dart';
import 'package:spaced_trip_scheduler/widgets/passenger_slider.dart';

import '../constants.dart';

class TripSchedulePage extends StatefulWidget {
  final Location location;
  const TripSchedulePage({
    Key? key,
    required this.location,
  }) : super(key: key);

  @override
  State<TripSchedulePage> createState() => _TripSchedulePageState();
}

class _TripSchedulePageState extends State<TripSchedulePage>
    with TickerProviderStateMixin {
  late AnimationController _locationTimeSliderController;
  late AnimationController _passengerSliderController;
  bool locationDetailsCompleted = false;

  @override
  void initState() {
    super.initState();
    _locationTimeSliderController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..forward();
    _passengerSliderController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    _locationTimeSliderController.addListener(() async {
      if (_locationTimeSliderController.isCompleted) {
        await Future.delayed(const Duration(seconds: 2));
        _passengerSliderController.forward();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _locationTimeSliderController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Hero(
            tag: 'location_image' + widget.location.title,
            child: Transform.scale(
              scale: 1.3,
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                widget.location.imageUrl,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
            child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kBackgroundColor.withOpacity(0.5),
              kBackgroundColor.withOpacity(0.8),
            ],
            stops: const [0.0, 0.5],
          )),
        )),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'SCHEDULE TRIP',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
            ],
          ),
          body: Stack(
            children: [
              LocationTimeSlider(
                controller: _locationTimeSliderController,
                onCompleted: () {
                  setState(() {
                    locationDetailsCompleted = true;
                  });
                },
              ),
              PassengerSlider(
                controller: _passengerSliderController,
                activate: locationDetailsCompleted,
              )
            ],
          ),
        ),
      ],
    );
  }
}