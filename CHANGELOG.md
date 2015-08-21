# Changelog

### Next
	- Added [start/stop]ContinuousSensingWithAllRegisteredSensors in SensingKit API.
	- Added dictionaryData method for returning all sensor data as an NSDictionary.
	- Added moduleType property in SKSensorData.
	- Renamed Proximity sensor into iBeaconProximity.
	- Added generic SKProximityData that encapsulates multiple SKBeaconDeviceData.
	- Further improvements in iBeacon Proximity Sensing.

### 0.1.2
  - Fixed crash with error message “SensorModule is already registered”.

### 0.1.1
  - Supported csv format in sensor data.
  - Fixed crash when deregistering multiple sensors modules.

### 0.1.0
  - Initial Release.
