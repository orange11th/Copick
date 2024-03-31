import 'package:dio/dio.dart';
import 'package:fe/src/services/api_service.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final int? resultIndex;

  const ResultPage({super.key, this.resultIndex});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final ApiService apiService = ApiService();
  bool isLoading = true;
  List<String>? sequenceLinks; // 이미지 URL 목록
  int? resultNormal;
  int? resultFlaw;
  String? roastingType;
  String? beanType;
  // recipeList는 이 예제에서는 사용하지 않습니다.

  @override
  void initState() {
    super.initState();
    fetchResultData();
  }

  Future<void> fetchResultData() async {
    setState(() {
      isLoading = true;
    });

    try {
      Response response =
          await apiService.get('/api/result/show/${widget.resultIndex}');
      final data = response.data;
      // JSON 형태의 데이터를 Dart 객체로 변환
      sequenceLinks = List<String>.from(data['sequenceLink']);
      resultNormal = data['resultNormal'];
      resultFlaw = data['resultFlaw'];
      roastingType = data['roastingType'];
      beanType = data['beanType'];
    } catch (e) {
      print("데이터를 받아오는데 실패했습니다: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result Page'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  if (sequenceLinks != null)
                    Container(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: sequenceLinks!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(sequenceLinks![index]),
                          );
                        },
                      ),
                    ),
                  ListTile(
                    title: const Text('Normal Result'),
                    subtitle: Text('$resultNormal'),
                  ),
                  ListTile(
                    title: const Text('Flaw Result'),
                    subtitle: Text('$resultFlaw'),
                  ),
                  ListTile(
                    title: const Text('Roasting Type'),
                    subtitle: Text(roastingType ?? 'N/A'),
                  ),
                  ListTile(
                    title: const Text('Bean Type'),
                    subtitle: Text(beanType ?? 'N/A'),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // '/page'로 이동하면서 그 이전의 모든 페이지를 스택에서 제거
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/pages', (Route<dynamic> route) => false);
        },
        tooltip: 'Go to Main Page',
        child: Icon(Icons.home),
      ),
    );
  }
}
