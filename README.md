# SensingKit-iOS Library

An iOS library that provides Continuous Sensing functionality to your applications. For more information, please refer to the [project website](https://www.sensingkit.org).


## Supported Sensors

The following mobile sensors are currently supported in SensingKit-iOS, (listed in [SKSensorType](SensingKit/SKSensorType.h) enum):

- Accelerometer
- Gyroscope
- Magnetometer
- Device Motion (senses Attitude, Gravity, User Acceleration, Magnetic Field, Rotation)
- Motion Activity
- Pedometer
- Altimeter
- Battery
- Location
- Heading
- iBeacon™ Proximity
- Eddystone™ Proximity
- Microphone


## Installing the Library

You can easily install SensingKit using [CocoaPods](https://cocoapods.org), a popular dependency manager for Cocoa projects. For installing CocoaPods, use the following command:

```bash
$ gem install cocoapods
```

To integrate SensingKit into your Xcode project, specify it in your `Podfile`:

```ruby
target <MyApp> do
  # Uncomment this line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!

  pod 'SensingKit'
  # For the latest development version, please use:
  # pod 'SensingKit', :git => 'https://github.com/SensingKit/SensingKit-iOS.git', :branch => 'next'

end
```

Then, run the following command:

```bash
$ pod install
```

For more information about CocoaPods, visit [https://cocoapods.org](https://cocoapods.org).


## Using the Library

Import and init SensingKit as shown below:

*Objective-C*
```objectivec
#import <SensingKit/SensingKit.h>

@property (nonatomic, strong) SensingKitLib *sensingKit;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sensingKit = [SensingKitLib sharedSensingKitLib];
}
```

*Swift*
```swift
import SensingKit

let sensingKit = SensingKitLib.shared()
```


Check if a sensor is available in the device:

*Objective-C*
```objectivec
if ([self.sensingKit isSensorAvailable:Battery]) {
    // You can access the sensor
}
```

*Swift*
```swift
if sensingKit.isSensorAvailable(SKSensorType.Battery) {
    // You can access the sensor
}
```


Register a sensor (e.g. a Battery sensor) as shown below:

*Objective-C*
```objectivec
[self.sensingKit registerSensor:Battery error:NULL];
```

*Swift*
```swift
do {
    try sensingKit.register(SKSensorType.Battery)
}
catch {
    // Handle error
}
```


Subscribe a sensor data handler. You can cast the data object into the actual sensor data object in order to access all the sensor data properties:

*Objective-C*
```objectivec
[self.sensingKit subscribeToSensor:Battery
                       withHandler:^(SKSensorType sensorType, SKSensorData *sensorData, NSError *error) {

        if (!error) {
            SKBatteryData *batteryData = (SKBatteryData *)sensorData;
            NSLog(@"Battery Level: %f", batteryData.level);
        }
    } error:NULL];
```

*Swift*
```swift
do {
    try sensingkit.subscribe(to: SKSensorType.Battery, withHandler: { (sensorType, sensorData, error) in

        if (error != nil) {
            let batteryData = sensorData as! SKBatteryData
            print("Battery Level: \(batteryData)")
        }
    })
}
catch {
    // Handle error
}
```


You can Start and Stop the Continuous Sensing using the following commands:

*Objective-C*
```objectivec
// Start
[self.sensingKit startContinuousSensingWithSensor:Battery error:NULL];

// Stop
[self.sensingKit stopContinuousSensingWithSensor:Battery error:NULL];
```

*Swift*
```swift
// Start
do {
    try sensingKit.startContinuousSensingWithSensor(SKSensorType.Battery)
}
catch {
    // Handle error
}

// Stop
do {
    try sensingKit.stopContinuousSensingWithSensor(SKSensorType.Battery)
}
catch {
    // Handle error
}
```


For a complete description of our API, please refer to the [documentation page](https://www.sensingkit.org/documentation/ios/) of SensingKit website.


## Required Info.plist Keys

Depending on the used sensor and its configuration, some keys with a user-friendly description should be included in the [info.plist application file](https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/AboutInformationPropertyListFiles.html):

### Microphone
- NSMicrophoneUsageDescription

### Eddystone
- NSBluetoothPeripheralUsageDescription

### Location
- NSLocationAlwaysUsageDescription
- NSLocationWhenInUseUsageDescription
- NSLocationAlwaysAndWhenInUseUsageDescription

### MotionActivity
- NSMotionUsageDescription


## License

```
Copyright (c) 2014. Kleomenis Katevas
Kleomenis Katevas, k.katevas@imperial.ac.uk

This file is part of SensingKit-iOS library.
For more information, please visit https://www.sensingkit.org

SensingKit-iOS is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

SensingKit-iOS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with SensingKit-iOS.  If not, see <http://www.gnu.org/licenses/>.
```

This library is available under the GNU Lesser General Public License 3.0, allowing to use the library in your applications.

If you want to help with the open source project, contact hello@sensingkit.org.
