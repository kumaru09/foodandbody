import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodandbody/models/menu_show.dart';
import 'package:foodandbody/models/predict.dart';
import 'package:foodandbody/screens/camera/bloc/camera_bloc.dart';
import 'package:foodandbody/screens/camera/show_food_calory.dart';

class ShowFoodResult extends StatelessWidget {
  const ShowFoodResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraBloc, CameraState>(builder: (context, state) {
      switch (state.status) {
        case CameraStatus.failure:
          return _failureWidget(context);
        case CameraStatus.success:
          return FoodResult(allresult: state.predicts);
        default:
          return Scaffold(
            extendBody: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Center(child: CircularProgressIndicator()),
          );
      }
    });
  }

  Widget _failureWidget(BuildContext context) {
    return Center(
      child: Column(
        key: Key('body_failure_widget'),
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/error.png')),
          SizedBox(height: 10),
          Text('ไม่สามารถโหลดข้อมูลได้ในขณะนี้',
              style: Theme.of(context).textTheme.bodyText2!.merge(
                  TextStyle(color: Theme.of(context).colorScheme.secondary))),
          OutlinedButton(
            child: Text('ลองอีกครั้ง'),
            style: OutlinedButton.styleFrom(
              primary: Theme.of(context).colorScheme.secondary,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50))),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class FoodResult extends StatefulWidget {
  const FoodResult({Key? key, required this.allresult}) : super(key: key);

  final List<Predict> allresult;

  @override
  State<FoodResult> createState() => _FoodResultState();
}

class _FoodResultState extends State<FoodResult> {
  final _scrollController = ScrollController();
  late List<Predict> _allResults;
  late List<bool> _isChecked;
  List<Predict> _selectResults = [];

  @override
  void initState() {
    super.initState();
    _allResults = widget.allresult;
    _isChecked = List<bool>.generate(_allResults.length, (i) => false);
  }

  void _mapIndexFilter() {
    for (var i = 0; i < _isChecked.length; i++) {
      if (_isChecked[i] == true && !_selectResults.contains(_allResults[i]))
        _selectResults.add(_allResults[i]);
      else if (_isChecked[i] == false &&
          _selectResults.contains(_allResults[i]))
        _selectResults.remove(_allResults[i]);
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
        title: Text("${_allResults.length} ผลลัพธ์ที่ตรงกัน",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .merge(TextStyle(color: Colors.white))),
      ),
      body: _allResults.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("ไม่พบผลลัพธ์ที่ตรงกัน",
                      style: Theme.of(context).textTheme.bodyText1!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary))),
                  Text("กรุณาถ่ายใหม่",
                      style: Theme.of(context).textTheme.bodyText1!.merge(
                          TextStyle(
                              color: Theme.of(context).colorScheme.secondary))),
                ],
              ),
            )
          : SingleChildScrollView(
              child: ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: _allResults.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Color(0x21212114)))),
                      child: CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.trailing,
                        contentPadding: EdgeInsets.fromLTRB(16, 10, 10, 10),
                        title: Text(_allResults[index].name,
                            softWrap: false,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: Theme.of(context).textTheme.subtitle1!.merge(
                                TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary))),
                        activeColor: Theme.of(context).colorScheme.secondary,
                        value: _isChecked[index],
                        onChanged: (bool? value) => setState(() {
                          _isChecked[index] = value!;
                        }),
                      ),
                    );
                  }),
            ),
      bottomSheet: Padding(
        padding: EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            child: Text('${_allResults.length == 0 ? "ถ่ายใหม่" : "ตกลง"}'),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50))),
            ),
            onPressed: _allResults.length == 0
                ? () => Navigator.pop(context)
                : _isChecked.contains(true)
                    ? () async {
                        _mapIndexFilter();
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShowFoodCalory(
                                        selectResult: [..._selectResults])))
                            .then((value) {
                          if (value = true) Navigator.pop(context);
                        });
                      }
                    : null,
          ),
        ),
      ),
    );
  }
}
