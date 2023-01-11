import 'package:flutter/material.dart';

import '../write_post_screen/widgets/select_category.dart';

class Tech {
  String label;
  bool isSelected;
  Tech(this.label, this.isSelected);
}

class search extends StatefulWidget {
  const search({Key? key}) : super(key: key);

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
  bool selected = false;
  final List<Tech> _chipsList = [
    Tech('유학생활', false),
    Tech('현지생활', false),
    Tech('중고거래', false),
    Tech('요리', false),
    Tech('직장생활', false),
    Tech('고민상담', false),
    Tech('교통 / 날씨', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          height: MediaQuery.of(context).size.height / 20,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFFF1F1F1),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 4),
            child: TextField(
              keyboardType: TextInputType.text,
              onChanged: (text) {
                //_streamSearch.add(text);
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              /*
                showSearch(
                    context: context,
                    delegate: MysearchDelegate(),
                );
                 */
            },
            icon: const Text(
              "취소",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Wrap(
                  spacing: 8,
                  direction: Axis.horizontal,
                  children: techChips(),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(40, 18, 18, 10),
                child: Text(
                  "바로가기",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Center(
                    child: CategoryCards(selected: 0),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> techChips() {
    List<Widget> chips = [];
    for (int i = 0; i < _chipsList.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 10, right: 5),
        child: FilterChip(
          shape: const StadiumBorder(side: BorderSide(width: 0.5)),
          label: Text(_chipsList[i].label),
          labelStyle: const TextStyle(color: Colors.black),
          backgroundColor: Theme.of(context).colorScheme.background,
          selectedColor: Theme.of(context).colorScheme.primary,
          selected: _chipsList[i].isSelected,
          onSelected: (bool value) {
            setState(() {
              _chipsList[i].isSelected = value;
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }
}

class MysearchDelegate extends SearchDelegate {
  List<String> searchResults = [
    '이스라엘',
    '유학생활',
    '요리',
    '중고거래',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        },
      );

  @override
  Widget buildResults(BuildContext context) => Center(
        child: Text(
          query,
          style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
        ),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestion = searchResults.where((searchResults) {
      final result = searchResults.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: suggestion.length,
      itemBuilder: (context, index) {
        final suggestions = suggestion[index];

        return ListTile(
          title: Text(suggestions),
          onTap: () {
            query = suggestions;
            showResults(context);
          },
        );
      },
    );
  }
}
