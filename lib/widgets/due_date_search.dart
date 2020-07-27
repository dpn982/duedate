import 'package:duedate/db/search_bloc.dart';
import 'package:duedate/models/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DueDateSearch extends SearchDelegate<Payment> {
  final SearchBloc searchBloc = SearchBloc();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchBloc.searchTerm.add(query);


    return StreamBuilder(
      stream: searchBloc.searchResults,
      builder: (context, AsyncSnapshot<List<Payment>> snapshot) {
        if (!snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(child: CircularProgressIndicator()),
            ],
          );
        } else if (snapshot.data.length == 0) {
          return Column(
            children: <Widget>[
              Center(
                child: Text(
                  "No Results Found.",
                ),
              ),
            ],
          );
        } else {
          var results = snapshot.data;
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              var result = snapshot.data[index];
              return Container(
                child: Card(
                  child: ListTile(
                    title: Text(result.name),
                    onTap: () {

                    },
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
