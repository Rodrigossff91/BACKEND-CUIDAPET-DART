import 'package:BACKEND_CUIDAPET_DART/application/middlewares/middlewares.dart';
import 'package:shelf/src/request.dart';
import 'package:shelf/src/response.dart';

class DefaultContentType extends Middlewares {
  final String contentType;
  DefaultContentType({
    required this.contentType,
  });
  @override
  Future<Response> execute(Request request) async {
    final response = await innerHandler(request);
    return response.change(context: {'content-type': contentType});
  }
}
