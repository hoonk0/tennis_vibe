import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../const/model/model_court.dart';
import '../../../../const/value/colors.dart';
import '../../../../const/value/text_style.dart';
import '../../../component/custom_divider.dart';
import '../court_search/court_information.dart';

class NearbyCourtsMap extends StatefulWidget {
  const NearbyCourtsMap({super.key});

  @override
  _NearbyCourtsMapState createState() => _NearbyCourtsMapState();
}

class _NearbyCourtsMapState extends State<NearbyCourtsMap> {
  final Location _location = Location();
  LocationData? _currentLocation;
  StreamSubscription<LocationData>? _locationSubscription;
  List<ModelCourt> _nearbyCourts = [];

  @override
  void initState() {
    super.initState();
    _initCurrentLocation();
  }

  Future<void> _initCurrentLocation() async {
    try {
      debugPrint("_initCurrentLocation");
      _currentLocation = await _location.getLocation();
      _loadNearbyCourts(_currentLocation!.latitude!, _currentLocation!.longitude!);
      _locationSubscription = _location.onLocationChanged.listen((LocationData currentLocation) {
        if (mounted) {
          setState(() {
            _currentLocation = currentLocation;
          });
        } else {
          if (_locationSubscription != null) {
            _locationSubscription!.cancel();
          }
        }

        _loadNearbyCourts(currentLocation.latitude!, currentLocation.longitude!);
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> _loadNearbyCourts(double latitude, double longitude) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('court').get();
    List<ModelCourt> courts = [];

    for (final doc in snapshot.docs) {
      final ModelCourt court = ModelCourt.fromJson(doc.data() as Map<String, dynamic>);
      final double distance = _calculateDistance(latitude, longitude, court.courtLat, court.courtLng);
      if (distance <= 5) {
        ///거리 조절  가능
        courts.add(court);
      }
    }

    courts.sort((a, b) =>
        _calculateDistance(latitude, longitude, a.courtLat, a.courtLng).compareTo(_calculateDistance(latitude, longitude, b.courtLat, b.courtLng)));

    if (mounted) {
      setState(() {
        _nearbyCourts = courts;
      });
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double radius = 6371; // 지구의 반지름 (단위: km)
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    double a = (sin(dLat / 2) * sin(dLat / 2)) + (cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2));
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = radius * c;
    return distance;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    return _currentLocation != null
        ? ListView.builder(
      itemCount: _nearbyCourts.length,
      itemBuilder: (context, index) {
        ModelCourt court = _nearbyCourts[index];
        final double distance = _calculateDistance(
          _currentLocation!.latitude!,
          _currentLocation!.longitude!,
          court.courtLat,
          court.courtLng,
        );

        return Column(
          children: [

            CustomDivider(),
            ListTile(
              minVerticalPadding: 10,
              title: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourtInformation(courtId: court.id),
                    ),
                  );
                },
                child: Text(
                  court.name,
                  style: TS.s13w600(colorGray900),
                ),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    court.location,
                    style: TS.s10w400(colorGray500),
                  ),
                  const SizedBox(height: 6),
                  Text('${distance.toStringAsFixed(1)} km'),
                ],
              ),
            ),
/*            if (index < _nearbyCourts.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(color: colorGray900),
              ),*/

            CustomDivider(),
          ],
        );
      },
    )
        : const Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }
}
