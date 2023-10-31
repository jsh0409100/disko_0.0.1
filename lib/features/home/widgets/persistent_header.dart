import 'package:flutter/material.dart';

class PersistentHeaderList extends SliverPersistentHeaderDelegate {
  final List<Widget> widget;

  PersistentHeaderList({required this.widget});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      width: double.infinity,
      height: 100.0,
      child: ListView(scrollDirection: Axis.horizontal,children: widget,),     );
  }

  @override
  double get maxExtent => 56.0;

  @override
  double get minExtent => 56.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}