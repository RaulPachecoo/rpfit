import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapaUI(),
    );
  }
}

class MapaUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapaUIState();
}

class MapaUIState extends State<MapaUI> {
  late GoogleMapController _controller;
  CameraPosition? _posicionInicial;
  Set<Marker> _markers = {};
  final String apiKey = 'AIzaSyChcT3HwnIvtOWgqQgEnsBqdW78bc3Z9ww';  // Asegúrate de poner tu API Key aquí

  @override
  Widget build(BuildContext context) {
    final GoogleMap googleMap = GoogleMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: _posicionInicial ?? CameraPosition(target: LatLng(0.0, 0.0)),
      mapType: MapType.normal,
      myLocationEnabled: true,
      markers: _markers,
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: true,
    );

    return Column(
      children: <Widget>[
        Expanded(
          child: googleMap,
        ),
      ],
    );
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });
    _solicitarPermisoUbicacion();
  }

  void _solicitarPermisoUbicacion() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return;
    }
    _actualizarUbicacion();
  }

  void _actualizarUbicacion() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    LatLng userLocation = LatLng(position.latitude, position.longitude);
    setState(() {
      _posicionInicial = CameraPosition(
        target: userLocation,
        zoom: 13.0,
      );
    });
    _controller.animateCamera(CameraUpdate.newCameraPosition(_posicionInicial!));
    _obtenerGimnasiosCercanos(userLocation);
  }

  void _obtenerGimnasiosCercanos(LatLng location) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=${location.latitude},${location.longitude}'
        '&radius=4000'
        '&type=gym'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> resultados = data['results'];

      Set<Marker> newMarkers = resultados.map((gimnasio) {
        return Marker(
          markerId: MarkerId(gimnasio['place_id']),
          position: LatLng(gimnasio['geometry']['location']['lat'], gimnasio['geometry']['location']['lng']),
          infoWindow: InfoWindow(title: gimnasio['name']),
        );
      }).toSet();

      setState(() {
        _markers = newMarkers;
      });
    } else {
      // Manejar error
      print('Error al obtener gimnasios: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
