import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/launches_provider.dart';
import '../widgets/launch_list_item.dart';
import '../widgets/launch_filter.dart';
import 'launch_details_screen.dart';

class LaunchesScreen extends StatefulWidget {
  const LaunchesScreen({Key? key}) : super(key: key);

  @override
  State<LaunchesScreen> createState() => _LaunchesScreenState();
}

class _LaunchesScreenState extends State<LaunchesScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch launches when the screen is first loaded
    Future.microtask(() {
      Provider.of<LaunchesProvider>(context, listen: false).fetchLaunches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpaceX Launches'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<LaunchesProvider>(context, listen: false).fetchLaunches();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Consumer<LaunchesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.launches.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error.isNotEmpty && provider.launches.isEmpty) {
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
                    'Error loading launches',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.error,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.fetchLaunches();
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          final launches = provider.filteredLaunches;

          if (launches.isEmpty) {
            return Column(
              children: [
                const LaunchFilter(),
                Expanded(
                  child: Center(
                    child: Text(
                      'No launches found with the current filters',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              const LaunchFilter(),
              if (provider.isLoading)
                const LinearProgressIndicator(
                  minHeight: 2,
                ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => provider.fetchLaunches(),
                  child: ListView.builder(
                    itemCount: launches.length,
                    itemBuilder: (context, index) {
                      final launch = launches[index];
                      return LaunchListItem(
                        launch: launch,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LaunchDetailsScreen(
                                launchId: launch.id,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
} 