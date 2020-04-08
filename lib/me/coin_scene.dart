import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';


class CoinScene extends StatefulWidget {
  @override
  _CoinSceneState createState() => new _CoinSceneState();
}

class _CoinSceneState extends State<CoinScene> {
  
  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;
  StreamSubscription _conectionSubscription;
  final List<String> _productLists = Platform.isAndroid
      ? [
          'android.test.purchased',
          'point_1000',
          '5000_point',
          'android.test.canceled',
        ]
      : ['com.cooni.point1000', 'com.cooni.point5000'];
  List<IAPItem> _items = [];
  List<PurchasedItem> _purchases = [];

  List<HistoryModel> histories = [
    HistoryModel('img/ico_gift.png', '25', '+ 5', 100.0),
    HistoryModel('img/ico_gift.png', '60',
        '+ 5', 200.0),
    HistoryModel('img/ico_gift.png', '100',
        '+ 5', 500.0),
    HistoryModel('img/ico_gift.png', '200', '+ 5',
        1000.0),
  ];

  @override
  void initState() {
    super.initState();
    initPlatformState();
    this._getProduct();
  }

  @override
  void dispose() {
    if (_conectionSubscription != null) {
      _conectionSubscription.cancel();
      _conectionSubscription = null;
    }
  }

  Future<void> initPlatformState() async {
    // prepare
    var result = await FlutterInappPurchase.instance.initConnection;
    print('result: $result');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    
        // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAllItems;
      print('consumeAllItems: $msg');
    } catch (err) {
      print('consumeAllItems error: $err');
    }

    _conectionSubscription = FlutterInappPurchase.connectionUpdated.listen((connected) {
      print('connected: $connected');
    });

    _purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      print('purchase-updated: $productItem');
    });

    _purchaseErrorSubscription = FlutterInappPurchase.purchaseError.listen((purchaseError) {
      print('purchase-error: $purchaseError');
    }); 
  }

  void _requestPurchase(IAPItem item) {
    FlutterInappPurchase.instance.requestPurchase(item.productId);
  }

  Future _getProduct() async {
    List<IAPItem> items = await FlutterInappPurchase.instance.getProducts(_productLists);
    for (var item in items) {
      print('${item.toString()}');
      this._items.add(item);
    }

    setState(() {
      this._items = items;
      this._purchases = [];
    });
  }

  List<Widget> _renderInApps() {
    List<Widget> widgets = this
    ._items
    .map((item) => Container(
        height: 100.0,
        margin: EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
          child: GestureDetector(
            onTap: () {
              this._requestPurchase(item);
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Image.asset(
                        'img/ico_gift.png',
                        height: 40.0,
                        width: 40.0,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              item.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Rs. ${item.price}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ))
    .toList();
    return widgets;
  }

  Widget _historyWidget(HistoryModel history) {
    return Container(
    height: 100.0,
    margin: EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
      child: GestureDetector(
        onTap: ()=> print("hello"),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Image.asset(
                    history.historyAssetPath,
                    height: 40.0,
                    width: 40.0,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          history.historyType,
                          style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                        ),
                        Text(history.receiverName)
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Rs. ${history.amount}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      appBar: AppBar(
        title: Text(
          "Coin",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
              child: Text(
                'Products',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
              ),
            ),
            /*
            Expanded(
              child: ListView.builder(
                  itemCount: histories.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _historyWidget(histories[index]);
                  }),
            ),
            */
            Column(
                children: this._renderInApps(),
            ),
          ],
        ),
      ),
    );

  }
}


class HistoryModel {
  final String historyAssetPath;
  final String historyType;
  final String receiverName;
  final double amount;
  
  HistoryModel(this.historyAssetPath, this.historyType, this.receiverName,
      this.amount);
}