import 'package:signalr_core/signalr_core.dart';

class SignalRManager {
  static final SignalRManager _instance = SignalRManager._internal();
  late HubConnection connection;

  factory SignalRManager() {
    return _instance;
  }

  SignalRManager._internal();

  Future<void> initConnection(int userId) async {
    connection = HubConnectionBuilder()
        .withUrl('http://192.168.0.101/statusHub?user_id=$userId')
        .build();

    await connection.start();
    print('SignalR connection started');
  }

  Future<void> stopConnection() async {
    await connection.stop();
    print('SignalR connection stopped');
  }
}
