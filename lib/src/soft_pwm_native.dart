import 'dart:ffi';
import 'dart:io';

/// Documentation is copied from `http://wiringpi.com/reference/`(10.02.2021, 17:54 CET).

/// Default path of the Wiring Pi library.
const _WIRING_PI_PATH = '/usr/lib/libwiringPi.so';

/// WiringPi Native: `wiringPiSetupGpio(void);`
typedef wiring_pi_setup_gpio = Void Function();
typedef WiringPiSetupGpio = void Function();

/// WiringPi Native: `int softPwmCreate(int pin, int initialValue, int pwmRange);`
typedef soft_pwm_create = Int32 Function(
  Int32 pin,
  Int32 initalValue,
  Int32 pwmRange,
);
typedef SoftPwmCreate = int Function(
  int pin,
  int initalValue,
  int pwmRange,
);

/// WiringPi Native: `void softPwmWrite(int pin, int value);`
typedef soft_pwm_write = Void Function(Int32 pin, Int32 value);
typedef SoftPwmWrite = void Function(int pin, int value);

class SoftPwmNative {
  DynamicLibrary? _dylib;

  late final wiringPiSetupGpio = _dylib!
      .lookup<NativeFunction<wiring_pi_setup_gpio>>('wiringPiSetupGpio')
      .asFunction<WiringPiSetupGpio>();

  /// This creates a software controlled PWM pin. You can use any GPIO pin and
  /// the pin numbering will be that of the wiringPiSetup() function you used.
  /// Use 100 for the pwmRange, then the value can be anything from 0 (off) to
  /// 100 (fully on) for the given pin. The return value is 0 for success.
  late final softPwmCreate = _dylib!
      .lookup<NativeFunction<soft_pwm_create>>('softPwmCreate')
      .asFunction<SoftPwmCreate>();

  /// This updates the PWM value on the given pin. The value is checked to be
  /// in-range and pins that haven’t previously been initialised via softPwmCreate
  /// will be silently ignored.
  late final softPwmWrite = _dylib!
      .lookup<NativeFunction<soft_pwm_write>>('softPwmWrite')
      .asFunction<SoftPwmWrite>();

  SoftPwmNative({String path: _WIRING_PI_PATH}) {
    try {
      _dylib = DynamicLibrary.open(path);
    } on ArgumentError catch (_) {
      throw FileSystemException(
        """
        Unable to open the Wiring Pi dynamic library at the path '$path'. Check
        if you installed Wiring Pi correctly (http://wiringpi.com/download-and-install/).
        If you are using the Raspberry Pi 4B you might have to manually upgrade
        to version 2.52 (http://wiringpi.com/wiringpi-updated-to-2-52-for-the-raspberry-pi-4b/).
        """,
        path,
      );
    }
  }
}
