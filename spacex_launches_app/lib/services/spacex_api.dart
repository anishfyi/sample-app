import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/launch.dart';
import '../models/rocket.dart';

class SpaceXApi {
  static const String baseUrl = 'https://api.spacexdata.com/v4';

  // Fetch all launches
  Future<List<Launch>> fetchLaunches() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/launches'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Launch.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load launches: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load launches: $e');
    }
  }

  // Fetch a specific launch by ID
  Future<Launch> fetchLaunch(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/launches/$id'));
      
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        return Launch.fromJson(data);
      } else {
        throw Exception('Failed to load launch: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load launch: $e');
    }
  }

  // Fetch a rocket by ID
  Future<Rocket> fetchRocket(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/rockets/$id'));
      
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        return Rocket.fromJson(data);
      } else {
        throw Exception('Failed to load rocket: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load rocket: $e');
    }
  }

  // Fetch payload details by ID
  Future<Payload> fetchPayload(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/payloads/$id'));
      
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        return Payload.fromJson(data);
      } else {
        throw Exception('Failed to load payload: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load payload: $e');
    }
  }

  // Fetch all payloads for a launch
  Future<List<Payload>> fetchPayloadsForLaunch(List<String> payloadIds) async {
    List<Payload> payloads = [];
    
    for (String id in payloadIds) {
      try {
        Payload payload = await fetchPayload(id);
        payloads.add(payload);
      } catch (e) {
        print('Error fetching payload $id: $e');
      }
    }
    
    return payloads;
  }
} 