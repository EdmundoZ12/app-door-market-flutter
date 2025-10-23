import 'package:door_market_app/service/location_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({Key? key, this.initialLocation})
    : super(key: key);

  static const String name = 'select_location_screen';
  final LatLng? initialLocation;

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  final LocationService _locationService = LocationService();
  GoogleMapController? _mapController;

  LatLng? _selectedLocation;
  String _selectedAddress = 'Selecciona una ubicación';
  bool _isLoadingAddress = false;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
    if (_selectedLocation != null) {
      _loadAddress(_selectedLocation!);
    }
  }

  Future<void> _loadAddress(LatLng location) async {
    setState(() => _isLoadingAddress = true);

    final address = await _locationService.getAddressFromCoordinates(
      location.latitude,
      location.longitude,
    );

    setState(() {
      _selectedAddress = address;
      _isLoadingAddress = false;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
    _loadAddress(location);
  }

  Future<void> _goToCurrentLocation() async {
    Position? position = await _locationService.getCurrentLocation();

    if (position != null && _mapController != null) {
      final location = LatLng(position.latitude, position.longitude);

      _mapController!.animateCamera(CameraUpdate.newLatLngZoom(location, 15));

      setState(() {
        _selectedLocation = location;
      });

      _loadAddress(location);
    }
  }

  void _confirmLocation() {
    if (_selectedLocation != null) {
      // Retornar la ubicación seleccionada
      context.pop({'location': _selectedLocation, 'address': _selectedAddress});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Mapa completo
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _selectedLocation ?? const LatLng(33.5186, -86.8104),
              zoom: 15,
            ),
            onTap: _onMapTap,
            markers: _selectedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('selected'),
                      position: _selectedLocation!,
                      draggable: true,
                      onDragEnd: (newPosition) {
                        setState(() {
                          _selectedLocation = newPosition;
                        });
                        _loadAddress(newPosition);
                      },
                    ),
                  }
                : {},
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),

          // Header superior
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Botón volver
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 2,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Título
                  const Expanded(
                    child: Text(
                      'Seleccionar ubicación',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Botón de ubicación actual
          Positioned(
            top: MediaQuery.of(context).padding.top + 80,
            right: 16,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              onPressed: _goToCurrentLocation,
              child: const Icon(Icons.my_location, color: Color(0xFFE02C2D)),
            ),
          ),

          // Panel inferior con dirección
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Indicador de arrastre
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Título
                    const Text(
                      'Ubicación seleccionada',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Dirección
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Color(0xFFE02C2D),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _isLoadingAddress
                              ? const Text(
                                  'Cargando dirección...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                )
                              : Text(
                                  _selectedAddress,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6B7280),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Botón confirmar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _selectedLocation != null
                            ? _confirmLocation
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE02C2D),
                          disabledBackgroundColor: const Color(0xFFE5E7EB),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Confirmar ubicación',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
