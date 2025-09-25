import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/location_search_model.dart';
import '../../core/providers/location_search_provider.dart';
import '../../core/localization/localization_extension.dart';
import '../booking/ride_booking_page.dart';

class LocationSearchDelegate extends SearchDelegate<LocationSearchModel?> {
  LocationSearchDelegate._({required String searchLabel})
      : super(
          searchFieldLabel: searchLabel,
          searchFieldStyle: const TextStyle(
            color: Colors.white, // Keep white for AppBar contrast
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  // Factory method to create localized delegate
  factory LocationSearchDelegate.localized(BuildContext context) {
    return LocationSearchDelegate._(
      searchLabel: context.l10n.searchForPlaces,
    );
  }

  @override
  void showResults(BuildContext context) {
    // Force focus on the search field when showing results
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
    // Override to ensure search field stays focused
    showSuggestions(context);
  }

  @override
  void showSuggestions(BuildContext context) {
    // Ensure focus is on search field when showing suggestions
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
    super.showSuggestions(context);
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary, // Use theme-aware color
        elevation: 4,
        titleTextStyle: TextStyle(
          color: theme.colorScheme.onPrimary, // Use theme-aware color
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: TextStyle(
          color: theme.colorScheme.onPrimary, // Use theme-aware color
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: theme.colorScheme.onPrimary
              .withOpacity(0.7), // Use theme-aware color
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        // Add autofocus configuration
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: theme.colorScheme.onPrimary, // Use theme-aware color
        selectionColor: theme.colorScheme.onPrimary.withOpacity(0.3),
        selectionHandleColor: theme.colorScheme.onPrimary,
      ),
      // Ensure text field gets focus
      visualDensity: VisualDensity.compact,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon:
              Icon(Icons.clear, color: Theme.of(context).colorScheme.onPrimary),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back,
          color: Theme.of(context).colorScheme.onPrimary),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Always show suggestions instead of results to keep the search active
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchContent(context, isResults: false);
  }

  Widget _buildSearchContent(BuildContext context, {required bool isResults}) {
    return Consumer<LocationSearchProvider>(
      builder: (context, provider, child) {
        // Trigger search when query changes (both for results and suggestions)
        if (query.isNotEmpty && query != provider.currentQuery) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            provider.searchLocations(query, context);
          });
        }

        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              // Quick filters only when not searching
              if (query.isEmpty) _buildQuickFilters(context, provider),

              // Search results or suggestions
              Expanded(
                child: _buildResultsList(context, provider, isResults),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickFilters(
      BuildContext context, LocationSearchProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.quickSearch,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: LocationType.values.map((type) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(type.getLocalizedName(context)),
                    avatar: Icon(type.icon, size: 16),
                    onSelected: (selected) {
                      if (selected) {
                        query = type.getLocalizedName(context).toLowerCase();
                        showResults(context);
                      }
                    },
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceVariant,
                    selectedColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    checkmarkColor: Theme.of(context).colorScheme.primary,
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList(
      BuildContext context, LocationSearchProvider provider, bool isResults) {
    if (provider.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.searchingLocations,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
            ),
          ],
        ),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              provider.error!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.searchLocations(query, context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: Text(context.l10n.tryAgain),
            ),
          ],
        ),
      );
    }

    // Show search results when there's a query
    if (query.isNotEmpty && provider.hasResults) {
      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: provider.searchResults.length,
        itemBuilder: (context, index) {
          final location = provider.searchResults[index];
          return _buildLocationTile(context, location, provider);
        },
      );
    }

    // Show suggestions (recent searches and saved places) when no query
    if (query.isEmpty) {
      return _buildSuggestions(context, provider);
    }

    // Empty state when searching but no results
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          Text(
            isResults
                ? context.l10n.noLocationsFound
                : context.l10n.startTypingToSearch,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
          ),
          if (isResults) ...[
            const SizedBox(height: 8),
            Text(
              context.l10n.tryDifferentSearchTerm,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestions(
      BuildContext context, LocationSearchProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Saved places
          if (provider.savedPlaces.isNotEmpty) ...[
            _buildSectionTitle(context, context.l10n.savedPlaces),
            const SizedBox(height: 8),
            ...provider.savedPlaces
                .map((place) => _buildLocationTile(context, place, provider)),
            const SizedBox(height: 24),
          ],

          // Recent searches
          if (provider.recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionTitle(context, context.l10n.recentSearches),
                TextButton(
                  onPressed: () => provider.clearRecentSearches(),
                  child: Text(
                    context.l10n.clear,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...provider.recentSearches
                .map((place) => _buildLocationTile(context, place, provider)),
          ],

          // Default suggestions if no saved/recent
          if (provider.savedPlaces.isEmpty &&
              provider.recentSearches.isEmpty) ...[
            _buildSectionTitle(context, context.l10n.popularPlaces),
            const SizedBox(height: 8),
            _buildPopularPlaces(context),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }

  Widget _buildLocationTile(BuildContext context, LocationSearchModel location,
      LocationSearchProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            location.type.icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          location.name,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location.displayAddress,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (location.rating != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 14,
                    color: Colors.amber[700],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    location.rating!.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                          fontSize: 11,
                        ),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            provider.isPlaceSaved(location.placeId)
                ? Icons.bookmark
                : Icons.bookmark_border,
            color: provider.isPlaceSaved(location.placeId)
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            size: 20,
          ),
          onPressed: () => provider.toggleSavedPlace(location),
        ),
        onTap: () async {
          // If this is from a Google Places prediction, fetch full details
          if (location.placeId.isNotEmpty) {
            try {
              final searchProvider = context.read<LocationSearchProvider>();
              final detailedPlace = await searchProvider.getPlaceDetails(
                  location.placeId, context);

              if (detailedPlace != null && context.mounted) {
                provider.addToRecentSearches(detailedPlace);

                // Navigate to booking page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RideBookingPage(destination: detailedPlace),
                  ),
                );
                return;
              }
            } catch (e) {
              // Fall back to original location if details fetch fails
            }
          }

          if (context.mounted) {
            provider.addToRecentSearches(location);

            // Navigate to booking page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RideBookingPage(destination: location),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildPopularPlaces(BuildContext context) {
    final popularPlaces = [
      context.l10n.airport,
      context.l10n.mall,
      context.l10n.hospital,
      context.l10n.university,
      context.l10n.restaurant,
      context.l10n.gasStation,
    ];

    return Column(
      children: popularPlaces.map((place) {
        return ListTile(
          leading: Icon(
            Icons.trending_up,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: Text(place),
          onTap: () {
            query = place;
            showResults(context);
          },
        );
      }).toList(),
    );
  }
}
