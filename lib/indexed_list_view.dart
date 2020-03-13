import 'package:flutter/material.dart';
import 'package:flutter_alphabet_sample/utils.dart';

class IndexedListView extends StatefulWidget {

  final List items;
  final IndexedWidgetBuilder itemBuilder;
  final double itemHeight;

  IndexedListView({
    @required
    this.items,
    @required
    this.itemHeight,
    @required
    this.itemBuilder,
  });

  @override
  _IndexedListViewState createState() => _IndexedListViewState();
}

class _IndexedListViewState extends State<IndexedListView> {

  ScrollController _scrollController;

  final GlobalKey alphabetContainerKey = GlobalKey();

  String currentChar = "";

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _getAlphabetItem(String alphabet) {
    return Expanded(
      child: Text(
        alphabet,
        textAlign: TextAlign.end,
        style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w300
        ),
      ),
    );
  }

  // function to get current clicked alphabet by the user
  int _getAlphabetIndexFromDy(double dy, List<String> alphabets) {
    final alphabetContainer = alphabetContainerKey.currentContext.findRenderObject() as RenderBox;
    final alphabetContainerHeight = alphabetContainer.size.height;

    final oneItemHeight = alphabetContainerHeight / alphabets.length;

    final index = (dy / oneItemHeight).floor();
    return index;
  }

  // function to calculate alphabet dy index positions (e.g. {'A':0, 'B':8, ...})
  Map<String, int> _getAlphabetDyPositions(List items) {
    Map<String, int> alphabetDyPositions = {};
    for( var i = 0 ; i < items.length; i++ ) {
      final firstChar = items[i].toString()[0];

      if (!alphabetDyPositions.containsKey(firstChar)) {
        alphabetDyPositions[firstChar] = i;
      }
    }
    return alphabetDyPositions;
  }

  // scroll to items with the first char
  void _scrollToItems(String char, Map<String, int> alphabetDyPositions) {
    final indexToGo = alphabetDyPositions[char];
    // calculate by multiplying the index with each item height
    double dyToGo = indexToGo * widget.itemHeight;

    // if scroll is bigger than max scroll extent (e.g. overflows), then make it to max instead
    if (dyToGo >= _scrollController.position.maxScrollExtent) {
      dyToGo = _scrollController.position.maxScrollExtent;
    }

    setState(() {
      currentChar = char;
    });

    _scrollController.jumpTo(dyToGo);
  }

  // scroll to proper items with alphabets when drag started
  void _onVerticalDragStart(DragStartDetails details, List<String> alphabets, Map<String, int> alphabetDyPositions) {
    final index = _getAlphabetIndexFromDy(details.localPosition.dy, alphabets);

    final alphabet = alphabets[index];

    _scrollToItems(alphabet, alphabetDyPositions);
  }

  // scroll to proper items with alphabets when drag updated
  void _onVerticalDragUpdate(DragUpdateDetails details, List<String> alphabets,
      Map<String, int> alphabetDyPositions) {
    final index = _getAlphabetIndexFromDy(details.localPosition.dy, alphabets);

    final alphabet = alphabets[index];

    _scrollToItems(alphabet, alphabetDyPositions);
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    // clear the current selected char when drag ends.
    Future.delayed(
        Duration(milliseconds: 500),
            () {
          setState(() {
            currentChar = "";
          });
        }
    );
  }

  // main items list view
  Widget _itemsList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                controller: _scrollController,
                itemCount: widget.items.length,
                // manually set item height for scrolling calculation
                itemExtent: widget.itemHeight,
                itemBuilder: widget.itemBuilder
            ),
          ),
          _alphabeticalIndex(context, widget.items)
        ],
      ),
    );
  }

  // side alphabetical index to select
  Widget _alphabeticalIndex(BuildContext context, List items) {
    List<String> alphabets = getAlphabetsFromStringList(items.map((item) => item.toString()).toList());

    Map<String, int> alphabetDyPositions = _getAlphabetDyPositions(items);

    return LayoutBuilder(
      builder: (context, constraint) {
        if (constraint.maxHeight < 350.0) return Container(); // alphabet list does not fit, might as well hide it
        return Container(
          width: 34.0,
          key: alphabetContainerKey,
          child: GestureDetector(
            onVerticalDragUpdate: (DragUpdateDetails dragUpdateDetails)
            => _onVerticalDragUpdate(dragUpdateDetails, alphabets, alphabetDyPositions),
            onVerticalDragStart: (DragStartDetails dragStartDetails)
            => _onVerticalDragStart(dragStartDetails, alphabets, alphabetDyPositions),
            onVerticalDragEnd: _onVerticalDragEnd,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: []..addAll(
                  List.generate(
                      alphabets.length,
                          (index) => _getAlphabetItem(alphabets[index])
                  )
              ),
            ),
          ),
        );
      },
    );
  }

  // index to show when alphabet is selected
  Widget _currentCharIndex(BuildContext context) {
    return currentChar.isEmpty
        ? Container()
        : Align(
      alignment: Alignment.center,
      child: Container(
        color: Colors.black.withAlpha(80),
        padding: EdgeInsets.all(16.0),
        child: Text(
          currentChar,
          style: TextStyle(
              color: Colors.white,
              fontSize: 36.0
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _itemsList(context),
        _currentCharIndex(context)
      ],
    );
  }

}