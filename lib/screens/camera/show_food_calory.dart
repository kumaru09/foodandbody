import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/models/menu_show.dart';
import 'package:foodandbody/repositories/camera_repository.dart';
import 'package:foodandbody/screens/camera/bloc/camera_bloc.dart';

class ShowFoodCalory extends StatefulWidget {
  const ShowFoodCalory({Key? key, required this.selectResult})
      : super(key: key);

  final List<MenuShow> selectResult;

  @override
  _ShowFoodCaloryState createState() => _ShowFoodCaloryState();
}

class _ShowFoodCaloryState extends State<ShowFoodCalory> {
  final _scrollController = ScrollController();
  late List<MenuShow> _finalResults;
  int _totalCal = 0;

  @override
  void initState() {
    super.initState();
    _finalResults = widget.selectResult;
    for (var item in widget.selectResult) {
      _totalCal += item.calory;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "แคลอรี",
          style: Theme.of(context)
              .textTheme
              .headline6!
              .merge(TextStyle(color: Colors.white)),
        ),
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
            shrinkWrap: true,
            controller: _scrollController,
            itemCount: _finalResults.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0x21212114),
                    ),
                  ),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.zero,
                          child: Text(
                            _finalResults[index].name,
                            softWrap: false,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.subtitle1!.merge(
                                TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.zero,
                          child: RichText(
                            textAlign: TextAlign.right,
                            text: TextSpan(children: [
                              TextSpan(
                                  text:
                                      "${_finalResults[index].calory.round()}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .merge(TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary))),
                              TextSpan(
                                text: " แคล",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .merge(TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                              )
                            ]),
                          ),
                        ),
                      )
                    ],
                  ),
                  trailing: IconButton(
                      iconSize: 24,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: () async {
                        final value = await showDialog<String>(
                          context: context,
                          builder: (BuildContext context) =>
                              BlocProvider<CameraBloc>(
                            create: (_) => CameraBloc(
                                cameraRepository:
                                    context.read<CameraRepository>()),
                            child: EditCalDialog(
                                value: _finalResults[index].calory.toString()),
                          ),
                        );
                        if (value != 'cancel' && value != null) {
                          setState(() {
                            //คำนวน totalCal ใหม่
                            _totalCal = _totalCal -
                                _finalResults[index].calory +
                                int.parse(value);
                            //เปลี่ยน cal ของเมนู ยังไม่ได้คำนวน carb protine fat ใหม่
                            _finalResults[index] = MenuShow(
                              name: _finalResults[index].name,
                              calory: int.parse(value), //cal ใหม่
                              carb: _finalResults[index].carb,
                              fat: _finalResults[index].fat,
                              protein: _finalResults[index].protein,
                            );
                            print('--- _totalCal2: $_totalCal');
                          });
                        }
                      }),
                ),
              );
            }),
      ),
      bottomSheet: Container(
        color: Theme.of(context).primaryColor,
        width: MediaQuery.of(context).size.width,
        height: 56,
        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "แคลอรี่รวม",
              style: Theme.of(context).textTheme.headline6!.merge(
                    TextStyle(color: Colors.white),
                  ),
            ),
            Expanded(
              child: Text(
                "$_totalCal",
                softWrap: false,
                maxLines: 1,
                textAlign: TextAlign.right,
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .merge(TextStyle(color: Colors.white)),
              ),
            ),
            Text(
              " แคล ",
              style: Theme.of(context).textTheme.bodyText2!.merge(
                    TextStyle(color: Colors.white),
                  ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                "ตกลง",
                style: Theme.of(context).textTheme.button!.merge(
                      TextStyle(color: Theme.of(context).primaryColor),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditCalDialog extends StatelessWidget {
  const EditCalDialog({Key? key, required this.value}) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: const Key("edit_cal_dialog"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text("แก้ไขเแคลอรี่",
          style: Theme.of(context).textTheme.subtitle1!.merge(
              TextStyle(color: Theme.of(context).colorScheme.secondary))),
      content: BlocBuilder<CameraBloc, CameraState>(
          buildWhen: (previous, current) => previous.cal != current.cal,
          builder: (context, state) {
            return TextFormField(
              key: const Key("edit_cal_textFormField"),
              initialValue: value,
              onChanged: (cal) =>
                  context.read<CameraBloc>().add(CalChanged(value: cal)),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                errorText:
                    state.cal.invalid ? 'กรุณาระบุแคลอรีให้ถูกต้อง' : null,
              ),
            );
          }),
      actions: <Widget>[
        TextButton(
            key: const Key("edit_cal_dialog_cancel_button"),
            onPressed: () {
              Navigator.pop(context, 'cancel');
            },
            child: Text("ยกเลิก",
                style: Theme.of(context).textTheme.button!.merge(TextStyle(
                    color: Theme.of(context).colorScheme.secondary)))),
        BlocBuilder<CameraBloc, CameraState>(
            buildWhen: (previous, current) => previous.cal != current.cal,
            builder: (context, state) {
              return TextButton(
                key: const Key("edit_cal_dialog_save_button"),
                onPressed: state.cal.valid
                    ? () => Navigator.pop(context, state.cal.value)
                    : null,
                child: Text("ตกลง"),
                style: TextButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondary,
                  onSurface: Theme.of(context)
                      .colorScheme
                      .secondaryVariant, // Disable color
                ),
              );
            }),
      ],
    );
  }
}
