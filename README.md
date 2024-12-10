# Network Logger
Network logger with well designed user interface to inspect network traffic logs. Included with Dio interceptor. You can start and inspect traffic just by writing [2 lines](https://github.com/TheMisir/flutter-network-logger/blob/master/example/lib/main.dart#L30-L31) of code.

## 📷 Screenshots

|Log feed|Log details|
|:-:|:-:|
|<img width="200" src="https://raw.githubusercontent.com/TheMisir/flutter-network-logger/master/screenshots/1.jpg" />|<img width="200" src="https://raw.githubusercontent.com/TheMisir/flutter-network-logger/master/screenshots/2.jpg" />|

## 🚀 Getting Started!

You are 3 steps ahead from viewing http traffic logs on well designed GUI.

### 1. Install **network_logger**.
Check [this guide](https://pub.dev/packages/network_logger/install) to install **network_logger** to your flutter project.

### 2. Add `DioNetworkLogger` interceptor to dio client.

**network_logger** provides powerful network traffic logging for Flutter and Dart applications. It supports popular [http](https://pub.dev/packages/http) clients like [Dio](https://pub.dev/packages/dio) and http, making it easy to debug and monitor network requests and responses in your app.
**Dio**

```dart
var dio = Dio();
dio.interceptors.add(DioNetworkLogger());
```
**Http**

Client  client =InterceptedClient.build(interceptors: [HttpNetworkLogger()]);


### 3. Attach network logger overlay button to UI.

The easiest way to access Network Logger UI is using `NetworkLoggerOverlay` which will display floating action button over all screens. You can also implement custom scenarios to open UI with different actions.

```dart
@override
void initState() {
  NetworkLoggerOverlay.attachTo(context);
  super.initState();
}
```