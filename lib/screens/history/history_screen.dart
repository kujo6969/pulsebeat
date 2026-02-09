import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:testing3/screens/history/widgets/history_graph.dart';
import 'package:testing3/screens/history/widgets/history_list.dart';

class HistoryScreen extends StatefulHookConsumerWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            
            indicatorColor: Colors.red,
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.list,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.area_chart,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(children: <Widget>[HistoryList(), HistoryGraph()]),
      ),
    );
  }
}
