import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class LocationService {
  static final LocationService _instance = LocationService._internal();

  factory LocationService() {
    return _instance;
  }

  LocationService._internal();

  Position? _currentPosition;

  Position? get currentPosition => _currentPosition;

  /// Demande les permissions de localisation et retourne true si accordées
  Future<bool> requestLocationPermission() async {
    try {
      print('📍 Requesting location permission...');
      
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        print('   Permission denied, requesting...');
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        print('   ❌ Location permission denied by user');
        return false;
      }

      if (permission == LocationPermission.deniedForever) {
        print('   ❌ Location permission denied forever');
        print('   Opening app settings...');
        await Geolocator.openLocationSettings();
        return false;
      }

      print('✅ Location permission granted');
      return true;
    } catch (e) {
      print('❌ Error requesting location permission: $e');
      return false;
    }
  }

  /// Récupère la localisation actuelle
  Future<Position?> getCurrentLocation() async {
    try {
      print('📍 Getting current location...');
      
      // Vérifier les permissions d'abord
      final hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        print('   ❌ No location permission');
        return null;
      }

      // Récupérer la position avec un timeout de 30 secondes
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 0,
            timeLimit: Duration(seconds: 30),
          ),
        ).timeout(const Duration(seconds: 35));
      } catch (e) {
        print('   ⚠️ Location request timed out or failed: $e');
        return null;
      }

      if (position != null) {
        _currentPosition = position;
        print('✅ Location obtained:');
        print('   Latitude: ${position.latitude}');
        print('   Longitude: ${position.longitude}');
        print('   Accuracy: ${position.accuracy}m');
      }

      return position;
    } catch (e) {
      print('❌ Error getting location: $e');
      return null;
    }
  }

  /// Démarre le watch de localisation pour les mises à jour en temps réel
  Stream<Position> getLocationStream() {
    print('📍 Starting location stream...');
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10, // Mettre à jour tous les 10 mètres
        timeLimit: Duration(seconds: 5),
      ),
    );
  }

  /// Formate les coordonnées pour l'affichage
  String formatCoordinates(double latitude, double longitude) {
    return '$latitude, $longitude';
  }

  /// Vérifie si les coordonnées sont valides
  static bool isValidCoordinates(double? latitude, double? longitude) {
    if (latitude == null || longitude == null) return false;
    // Coordonnées valides: latitude entre -90 et 90, longitude entre -180 et 180
    return latitude >= -90 && latitude <= 90 && longitude >= -180 && longitude <= 180;
  }
}

final locationService = LocationService();
