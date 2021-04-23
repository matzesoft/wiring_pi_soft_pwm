import 'package:wiring_pi_soft_pwm/src/soft_pwm_native.dart';

/// Range of the PWM. Goes from 0 to this value.
const _PWM_RANGE = 100;

/// Entry point for using software PWM.
class SoftPwmGpio {
  static SoftPwmNative _native = SoftPwmNative();

  /// Pin number of the PWM gpio.
  int _pin = -1;

  /// Opens the Wiring Pi library. Check http://wiringpi.com/download-and-install/
  /// on more information how to install Wiring Pi correctly.
  /// If you are using the Raspberry Pi 4B you might have to manually upgrade
  /// to version 2.52 (http://wiringpi.com/wiringpi-updated-to-2-52-for-the-raspberry-pi-4b/).
  SoftPwmGpio(this._pin) {
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
