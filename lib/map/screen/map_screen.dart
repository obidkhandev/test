import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_pro/map/data/models/address_detail_model.dart';
import 'package:test_pro/map/data/models/app_lat_long.dart';
import 'package:test_pro/map/data/repository/address_detail_repository.dart';
import 'package:test_pro/services/app_location_service.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final mapControllerCompleter = Completer<YandexMapController>();
  String addressDetail = "Map Page";
  final AddressDetailRepository repository = AddressDetailRepository();

  @override
  void initState() {
    super.initState();
    _initPermission().ignore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _fetchCurrentLocation();
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.location_searching, color: Colors.blue),
      ),
      body: Stack(
        children: [
          YandexMap(
            onMapCreated: (controller) {
              mapControllerCompleter.complete(controller);
            },
            onCameraPositionChanged: (cameraPosition, reason, finished) {
              if (finished) {
                updateAddressDetail(AppLatLong(
                    lat: cameraPosition.target.latitude,
                    long: cameraPosition.target.longitude));
              }
            },
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: Icon(
              Icons.location_on,
              size: 40,
              color: Colors.red,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding:
                  const EdgeInsets.only(left: 20, right: 20, bottom: 50, top: 20),
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )),
              child: Text(addressDetail,style: const TextStyle(color: Colors.white,fontSize: 20),),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _initPermission() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    await _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    AppLatLong location;
    const defLocation = TashkentLocation();
    try {
      location = await LocationService().getCurrentLocation();
    } catch (_) {
      location = defLocation;
    }
    updateAddressDetail(location);
    _moveToCurrentLocation(location);
  }

  Future<void> _moveToCurrentLocation(AppLatLong appLatLong) async {
    (await mapControllerCompleter.future).moveCamera(
      animation: const MapAnimation(type: MapAnimationType.linear, duration: 1),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: appLatLong.lat,
            longitude: appLatLong.long,
          ),
          zoom: 12,
        ),
      ),
    );
  }

  Future<void> updateAddressDetail(AppLatLong latLong) async {
    addressDetail = "Loading...";
    setState(() {});
    AddressDetailModel? data = await repository.getAddressDetail(latLong);
    addressDetail = data!.responset!.geoObjectCollection!.featureMember!.isEmpty
        ? "unknown_place"
        : data.responset!.geoObjectCollection!.featureMember![0].geoObject!
            .metaDataProperty!.geocoderMetaData!.address!.formatted
            .toString();
    setState(() {});
    debugPrint(addressDetail);
  }
}
