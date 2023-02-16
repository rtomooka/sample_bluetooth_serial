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
      home: MyHomePage(title: 'Flutter Bluetooth Serial Demo'),
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
    final bondedDevices = useState([]);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              title: const Text("BlueTooth Enable"),
              trailing: ElevatedButton(
                onPressed: () async {
                  if (bluetoothEnable.value) return;
                  await FlutterBluetoothSerial.instance.requestEnable();
                  final result = await FlutterBluetoothSerial.instance.state;
                  if (result == BluetoothState.STATE_ON) {
                    bluetoothEnable.value = true;
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: bluetoothEnable.value
                      ? Theme.of(context).primaryColor
                      : Colors.redAccent,
                ),
                child: const Icon(Icons.bluetooth),
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("Bluetooth Status"),
              trailing: ElevatedButton(
                onPressed: () async {
                  await FlutterBluetoothSerial.instance.openSettings();
                },
                child: const Icon(Icons.settings_outlined),
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("Bonded Devices"),
              trailing: ElevatedButton(
                onPressed: () async {
                  bondedDevices.value =
                      await FlutterBluetoothSerial.instance.getBondedDevices();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: bondedDevices.value.isNotEmpty
                      ? Theme.of(context).primaryColor
                      : Colors.redAccent,
                ),
                child: const Icon(Icons.devices),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Bonded Devices"),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: bondedDevices.value.length,
            itemBuilder: (context, int index) {
              BluetoothDevice device = bondedDevices.value.elementAt(index);
              return Card(
                child: ExpansionTile(
                  title: Text(device.name ?? ""),
                  subtitle: Text(device.address),
                  expandedAlignment: Alignment.centerLeft,
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("bondState : ${device.bondState.stringValue}"),
                    Text("isBonded : ${device.isBonded}"),
                    Text("isConnected : ${device.isConnected}"),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
