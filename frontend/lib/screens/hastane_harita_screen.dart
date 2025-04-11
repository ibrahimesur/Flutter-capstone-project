import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HastaneHaritaScreen extends StatefulWidget {
  const HastaneHaritaScreen({super.key});

  @override
  _HastaneHaritaScreenState createState() => _HastaneHaritaScreenState();
}

class _HastaneHaritaScreenState extends State<HastaneHaritaScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};

  final LatLng hastaneKonumu = LatLng(41.0082, 28.9784); // Örnek konum

  @override
  void initState() {
    super.initState();
    markers.add(
      Marker(
        markerId: MarkerId('hastane'),
        position: hastaneKonumu,
        infoWindow: InfoWindow(title: 'Hastane'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: hastaneKonumu,
              zoom: 15,
            ),
            markers: markers,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text('Kat Planları', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Kat planı görüntüleme
                    },
                    child: Text('Zemin Kat'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('1. Kat'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('2. Kat'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
} 