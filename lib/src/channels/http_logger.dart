
import 'dart:developer';
import 'package:http_interceptor/http_interceptor.dart';

import '../network_event.dart';
import '../network_logger.dart';

class HttpNetworkLogger extends InterceptorContract {
  final NetworkEventList eventList;
  final _requests = <BaseRequest, NetworkEvent>{};

  HttpNetworkLogger({NetworkEventList? eventList})
      : this.eventList = eventList ?? NetworkLogger.instance;

  @override
  Future<BaseRequest> interceptRequest({
    required BaseRequest request,
  }) async {
    print('----- Request -----');
    print(request.toString());
    print(request.headers.toString());
    log('-----mano  Request -----event ${request.url.toString()}${request.hashCode}');

    eventList.add(_requests[request] = NetworkEvent.now(
        request:  RequestCustom(
          uri: request.url.toString(),
          data: (request is Request)?request.body: request.headers,
          method: request.method,
          headers: Headers(request.headers.entries.map(
                (kv) => MapEntry(kv.key, '${kv.value}'),
          )),

        )));
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    log('----- Response -----');
    log('Code: ${response.statusCode}');
    if (response is Response) {
      log((response).body);
    }
    log('-----mano  Response -----event ${response.request?.url.toString()}${response.request.hashCode}');

    final event = response.request!=null?_requests.remove(response.request):null;
    log('-----mano  Response -----event $event');

    if (event != null) {
      log('-----mano  update -----event $event');

      eventList.updated(event..response =  ResponseCustom(
          data:  (response is Response)?response.body:"",
          statusCode: response.statusCode,
          statusMessage: response.reasonPhrase ?? 'unkown',
          headers: Headers(response.request?.headers?.entries?.map(
                (kv) => MapEntry(kv.key, '${kv.value}'),
          )??{},
          )));
    } else {
      log('-----mano  add -----event $event');

      eventList.add(NetworkEvent.now(
        request: RequestCustom(
          uri: response.request?.url.toString()??"",
          data: response.request?.headers,
          method: response.request?.method??"",
          headers: Headers(response.request?.headers?.entries?.map(
                (kv) => MapEntry(kv.key, '${kv.value}'),
          )??{}),

        ),
        response: ResponseCustom(
            data: (response is Response)?response.body:"",
            statusCode: response.statusCode  ,
            statusMessage: response.reasonPhrase ??  'unkown',
            headers:Headers(response.request?.headers?.entries?.map(
                  (kv) => MapEntry(kv.key, '${kv.value}'),
            )??{},)
        ),
      ));
    }

    return response;
  }



// dio.RequestOptions convertHttpRequestToDioOptions(http.BaseRequest request) {
//   // Parse query parameters from the URL
//   final uri = request.url;
//   final queryParameters = Map<String, dynamic>.from(uri.queryParameters);
//
//   // Extract headers
//   final headers = Map<String, String>.from(request.headers);
//
//   // Extract body (if available, typically for POST/PUT requests)
//   var data;
//   if (request is http.Request && request.body.isNotEmpty) {
//     // If the request body is JSON or any other string
//     data = request.body;
//   } else if (request is http.MultipartRequest) {
//     // Handle multipart request (for file uploads)
//     data = dio.FormData.fromMap({
//       ...request.fields,
//     });
//   }
//
//   // Create and return Dio RequestOptions
//   return dio.RequestOptions(
//     path: uri.path,
//     method: request.method,
//     baseUrl: '${uri.scheme}://${uri.host}',
//     queryParameters: queryParameters,
//     headers: headers,
//     data: data,
//   );
// }

}



