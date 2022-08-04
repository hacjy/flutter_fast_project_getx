import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkWrapper extends StatefulWidget {
  final Widget child;
  NetworkWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);
  @override
  State<NetworkWrapper> createState() => _NetworkWrapperState();
}

class _NetworkWrapperState extends State<NetworkWrapper> {
  late Widget _body;

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult event) {
      if (event == ConnectivityResult.wifi) {
        _body = widget.child;
        setState(() {});
      } else if (event == ConnectivityResult.mobile) {
        _body = widget.child;
        setState(() {});
      } else {
        _body = Center(child: Text('No network!'));
        setState(() {});
      }
    });
  }

  @override
  Widget build(_) => _body;
}
