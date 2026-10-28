import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:exploraec/controllers/auth_controller.dart';
import 'package:exploraec/controllers/gastos_controller.dart';
import 'package:exploraec/controllers/places_controller.dart' show EstadoCarga;
import 'package:exploraec/models/usuario.dart';
import 'package:exploraec/screens/gastos_screen.dart';
import 'package:exploraec/services/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class _Servidor implements HttpClientAdapter {
  final List<Map<String, dynamic>> gastos;
  _Servidor({required this.gastos});

  @override
  Future<ResponseBody> fetch(RequestOptions o, Stream<Uint8List>? cuerpo, Future<void>? cancelar) async {
    final ruta = o.path;
    if (ruta == '/usuarios/me') {
      return ResponseBody.fromString(
        jsonEncode({'id': 1, 'email': 'a@b.com'}),
        200,
        headers: {Headers.contentTypeHeader: ['application/json']},
      );
    }
    if (ruta == '/gastos/categorias') {
      return ResponseBody.fromString(
        jsonEncode({'categorias': ['comida', 'transporte', 'otros']}),
        200,
        headers: {Headers.contentTypeHeader: ['application/json']},
      );
    }
    if (ruta == '/gastos/' && o.method == 'GET') {
      return ResponseBody.fromString(
        jsonEncode(gastos),
        200,
        headers: {
          Headers.contentTypeHeader: ['application/json'],
          'x-total-count': ['${gastos.length}'],
        },
      );
    }
    return ResponseBody.fromString(
      jsonEncode({'detail': 'no previsto: $ruta'}),
      404,
      headers: {Headers.contentTypeHeader: ['application/json']},
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  setUpAll(() => Hive.init(Directory.systemTemp.createTempSync('hive_filtro').path));

  tearDown(() => Get.reset());

  Future<GastosController> montar(List<Map<String, dynamic>> datosGastos) async {
    Get.reset();
    Get.testMode = true;
    FlutterSecureStorage.setMockInitialValues({'access_token': 'tok-valido'});

    final servidor = _Servidor(gastos: datosGastos);
    final api = Get.put(ApiClient(dio: Dio(BaseOptions(baseUrl: 'http://prueba'))..httpClientAdapter = servidor));
    api.token = 'tok-valido';
    final auth = Get.put(AuthController());
    auth.usuario.value = const Usuario(id: 1, email: 'a@b.com');
    final controller = Get.put(GastosController());

    for (var i = 0; i < 200 && controller.estado.value != EstadoCarga.exito; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    return controller;
  }

  testWidgets('al elegir «comida» solo se muestran gastos de esa categoría y «Todas» restablece la lista',
      (tester) async {
    final datosGastos = [
      {'id': 1, 'descripcion': 'Ceviche mixto', 'monto': 8.5, 'categoria': 'comida', 'fecha': '2026-10-27'},
      {'id': 2, 'descripcion': 'Pasaje de bus', 'monto': 0.35, 'categoria': 'transporte', 'fecha': '2026-10-27'},
      {'id': 3, 'descripcion': 'Seco de chivo', 'monto': 5.0, 'categoria': 'comida', 'fecha': '2026-10-27'},
    ];

    late GastosController controller;
    await tester.runAsync(() async {
      controller = await montar(datosGastos);
    });

    await tester.pumpWidget(const GetMaterialApp(home: GastosScreen()));
    await tester.pump();

    // Las categorías deben obtenerse de los gastos disponibles
    expect(controller.categoriasDisponibles, containsAllInOrder(['comida', 'transporte']));

    // Se muestran todos los gastos inicialmente
    expect(find.text('Ceviche mixto'), findsOneWidget);
    expect(find.text('Pasaje de bus'), findsOneWidget);
    expect(find.text('Seco de chivo'), findsOneWidget);

    // Al elegir «comida» solo se muestran gastos de esa categoría
    await tester.tap(find.widgetWithText(FilterChip, 'comida'));
    await tester.pump();

    expect(find.text('Ceviche mixto'), findsOneWidget);
    expect(find.text('Seco de chivo'), findsOneWidget);
    expect(find.text('Pasaje de bus'), findsNothing);

    // Al seleccionar «Todas», debe mostrarse nuevamente la lista completa
    await tester.tap(find.widgetWithText(FilterChip, 'Todas'));
    await tester.pump();

    expect(find.text('Ceviche mixto'), findsOneWidget);
    expect(find.text('Seco de chivo'), findsOneWidget);
    expect(find.text('Pasaje de bus'), findsOneWidget);
  });
}
