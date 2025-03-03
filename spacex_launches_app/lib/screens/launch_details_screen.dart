import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/launch.dart';
import '../models/rocket.dart';
import '../providers/launches_provider.dart';
import '../services/spacex_api.dart';

class LaunchDetailsScreen extends StatefulWidget {
  final String launchId;

  const LaunchDetailsScreen({
    Key? key,
    required this.launchId,
  }) : super(key: key);

  @override
  State<LaunchDetailsScreen> createState() => _LaunchDetailsScreenState();
}

class _LaunchDetailsScreenState extends State<LaunchDetailsScreen> {
  late Future<Launch> _launchFuture;
  Rocket? _rocket;
  List<Payload> _payloads = [];
  bool _isLoadingRocket = false;
  bool _isLoadingPayloads = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadLaunchDetails();
  }

  Future<void> _loadLaunchDetails() async {
    final provider = Provider.of<LaunchesProvider>(context, listen: false);
    _launchFuture = provider.fetchLaunchDetails(widget.launchId);

    _launchFuture.then((launch) {
      _loadRocketDetails(launch.rocketId);
      if (launch.payloads.isNotEmpty) {
        _loadPayloadDetails(launch.payloads.map((p) => p.id).toList());
      }
    }).catchError((error) {
      setState(() {
        _error = error.toString();
      });
    });
  }

  Future<void> _loadRocketDetails(String rocketId) async {
    if (rocketId.isEmpty) return;

    setState(() {
      _isLoadingRocket = true;
    });

    try {
      final api = SpaceXApi();
      final rocket = await api.fetchRocket(rocketId);
      
      setState(() {
        _rocket = rocket;
        _isLoadingRocket = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingRocket = false;
        _error = 'Failed to load rocket details: $e';
      });
    }
  }

  Future<void> _loadPayloadDetails(List<String> payloadIds) async {
    if (payloadIds.isEmpty) return;

    setState(() {
      _isLoadingPayloads = true;
    });

    try {
      final api = SpaceXApi();
      final payloads = await api.fetchPayloadsForLaunch(payloadIds);
      
      setState(() {
        _payloads = payloads;
        _isLoadingPayloads = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingPayloads = false;
        _error = 'Failed to load payload details: $e';
      });
    }
  }

  Future<void> _launchURL(String? url) async {
    if (url == null || url.isEmpty) return;
    
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Launch Details'),
      ),
      body: FutureBuilder<Launch>(
        future: _launchFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError || _error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading launch details',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error?.toString() ?? _error,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadLaunchDetails,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('No launch data available'),
            );
          }

          final launch = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mission patch and basic info
                _buildHeader(launch),
                
                // Launch details
                _buildDetailsSection(launch),
                
                // Links section
                _buildLinksSection(launch),
                
                // Rocket information
                _buildRocketSection(),
                
                // Payload information
                _buildPayloadsSection(),
                
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(Launch launch) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (launch.patchLarge != null)
            CachedNetworkImage(
              imageUrl: launch.patchLarge!,
              height: 200,
              placeholder: (context, url) => const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.rocket_launch,
                size: 100,
                color: Colors.grey,
              ),
            )
          else
            const Icon(
              Icons.rocket_launch,
              size: 100,
              color: Colors.grey,
            ),
          const SizedBox(height: 16),
          Text(
            launch.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          _buildStatusChip(launch),
          const SizedBox(height: 8),
          Text(
            'Date: ${launch.formattedDate} ${launch.formattedTime}',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(Launch launch) {
    Color chipColor;
    String statusText = launch.statusText;
    
    if (launch.upcoming) {
      chipColor = Colors.blue;
    } else if (launch.success == true) {
      chipColor = Colors.green;
    } else {
      chipColor = Colors.red;
    }
    
    return Chip(
      label: Text(
        statusText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      backgroundColor: chipColor,
    );
  }

  Widget _buildDetailsSection(Launch launch) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mission Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (launch.details != null && launch.details!.isNotEmpty)
            Text(
              launch.details!,
              style: const TextStyle(fontSize: 16),
            )
          else
            const Text(
              'No details available for this mission.',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLinksSection(Launch launch) {
    final links = launch.links;
    
    if (links.webcast == null && links.article == null && links.wikipedia == null) {
      return const SizedBox.shrink();
    }
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Links',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (links.webcast != null)
                ElevatedButton.icon(
                  icon: const Icon(Icons.video_library),
                  label: const Text('Watch Webcast'),
                  onPressed: () => _launchURL(links.webcast),
                ),
              if (links.article != null)
                ElevatedButton.icon(
                  icon: const Icon(Icons.article),
                  label: const Text('Read Article'),
                  onPressed: () => _launchURL(links.article),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                ),
              if (links.wikipedia != null)
                ElevatedButton.icon(
                  icon: const Icon(Icons.public),
                  label: const Text('Wikipedia'),
                  onPressed: () => _launchURL(links.wikipedia),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRocketSection() {
    if (_rocket == null && !_isLoadingRocket) {
      return const SizedBox.shrink();
    }
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rocket',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (_isLoadingRocket)
            const Center(
              child: CircularProgressIndicator(),
            )
          else if (_rocket != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _rocket!.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Type: ${_rocket!.type}',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Status: ${_rocket!.active ? 'Active' : 'Inactive'}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _rocket!.active ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_rocket!.flickrImages.isNotEmpty)
                          CachedNetworkImage(
                            imageUrl: _rocket!.flickrImages.first,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const SizedBox(
                              width: 100,
                              height: 100,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.rocket,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _rocket!.description,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'First Flight: ${_rocket!.firstFlight}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Success Rate: ${_rocket!.successRatePercent}%',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Cost per Launch: \$${(_rocket!.costPerLaunch / 1000000).toStringAsFixed(1)} million',
                      style: const TextStyle(fontSize: 14),
                    ),
                    if (_rocket!.wikipedia != null)
                      TextButton.icon(
                        icon: const Icon(Icons.public),
                        label: const Text('More Info'),
                        onPressed: () => _launchURL(_rocket!.wikipedia),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPayloadsSection() {
    if (_payloads.isEmpty && !_isLoadingPayloads) {
      return const SizedBox.shrink();
    }
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payloads',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (_isLoadingPayloads)
            const Center(
              child: CircularProgressIndicator(),
            )
          else if (_payloads.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _payloads.length,
              itemBuilder: (context, index) {
                final payload = _payloads[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          payload.name ?? 'Unknown Payload',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (payload.type != null)
                          Text(
                            'Type: ${payload.type}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        if (payload.massKg != null)
                          Text(
                            'Mass: ${payload.massKg} kg',
                            style: const TextStyle(fontSize: 14),
                          ),
                        if (payload.orbit != null)
                          Text(
                            'Orbit: ${payload.orbit}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        if (payload.manufacturer != null)
                          Text(
                            'Manufacturer: ${payload.manufacturer}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        if (payload.customer != null)
                          Text(
                            'Customer: ${payload.customer}',
                            style: const TextStyle(fontSize: 14),
                          ),
                      ],
                    ),
                  ),
                );
              },
            )
          else
            const Text(
              'No payload information available.',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
} 