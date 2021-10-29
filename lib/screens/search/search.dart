import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/models/search_result.dart';
import 'package:foodandbody/repositories/search_repository.dart';
import 'package:foodandbody/screens/menu/menu.dart';
import 'package:foodandbody/screens/search/bloc/search_bloc.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SearchBloc(searchRepository: context.read<SearchRepository>()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: SearchAppBar(),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        body: SearchBody(),
      ),
    );
  }
}

class SearchAppBar extends StatefulWidget {
  const SearchAppBar({Key? key}) : super(key: key);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  final _textController = TextEditingController();
  late SearchBloc _searchBloc;

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
    _searchBloc.add(const TextChanged(text: ''));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
      child: TextField(
        key: const Key('search_appbar_textfield'),
        controller: _textController,
        autocorrect: false,
        onChanged: (text) {
          _searchBloc.add(TextChanged(text: text));
        },
        style: Theme.of(context)
            .textTheme
            .subtitle1!
            .merge(TextStyle(color: Theme.of(context).colorScheme.secondary)),
        decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTap: _onClearTapped,
              child: Icon(Icons.clear,
                  color: Theme.of(context).colorScheme.secondary),
            ),
            hintText: 'ค้นหาเมนู',
            hintStyle: Theme.of(context)
                .textTheme
                .bodyText1!
                .merge(TextStyle(color: Color(0xFF7E7C9F))),
            border: InputBorder.none),
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
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                    builder: (context) =>
                        MenuPage(menuName: '${item.name}', isPlanMenu: false)));
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
