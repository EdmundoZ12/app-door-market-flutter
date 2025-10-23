import 'package:door_market_app/service/location_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class DeliveryAddressInformation extends StatefulWidget {
  const DeliveryAddressInformation({Key? key}) : super(key: key);

  @override
  State<DeliveryAddressInformation> createState() =>
      _DeliveryAddressInformationState();
}

class _DeliveryAddressInformationState
    extends State<DeliveryAddressInformation> {
  final LocationService _locationService = LocationService();

  LatLng? _currentLocation;
  String _address = 'Obteniendo ubicación...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    Position? position = await _locationService.getCurrentLocation();

    if (position != null) {
      final location = LatLng(position.latitude, position.longitude);
      final address = await _locationService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _currentLocation = location;
        _address = address;
        _isLoading = false;
      });
    } else {
      setState(() {
        _address = 'No se pudo obtener la ubicación';
        _isLoading = false;
      });
    }
  }

  void _openFullMap() async {
    final result = await context.push(
      '/select-location',
      extra: _currentLocation,
    );

    // Si retorna una ubicación, actualizarla
    if (result != null && result is Map<String, dynamic>) {
      final LatLng newLocation = result['location'] as LatLng;
      final String newAddress = result['address'] as String;

      setState(() {
        _currentLocation = newLocation;
        _address = newAddress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Seleccione su ubicación',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 16),

          // Mapa pequeño clickeable
          GestureDetector(
            onTap: _openFullMap,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _currentLocation == null
                    ? const Center(child: Text('No se pudo cargar el mapa'))
                    : Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: _currentLocation!,
                              zoom: 15,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('current'),
                                position: _currentLocation!,
                              ),
                            },
                            zoomControlsEnabled: false,
                            myLocationButtonEnabled: false,
                            mapToolbarEnabled: false,
                            compassEnabled: false,
                            scrollGesturesEnabled: false,
                            zoomGesturesEnabled: false,
                            tiltGesturesEnabled: false,
                            rotateGesturesEnabled: false,
                          ),
                          // Overlay para indicar que es clickeable
                          Container(color: Colors.transparent),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Dirección actual
          Row(
            children: [
              const Icon(Icons.location_on, color: Color(0xFFE02C2D), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _address,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
