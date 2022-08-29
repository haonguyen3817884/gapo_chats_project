import 'dart:convert';
import 'dart:isolate';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import "package:base_flutter/models/base/api_response.dart";
import 'package:easy_isolate/easy_isolate.dart';

class MQTTService<T> {
  MQTTService(
      {this.host,
      this.port,
      this.topic,
      this.username,
      this.password,
      this.onMessagePublished});

  final String? host;

  final int? port;

  String? topic;

  String? username;

  String? password;

  Function? onMessagePublished;

  late MqttServerClient _mqttServerClient;

  late ApiResponse<T> apiResponse;

  final MessagePublishedWorker messagePublishedWorker =
      MessagePublishedWorker();

  set setUsername(String username) {
    this.username = username;
  }

  set setPassword(String password) {
    this.password = password;
  }

  set setTopic(String topic) {
    this.topic = topic;
  }

  set onMessagePublishedAction(Function onMessagePublished) {
    this.onMessagePublished = onMessagePublished;
  }

  void initializeMQTTClient() {
    _mqttServerClient = MqttServerClient(host!, "base_flutter")
      ..port = port
      ..logging(on: false)
      ..onDisconnected = onDisConnected
      ..onSubscribed = onSubscribed
      ..keepAlivePeriod = 20
      ..onConnected = onConnected;

    final connMess = MqttConnectMessage()
        .withClientIdentifier("base_flutter")
        .authenticateAs(username!, password!)
        .withWillTopic("willTopic")
        .withWillMessage("willMessage")
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    print("connecting");

    _mqttServerClient.connectionMessage = connMess;
  }

  Future connectMQTT() async {
    try {
      await _mqttServerClient.connect();

      print("connected");
    } on NoConnectionException catch (e) {
      _mqttServerClient.disconnect();

      print(e.toString());
    }
  }

  void disConnectMQTT() {
    try {
      _mqttServerClient.disconnect();
    } catch (e) {}
  }

  void onConnected() {
    try {
      messagePublishedWorker.init();

      messagePublishedWorker.onMessagePublishedAction = updateMessages;

      _mqttServerClient.subscribe(topic!, MqttQos.atLeastOnce);
      _mqttServerClient.updates!
          .listen((List<MqttReceivedMessage<MqttMessage?>>? t) {
        if (t![0].payload is MqttPublishMessage) {
          final MqttPublishMessage mqttPublishMessage =
              t[0].payload as MqttPublishMessage;

          messagePublishedWorker.sendToHandler(mqttPublishMessage);
        }
      });
    } catch (e) {}
  }

  void publish(String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    _mqttServerClient.publishMessage(
        topic!, MqttQos.atLeastOnce, builder.payload!);
    builder.clear();
  }

  void onDisConnected() {}

  void onSubscribed(String topic) {}

  void updateMessages(String message) {
    dynamic data = {"data": json.decode(message)};

    apiResponse = ApiResponse.fromJson(data);

    onMessagePublished!(apiResponse.data);
  }
}

class MessagePublishedWorker {
  MessagePublishedWorker({this.onMessagePublished});

  Function? onMessagePublished;

  final Worker worker = Worker();

  set onMessagePublishedAction(Function onMessagePublished) {
    this.onMessagePublished = onMessagePublished;
  }

  Future<void> init() async {
    await worker.init(mainHandler, isolateMessageHandler);
  }

  void sendToHandler(dynamic message) {
    worker.sendMessage(message);
  }

  void mainHandler(dynamic data, SendPort sendPort) {
    if (data is String) {
      onMessagePublished!(data);
    }
  }

  static isolateMessageHandler(dynamic data, SendPort sendPort,
      SendErrorFunction sendErrorFunction) async {
    if (data is MqttPublishMessage) {
      String message = utf8.decode(data.payload.message, allowMalformed: true);

      sendPort.send(message);
    }
  }
}
