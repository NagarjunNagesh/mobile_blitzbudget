import 'failure.dart';

class APIFailure extends Failure {}

class FetchDataFailure extends APIFailure {}

class ClientFailure extends APIFailure {}

class ServerFailure extends APIFailure {}

class ConnectionFailure extends APIFailure {}

class NoNetworkFailure extends APIFailure {}

class GenericAPIFailure extends APIFailure {}
