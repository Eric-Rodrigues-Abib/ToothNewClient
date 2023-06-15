import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'consultaAndamento_page.dart';

class LocalizacaoAtual extends StatefulWidget {
  final String? emergenciaId;
  LocalizacaoAtual({required this.emergenciaId});

  @override
  _LocalizacaoAtualState createState() => _LocalizacaoAtualState();
}

class _LocalizacaoAtualState extends State<LocalizacaoAtual> {
  late GoogleMapController _mapController;
  LatLng _currentPosition = LatLng(0, 0);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _getCurrentLocation() async {
    final Position? position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (position != null) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sua Localização Atual',
          style: TextStyle(
              fontFamily: 'InterFonte',
              fontWeight: FontWeight.w500),),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : GoogleMap(
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>TelaConsultaAndamento(emergenciaId: widget.emergenciaId)));*/
        },
        backgroundColor: Colors.purple,
        elevation: 0,
        label: Text('Prosseguir',
          style: TextStyle(
            fontFamily: 'InterFonte',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
