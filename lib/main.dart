import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends HookWidget {
  MyHomePage({super.key, required this.title});
  final String title;

  List<BluetoothDevice> devices = [];

  @override
  Widget build(BuildContext context) {
    final bluetoothEnable = useState(false);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              title: Text("BlueTooth ${bluetoothEnable.value}"),
              leading: ElevatedButton(
                onPressed: () async {
                  if (bluetoothEnable.value) return;
                  await FlutterBluetoothSerial.instance.requestEnable();
                  final result = await FlutterBluetoothSerial.instance.state;
                  if (result == BluetoothState.STATE_ON) {
                    bluetoothEnable.value = true;
                  }
                },
                child: Icon(Icons.bluetooth),
              ),
              trailing: bluetoothEnable.value
                  ? Icon(Icons.check_box_outlined)
                  : Icon(Icons.check_box_outline_blank_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
