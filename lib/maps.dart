import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocalizacaoAtual extends StatefulWidget {
  @override
  _LocalizacaoAtualState createState() => _LocalizacaoAtualState();
}

class _LocalizacaoAtualState extends State<LocalizacaoAtual> {
  late GoogleMapController _mapController;
  late LatLng _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _getCurrentLocation() async {
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Localização Atual'),
      ),
      body: _currentPosition != null ? GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: MarkerId('currentPosition'),
            position: _currentPosition,
          ),
        },
      ):  Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
