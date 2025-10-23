import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  // Solicitar permisos de ubicación
  Future<bool> requestLocationPermission() async {
    PermissionStatus permission = await Permission.location.status;

    if (permission.isDenied) {
      permission = await Permission.location.request();
    }

    if (permission.isPermanentlyDenied) {
      // Abrir configuración de la app
      await openAppSettings();
      return false;
    }

    return permission.isGranted;
  }

  // Obtener ubicación actual
  Future<Position?> getCurrentLocation() async {
    try {
      // Verificar si el servicio de ubicación está habilitado
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('El servicio de ubicación está deshabilitado');
        return null;
      }

      // Solicitar permisos
      bool hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        print('Permisos de ubicación denegados');
        return null;
      }

      // Obtener posición actual
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return position;
    } catch (e) {
      print('Error obteniendo ubicación: $e');
      return null;
    }
  }

  // Convertir coordenadas a dirección
  Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return '${place.street}, ${place.locality}, ${place.country}';
      }
      return 'Dirección no encontrada';
    } catch (e) {
      print('Error obteniendo dirección: $e');
      return 'Error obteniendo dirección';
    }
  }

  // Calcular distancia entre dos puntos (en kilómetros)
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }
}
