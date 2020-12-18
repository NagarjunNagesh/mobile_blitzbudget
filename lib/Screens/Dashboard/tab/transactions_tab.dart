import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:mobile_blitzbudget/Screens/Dashboard/tab/transaction_detail_tab.dart';
import 'package:mobile_blitzbudget/Screens/Dashboard/tab/wallet_tab.dart';
import 'package:mobile_blitzbudget/utils/utils.dart';
import 'package:mobile_blitzbudget/utils/widgets.dart';

class TransactionsTab extends StatefulWidget {
  static const title = 'Transactions';
  static const androidIcon = Icon(CupertinoIcons.news_solid);
  static const iosIcon = Icon(CupertinoIcons.news_solid);

  const TransactionsTab({Key key, this.androidDrawer}) : super(key: key);

  final Widget androidDrawer;

  @override
  _TransactionsTabState createState() => _TransactionsTabState();
}

class _TransactionsTabState extends State<TransactionsTab> {
  static const _itemsLength = 50;

  final _androidRefreshKey = GlobalKey<RefreshIndicatorState>();

  List<MaterialColor> colors;
  List<String> transactionNames;

  @override
  void initState() {
    _setData();
    super.initState();
  }

  void _setData() {
    colors = getRandomColors(_itemsLength);
    transactionNames = getRandomNames(_itemsLength);
  }

  Future<void> _refreshData() {
    return Future.delayed(
      /// This is just an arbitrary delay that simulates some network activity.
      const Duration(seconds: 2),
      () => setState(() => _setData()),
    );
  }

  Widget _listBuilder(BuildContext context, int index) {
    if (index >= _itemsLength) return null;

    /// Show a slightly different color palette. Show poppy-ier colors on iOS
    /// due to lighter contrasting bars and tone it down on Android.
    final color = defaultTargetPlatform == TargetPlatform.iOS
        ? colors[index]
        : colors[index].shade400;

    return SafeArea(
      top: false,
      bottom: false,
      child: Hero(
        tag: index,
        child: HeroAnimatingTransactionCard(
          transaction: transactionNames[index],
          color: color,
          heroAnimation: AlwaysStoppedAnimation(0),
          onPressed: () => Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (context) => TransactionDetailTab(
                id: index,
                transaction: transactionNames[index],
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _togglePlatform() {
    TargetPlatform _getOppositePlatform() {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        return TargetPlatform.android;
      } else {
        return TargetPlatform.iOS;
      }
    }

    debugDefaultTargetPlatformOverride = _getOppositePlatform();

    /// This rebuilds the application. This should obviously never be
    /// done in a real app but it's done here since this app
    /// unrealistically toggles the current platform for demonstration
    /// purposes.
    WidgetsBinding.instance.reassembleApplication();
  }

  /// ===========================================================================
  /// Non-shared code below because:
  /// - Android and iOS have different scaffolds
  /// - There are differenc items in the app bar / nav bar
  /// - Android has a hamburger drawer, iOS has bottom tabs
  /// - The iOS nav bar is scrollable, Android is not
  /// - Pull-to-refresh works differently, and Android has a button to trigger it too
  //
  /// And these are all design time choices that doesn't have a single 'right'
  /// answer.
  /// ===========================================================================
  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TransactionsTab.title),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async => await _androidRefreshKey.currentState.show(),
          ),
          IconButton(
            icon: Icon(Icons.shuffle),
            onPressed: _togglePlatform,
          ),
        ],
      ),
      drawer: widget.androidDrawer,
      body: RefreshIndicator(
        key: _androidRefreshKey,
        onRefresh: _refreshData,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 12),
          itemBuilder: _listBuilder,
        ),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverNavigationBar(
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.square_grid_2x2),
            onPressed: () =>

                /// This pushes the Wallets page as a full page modal dialog on top
                /// of the tab bar and everything.
                Navigator.of(context, rootNavigator: true).push<void>(
              CupertinoPageRoute(
                title: WalletTab.title,
                fullscreenDialog: true,
                builder: (context) => WalletTab(),
              ),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.shuffle),
            onPressed: _togglePlatform,
          ),
        ])),
        CupertinoSliverRefreshControl(
          onRefresh: _refreshData,
        ),
        SliverSafeArea(
          top: false,
          sliver: SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 12),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(_listBuilder),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
