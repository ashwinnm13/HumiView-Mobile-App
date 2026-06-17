/// ESP32 device model
class Device {
  final String id;
  final String serialNumber;
  final String firmwareVersion;
  final String connectionType; // 'wifi' | 'usb'
  final bool isConnected;
  final int signalStrength; // dBm, only for Wi-Fi
  final DateTime? lastSeen;

  const Device({
    required this.id,
    required this.serialNumber,
    this.firmwareVersion = '1.0.0',
    this.connectionType = 'wifi',
    this.isConnected = true,
    this.signalStrength = -50,
    this.lastSeen,
  });
}
