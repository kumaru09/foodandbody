import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/models/search_result.dart';
import 'package:foodandbody/repositories/search_repository.dart';
import 'package:foodandbody/screens/menu/menu.dart';
import 'package:foodandbody/screens/search/bloc/search_bloc.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SearchBloc(searchRepository: context.read<SearchRepository>()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: SearchAppBar(),
        body: SearchBody(),
      ),
    );
  }
}

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  const SearchAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  final _textController = TextEditingController();
  late SearchBloc _searchBloc;
  String _lastText = '';
  List<String> _filterList = ['แกง', 'ผัด', 'ยำ', 'ทอด'];
  late List<bool> _isChecked = List<bool>.generate(_filterList.length, (i) => false);

  @override
  void initState() {
    super.initState();
    _searchBloc = context.read<SearchBloc>();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onClearTapped() {
    _textController.text = '';
    _lastText = '';
    _searchBloc.add(TextChanged(text: ''));
  }

  _onSelectFilter(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
        side: BorderSide(color: Colors.white, width: 3),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              title: Text(
                'ชนิดอาหาร',
                style: Theme.of(context).textTheme.subtitle1!.merge(
                    TextStyle(color: Theme.of(context).colorScheme.secondary)),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Divider(
                color: Color(0x21212114),
                thickness: 1,
              ),
            ),
            StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: _filterList.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.trailing,
                    title: Text(
                      '${_filterList[index]}',
                      style: Theme.of(context).textTheme.subtitle1!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary)),
                    ),
                    activeColor: Theme.of(context).colorScheme.secondary,
                    value: _isChecked[index],
                    onChanged: (bool? value) =>
                        setState(() => _isChecked[index] = value!),
                  );
                },
              );
            }),
            Padding(
              padding: EdgeInsets.only(bottom: 14),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    primary: Theme.of(context).primaryColor,
                    fixedSize: Size(182, 39),
                  ),
                  onPressed: () {
                    print('isCheck: $_isChecked'); //filter
                    // _searchBloc.add(TextChanged(text: text));
                    Navigator.pop(context);
                  },
                  child: Text(
                    "ค้นหา",
                    style: Theme.of(context).textTheme.button!.merge(
                          TextStyle(color: Colors.white),
                        ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextField(
        key: const Key('search_appbar_textfield'),
        controller: _textController,
        autocorrect: false,
        onChanged: (text) {
          if (_lastText != text) {
            _lastText = text;
            print('isCheck: $_isChecked'); //filter
            _searchBloc.add(TextChanged(text: text));
          }
        },
        style: Theme.of(context)
            .textTheme
            .subtitle1!
            .merge(TextStyle(color: Theme.of(context).colorScheme.secondary)),
        decoration: InputDecoration(
            hintText: 'ค้นหาเมนู',
            hintStyle: Theme.of(context)
                .textTheme
                .bodyText1!
                .merge(TextStyle(color: Color(0xFF7E7C9F))),
            border: InputBorder.none),
      ),
      actions: [
        IconButton(
          onPressed: _onClearTapped,
          icon:
              Icon(Icons.clear, color: Theme.of(context).colorScheme.secondary),
        ),
        IconButton(
          onPressed: () => _onSelectFilter(context),
          icon: Icon(Icons.filter_list,
              color: Theme.of(context).colorScheme.secondary),
        ),
      ],
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back,
            color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}

class SearchBody extends StatefulWidget {
  const SearchBody({Key? key}) : super(key: key);

  @override
  _SearchBodyState createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  final _scrollController = ScrollController();
  late SearchBloc _searchBloc;

  @override
  void initState() {
    super.initState();
    _searchBloc = context.read<SearchBloc>();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) _searchBloc.add(TextChanged(text: _searchBloc.keySearch));
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
      switch (state.status) {
        case SearchStatus.loading:
          return Center(child: const CircularProgressIndicator());
        case SearchStatus.failure:
          return Center(
              child: Text('failed to fetch menu',
                  style: Theme.of(context).textTheme.subtitle1!.merge(TextStyle(
                      color: Theme.of(context).colorScheme.secondary))));
        case SearchStatus.success:
          return state.result.isEmpty
              ? Center(
                  child: Text(
                    'ไม่พบผลลัพธ์ที่ตรงกัน',
                    style: Theme.of(context).textTheme.subtitle1!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.secondary)),
                  ),
                )
              : SafeArea(
                  child: ListView.builder(
                    itemCount: state.hasReachedMax
                        ? state.result.length
                        : state.result.length + 1,
                    controller: _scrollController,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemBuilder: (BuildContext context, int index) {
                      return index >= state.result.length
                          ? const SizedBox(
                              height: 56,
                              width: double.infinity,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : _SearchResultItem(item: state.result[index]);
                    },
                  ),
                );
        default:
          return Center(
            child: Text(
              'กรุณาใส่ชื่อเมนูเพื่อค้นหา',
              style: Theme.of(context).textTheme.subtitle1!.merge(
                  TextStyle(color: Theme.of(context).colorScheme.secondary)),
            ),
          );
      }
    });
  }
}

class _SearchResultItem extends StatelessWidget {
  const _SearchResultItem({Key? key, required this.item}) : super(key: key);

  final SearchResultItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          minVerticalPadding: 16,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text('${item.name}',
                    style: Theme.of(context).textTheme.subtitle1!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.secondary))),
              ),
              Text('${item.calory} ',
                  style: Theme.of(context).textTheme.headline6!.merge(TextStyle(
                      color: Theme.of(context).colorScheme.secondary))),
              Text('แคล',
                  style: Theme.of(context).textTheme.caption!.merge(TextStyle(
                      color: Theme.of(context).colorScheme.secondary))),
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MenuPage.menu(menuName: item.name)));
          },
        ),
        const Divider(
          height: 2,
          thickness: 1,
        ),
      ],
    );
  }
}
