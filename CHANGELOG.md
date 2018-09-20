# Changelog

### 0.5.1 (September 20, 2018)
- Added support for Heading sensor.
- Added support for iOS 12 and Xcode 10.
- Changed the minimum supported platform to iOS 9.
- Fixed a bug with incorrect timestamps reported for some sensors.

### 0.5.0 (March 2, 2017)
- Added error handling support using NSError.
- Updated Eddystone Scanner into latest version.
- Changed library into a dynamic framework.
- Added CocoaPod support.
- Added support for iOS 10.
- Improved SensingKit API.
- Updated SensingKit Documentation.

### 0.4.2 (November 27, 2015)
- Fixed a bug where sensor configuration was not updated.

### 0.4.1 (October 16, 2015)
- Added a restriction of 4 hours when recording audio using Microphone sensor.

### 0.4.0 (October 11, 2015)
- Added Documentation using appledoc generator.
- Added support for iOS 9.
- Added support for iOS 9 App Slicing.
- Added support for Swift 2 language
- Updated SensingKit-iOS API.
- Added Configuration for all sensors.
- Added support for Microphone sensor.
- Added currentPace and currentCadence in PedometerData (iOS 9 only)
- SensorModules have been renamed into Sensors.
- Activity sensor has been renamed into MotionActivity.

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