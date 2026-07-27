import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/search/search.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;

  final List<String> _recentSearches = [];

  static const List<String> _availableSuggestions = [
    'Restaurant',
    'Rest',
    'Greetings',
    'Food and Drinks',
    'Thai Pronunciation',
    'Self-Introduction',
  ];

  String _query = '';

  List<String> get _suggestions {
    if (_query.trim().isEmpty) {
      return [];
    }

    return _availableSuggestions
        .where((suggestion) {
          return suggestion.toLowerCase().contains(
            _query.trim().toLowerCase(),
          );
        })
        .take(5)
        .toList();
  }

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
  }

  void _submitSearch(String value) {
    final query = value.trim();

    if (query.isEmpty) {
      return;
    }

    if (!_recentSearches.contains(query)) {
      setState(() {
        _recentSearches.insert(0, query);
      });
    }

    _searchFocusNode.unfocus();

    context.push(
      Routes.searchResults,
      extra: query,
    );
  }

  void _handleClose() {
    if (_searchController.text.isNotEmpty) {
      _searchController.clear();

      setState(() {
        _query = '';
      });

      _searchFocusNode.requestFocus();
      return;
    }

    context.pop();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorUtils.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  28,
                  16,
                  110,
                ),
                child: _query.isEmpty
                    ? RecentSearchesView(
                        searches: _recentSearches,
                        onSelected: (value) {
                          _searchController.text = value;
                          _submitSearch(value);
                        },
                      )
                    : SearchSuggestionsView(
                        suggestions: _suggestions,
                        onSelected: (value) {
                          _searchController.text = value;
                          _submitSearch(value);
                        },
                      ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: SearchInputBar(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: (value) {
                  setState(() {
                    _query = value;
                  });
                },
                onSubmitted: _submitSearch,
                onClose: _handleClose,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecentSearchesView extends StatelessWidget {
  final List<String> searches;
  final ValueChanged<String> onSelected;

  const RecentSearchesView({
    super.key,
    required this.searches,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TtText(
          'Recent Searches',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        28.gh,
        if (searches.isEmpty)
          const Center(
            child: TtText(
              'You have no recent searches.',
              fontSize: 14,
              color: ColorUtils.greyTextColor,
            ),
          )
        else
          ...List.generate(
            searches.length,
            (index) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.history_rounded,
                  color: ColorUtils.greyTextColor,
                ),
                title: TtText(
                  searches[index],
                  fontSize: 14,
                ),
                onTap: () {
                  onSelected(searches[index]);
                },
              );
            },
          ),
      ],
    );
  }
}

class SearchSuggestionsView extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String> onSelected;

  const SearchSuggestionsView({
    super.key,
    required this.suggestions,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return const Center(
        child: TtText(
          'No matching keywords found.',
          fontSize: 14,
          color: ColorUtils.greyTextColor,
        ),
      );
    }

    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color(0xFFE1E5EA),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          suggestions.length,
              (index) {
            final suggestion = suggestions[index];

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.search_rounded,
                    color: ColorUtils.primaryColor,
                  ),
                  title: TtText(
                    suggestion,
                    fontSize: 14,
                    color: ColorUtils.greyTextColor,
                  ),
                  onTap: () {
                    onSelected(suggestion);
                  },
                ),
                if (index != suggestions.length - 1)
                  const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: Color(0xFFE8EBEF),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
