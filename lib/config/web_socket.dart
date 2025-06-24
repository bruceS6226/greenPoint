import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class WebSocketService {
  StompClient? _client;
  Function(int)? onUpdateTank;

  void connect({required Function(int) onTankUpdate}) {
    this.onUpdateTank = onTankUpdate;

    _client = StompClient(
      config: StompConfig.SockJS(
        url: 'https://app.puntogreen.club/ws',
        onConnect: _onConnect,
        onWebSocketError: (error) => print('WebSocket error: $error'),
        reconnectDelay: const Duration(seconds: 5),
        // Puedes agregar headers si necesitas autenticación
      ),
    );

    _client!.activate();
  }

  void _onConnect(StompFrame frame) {
    _client?.subscribe(
      destination: '/topic/update-tank',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          final machineId = int.tryParse(frame.body!);
          if (machineId != null && onUpdateTank != null) {
            onUpdateTank!(machineId);
          }
        }
      },
    );
  }

  void disconnect() {
    _client?.deactivate();
  }
}
