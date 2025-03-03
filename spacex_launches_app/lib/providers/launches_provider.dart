import 'package:flutter/foundation.dart';
import '../models/launch.dart';
import '../models/rocket.dart';
import '../services/spacex_api.dart';

enum LaunchFilter {
  all,
  upcoming,
  past,
  successful,
  failed,
}

class LaunchesProvider with ChangeNotifier {
  final SpaceXApi _api = SpaceXApi();
  
  List<Launch> _launches = [];
  List<Launch> _filteredLaunches = [];
  bool _isLoading = false;
  String _error = '';
  LaunchFilter _currentFilter = LaunchFilter.all;
  int? _selectedYear;
  
  // Getters
  List<Launch> get launches => _launches;
  List<Launch> get filteredLaunches => _filteredLaunches;
  bool get isLoading => _isLoading;
  String get error => _error;
  LaunchFilter get currentFilter => _currentFilter;
  int? get selectedYear => _selectedYear;
  
  // Initialize and fetch launches
  Future<void> fetchLaunches() async {
    _isLoading = true;
    _error = '';
    notifyListeners();
    
    try {
      _launches = await _api.fetchLaunches();
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
  
  // Fetch a specific launch with detailed information
  Future<Launch> fetchLaunchDetails(String id) async {
    try {
      Launch launch = await _api.fetchLaunch(id);
      
      // Fetch rocket information
      if (launch.rocketId.isNotEmpty) {
        Rocket rocket = await _api.fetchRocket(launch.rocketId);
        // We could add the rocket to the launch here if needed
      }
      
      // Fetch payload information
      if (launch.payloads.isNotEmpty) {
        List<String> payloadIds = launch.payloads.map((p) => p.id).toList();
        List<Payload> payloads = await _api.fetchPayloadsForLaunch(payloadIds);
        
        // Update the launch with payload information
        // This would require modifying the Launch class to allow updating payloads
      }
      
      return launch;
    } catch (e) {
      throw Exception('Failed to load launch details: $e');
    }
  }
  
  // Set filter and apply it
  void setFilter(LaunchFilter filter) {
    _currentFilter = filter;
    _applyFilters();
    notifyListeners();
  }
  
  // Set year filter and apply it
  void setYearFilter(int? year) {
    _selectedYear = year;
    _applyFilters();
    notifyListeners();
  }
  
  // Apply current filters to the launches list
  void _applyFilters() {
    _filteredLaunches = List.from(_launches);
    
    // Apply status filter
    switch (_currentFilter) {
      case LaunchFilter.upcoming:
        _filteredLaunches = _filteredLaunches.where((launch) => launch.upcoming).toList();
        break;
      case LaunchFilter.past:
        _filteredLaunches = _filteredLaunches.where((launch) => !launch.upcoming).toList();
        break;
      case LaunchFilter.successful:
        _filteredLaunches = _filteredLaunches.where((launch) => launch.success == true).toList();
        break;
      case LaunchFilter.failed:
        _filteredLaunches = _filteredLaunches.where((launch) => launch.success == false).toList();
        break;
      case LaunchFilter.all:
      default:
        // No filtering needed
        break;
    }
    
    // Apply year filter if selected
    if (_selectedYear != null) {
      _filteredLaunches = _filteredLaunches.where((launch) {
        return launch.dateUtc != null && launch.dateUtc!.year == _selectedYear;
      }).toList();
    }
    
    // Sort by date (newest first)
    _filteredLaunches.sort((a, b) {
      if (a.dateUtc == null) return 1;
      if (b.dateUtc == null) return -1;
      return b.dateUtc!.compareTo(a.dateUtc!);
    });
  }
  
  // Get available years for filtering
  List<int> get availableYears {
    Set<int> years = {};
    
    for (var launch in _launches) {
      if (launch.dateUtc != null) {
        years.add(launch.dateUtc!.year);
      }
    }
    
    List<int> yearsList = years.toList();
    yearsList.sort((a, b) => b.compareTo(a)); // Sort descending
    return yearsList;
  }
  
  // Clear all filters
  void clearFilters() {
    _currentFilter = LaunchFilter.all;
    _selectedYear = null;
    _applyFilters();
    notifyListeners();
  }
} 