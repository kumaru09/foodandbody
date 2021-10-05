import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/models/search_result.dart';
import 'package:foodandbody/repositories/search_reository.dart';
import 'package:foodandbody/screens/menu/menu.dart';
import 'package:foodandbody/screens/search/bloc/search_bloc.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  // final GithubRepository githubRepository;

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
        body: _SearchBody(),
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
            hintStyle: Theme.of(context).textTheme.bodyText1!.merge(TextStyle(
                      color: Color(0xFF7E7C9F))),
            border: InputBorder.none),
      ),
    );
  }
}

class _SearchBody extends StatelessWidget {
  const _SearchBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
      if (state is SearchStateLoading) {
        return Center(child: const CircularProgressIndicator());
      }
      if (state is SearchStateError) {
        return Center(child: Text(state.error));
      }
      if (state is SearchStateSuccess) {
        return state.items.isEmpty
            ? Center(
                child: Text(
                  'ไม่พบผลลัพธ์ที่ตรงกัน',
                  style: Theme.of(context).textTheme.subtitle1!.merge(TextStyle(
                      color: Theme.of(context).colorScheme.secondary)),
                ),
              )
            : _SearchResult(items: state.items);
      }
      return Center(
        child: Text(
          'กรุณาใส่ชื่อเมนูเพื่อค้นหา',
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .merge(TextStyle(color: Theme.of(context).colorScheme.secondary)),
        ),
      );
    });
  }
}

class _SearchResult extends StatelessWidget {
  const _SearchResult({Key? key, required this.items}) : super(key: key);

  final List<SearchResultItem> items;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return _SearchResultItem(item: items[index]);
        },
      ),
    );
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
                    builder: (context) => Menu(
                        menuName: '${item.name}',
                        menuImg:
                            'https://bnn.blob.core.windows.net/food/grilled-shrimp.jpg')));
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
