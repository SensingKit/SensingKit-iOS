# SensingKit-iOS Library

An iOS library that provides Continuous Sensing functionality to your applications. For more information, please refer to the [project website](http://www.sensingkit.org).


## Supported Sensors

The following sensor modules are currently supported in SensingKit-Android, (listed in [SKSensorModuleType](SensingKit/SKSensorModuleType.h) enum):

- Accelerometer
- Gyroscope
- Magnetometer
- Device Motion (senses Attitude, Gravity, User Acceleration, Magnetic Field, Rotation)
- Activity
- Battery
- Location
- Proximity (using iBeacon technology)


## Configuring the Library

- Open SensingKit project in Xcode and build SensingKit library using Product -> Build.

- Choose the ‘Framework’ scheme from the top toolbar (or using Product -> Scheme -> Framework) and build the framework. SensingKit.framework file should be available in your desktop.

- Move the generated SensingKit.framework file into your new Xcode project.


## How to Use this Library

- Import and init SensingKit into your Activity class as shown bellow:

```objectivec
#import <SensingKit/SensingKitLib.h>

@property (nonatomic, strong) SensingKitLib *sensingKit;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sensingKit = [SensingKitLib sharedSensingKitLib];
}
```


- Register a sensor module (e.g. a Battery sensor) as shown bellow:

```objectivec
[self.sensingKit registerSensorModule:Battery];
```


- Subscribe a sensor data listener. You can cast the data object into the actual sensor data object in order to access all the sensor data properties:

```objectivec
[self.sensingKit subscribeSensorDataListenerToSensor:Battery
                                         withHandler:^(SKSensorModuleType moduleType, SKSensorData *sensorData) {
        
        SKBatteryData *batteryData = (SKBatteryData *)sensorData;
        NSLog(@“Battery Level: %f”, batteryData.level);
    }];
```



- You can Start and Stop the Continuous Sensing using the following commands:

```objectivec
// Start
[self.sensingKit startContinuousSensingWithSensor:Battery];

// Stop
[self.sensingKit stopContinuousSensingWithSensor:Battery];
```


For a complete description of our API, please refer to the [project website](http://www.sensingkit.org).

## License

```
Copyright (c) 2014. Queen Mary University of London
Kleomenis Katevas, k.katevas@qmul.ac.uk

This file is part of SensingKit-iOS library.
For more information, please visit http://www.sensingkit.org

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
