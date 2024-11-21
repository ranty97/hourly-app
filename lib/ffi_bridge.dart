import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

typedef TemperatureFunction = Double Function();
typedef TemperatureFunctionDart = double Function();

class FFIBridge {
  late TemperatureFunctionDart _getTemperature;

  FFIBridge() {
    // 1
    final dl = Platform.isAndroid
        ? DynamicLibrary.open('libmessagefromcpp.so')
        : DynamicLibrary.process();

    // _getTemperature = dl
    // // 2
    //     .lookupFunction<
    // // 3
    //     TemperatureFunction,
    // // 4
    //     TemperatureFunctionDart>('get_temperature');

    _getTemperature = dl
        .lookup<NativeFunction<TemperatureFunction>>('Java_com_example_hourly_NativeLib_getTemperature') // Убедитесь, что имя совпадает
        .asFunction<TemperatureFunctionDart>();

  }

  // 5
  //double getTemperature() => _getTemperature();
  String getTemperature() {
    double temperature = _getTemperature(); // Получаем значение типа double
    return temperature.toString(); // Преобразуем в строку
  }
}
