# Changelog

### 0.3.0 (August 29, 2015)
- Added support for Pedometer sensor.
- Added support for Altimeter sensor.
- Added isSensorModuleAvailable: method to check for the availability of the sensor in the device.
- Added csvHeaderForSensorModule: method to get the headers of the csv format.
- Improved csvString by providing the timestamp in both string and timeIntervalSince1970 format.
- Added SKSensorTimestamp class for better managing sensor timestamps.
- Improved dictionaryData, making it compatible with JSON format.

### 0.2.0 (August 23, 2015)
- Added support for Eddystone™ Proximity sensor.
- Added [start/stop]ContinuousSensingWithAllRegisteredSensors in SensingKit API.
- Added dictionaryData method for returning all sensor data as an NSDictionary.
- Added moduleType property in SKSensorData.
- Renamed Proximity sensor into iBeaconProximity.
- Added generic SKProximityData that encapsulates multiple SKBeaconDeviceData.
- Further improvements in iBeacon™ Proximity sensor.

### 0.1.2 (August 15, 2015)
- Fixed crash with error message “SensorModule is already registered”.

### 0.1.1 (July 19, 2015)
- Supported csv format in sensor data.
- Fixed crash when deregistering multiple sensor modules.

### 0.1.0 (July 13, 2015)
- Initial Release.