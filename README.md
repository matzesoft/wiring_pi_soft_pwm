# Wiring Pi Software PWM

Dart implementation of the Wiring Pi Software PWM library.

I mainly created this package for one of my own projects, so I haven't done a lot of testing yet. But I still hope this makes the creation of your flutter-pi app (or whatever you create) easier.

## Installing Wiring Pi

Visit this [guide](http://wiringpi.com/download-and-install/) to install the Wiring Pi library on your Raspberry Pi. If your are using a Raspberry Pi 4B you might also check this [post](http://wiringpi.com/wiringpi-updated-to-2-52-for-the-raspberry-pi-4b/).

## Using the package

The first thing you always want to do is to create the `SoftPwmInterface`. You can specific a path to the dynamic library, the default path is `/usr/lib/libwiringPi.so`.
```dart
final pwmInterface = SoftPwmInterface(path: '/path/to/library.so');
```

Now create the `SoftPwmPin`. It takes the `SoftPwmInterface` created before and the pin of the GPIO. Afterwards call the `setup` method.
```dart
final pwmPin = SoftPwmPin(pwmInterface, 12);
pwmPin.setup();
```

The `SoftPwmPin` is setup and ready to use. You can use the `write` method to set the PWM duty cycle. The methods only allows values between 0 and 100.
```dart
pwmPin.write(50);
```