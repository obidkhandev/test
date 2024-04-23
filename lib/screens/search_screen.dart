
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_pro/data/repo/file_repo.dart';

import '../data/models/file_data_model.dart';


class CustomSearchDelegate extends SearchDelegate<String> {


  CustomSearchDelegate();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          // Clear the search query.
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
      // Navigate back to the previous screen.
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Build search results based on the query.
    final List<FileDataModel> searchResults = context.read<FileRepository>().files
        .where((user) => user.fileName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(searchResults[index].fileName),

          onTap: () {
            close(context, searchResults[index].fileName);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    final List<FileDataModel> suggestionList = query.isEmpty
        ? context.read<FileRepository>().files
        : context.read<FileRepository>().files
        .where((user) => user.fileName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index].fileName),
          onTap: () {

            query = suggestionList[index].fileName;
          },
        );
      },
    );
  }
}
