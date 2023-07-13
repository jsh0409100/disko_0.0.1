import 'package:disko_001/features/home/delegates/search_post_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../write_post/screens/widgets/select_category.dart';

class Tech {
  String label;
  bool isSelected;
  Tech(this.label, this.isSelected);
}

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  static const String routeName = "search-screen";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
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
              onTap: () {
                showSearch(context: context, delegate: SearchPostDelegate(ref));
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
              showSearch(context: context, delegate: SearchPostDelegate(ref));
            },
            icon: const Text(
              "검색",
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
