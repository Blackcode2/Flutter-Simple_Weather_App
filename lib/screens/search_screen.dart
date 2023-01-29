import 'package:flutter/material.dart';
// need to be updated in version 1.2.0
class Search extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return <Widget>[
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.close)
      )
    ];
    throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back)
    );
    throw UnimplementedError();
  }

  String _selectResult = '';

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Container(
      child: Center(
        child: Text(_selectResult),
      ),
    );
    throw UnimplementedError();
  }

  final List<String> _listExample = ["hi"];
  final List<String> _recentList = ["Text 4", "Text 3"];

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    List<String> _suggestionList = [];
    query.isEmpty
      ? _suggestionList = _recentList
      : _suggestionList
          .addAll(_listExample.where((element) => element.contains(query)));
    
    return ListView.builder(
        itemCount: _suggestionList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_suggestionList[index]),
            leading: query.isEmpty ? const Icon(Icons.access_time) : const SizedBox(),
            onTap: () {
              _selectResult = _suggestionList[index];
              showResults(context);
            },
          );
        }
    );
    throw UnimplementedError();
  }
  
}