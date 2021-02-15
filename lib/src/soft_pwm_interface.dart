import 'package:wiring_pi_soft_pwm/src/soft_pwm_native.dart';

/// Default path of the Wiring Pi library.
const _DEFAULT_PATH = '/usr/lib/libwiringPi.so';

/// Range of the PWM. Goes from 0 to this value.
const _PWM_RANGE = 100;

/// Holds the instance of the Wiring Pi library.
class SoftPwmInterface {
  SoftPwmNative _native;

  /// Opens the Wiring Pi library. The [path] should point to the `.so` file.
  /// The default path is `/usr/lib/libwiringPi.so`.
  ///
  /// Check http://wiringpi.com/download-and-install/ on more information how
  /// to install Wiring Pi correctly.
  /// If you are using the Raspberry Pi 4B you might have to manually upgrade
  /// to version 2.52 (http://wiringpi.com/wiringpi-updated-to-2-52-for-the-raspberry-pi-4b/).
  SoftPwmInterface({String path: _DEFAULT_PATH}) {
    _native = SoftPwmNative(_DEFAULT_PATH);
  }
}

class SoftPwmPin {
  SoftPwmNative _native;

  /// Pin number of the PWM pin.
  int _pin = -1;

  SoftPwmPin(SoftPwmInterface interface, this._pin) {
    this._native = interface._native;
    _native.wiringPiSetupGpio();
  }

  /// Sets up the software pwm for the specific pin.
  void setup({int initalValue: 0}) {
    final output = _native.softPwmCreate(_pin, initalValue, _PWM_RANGE);
    if (output < 0)
      throw StateError("Failed to setup the software pwm pin. (Pin: $_pin)");
  }

  /// Writes to the PWM. Only allows values between 0 and 100.
  void write(int value) {
    if (value < 0 || value > 100)
      throw ArgumentError(
        "PWM value must be between 0 and 100: $value (Pin: $_pin)",
      );
    _native.softPwmWrite(_pin, value);
  }
}
