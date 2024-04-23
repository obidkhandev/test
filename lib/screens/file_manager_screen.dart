import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:open_filex/open_filex.dart';
import 'package:test_pro/bloc/file_manager_bloc.dart';
import 'package:test_pro/data/models/file_data_model.dart';
import 'package:test_pro/data/repo/file_repo.dart';
import 'package:test_pro/screens/search_screen.dart';

class FileManagerScreen extends StatefulWidget {
  const FileManagerScreen({super.key});

  @override
  State<FileManagerScreen> createState() => _FileManagerScreenState();
}

class _FileManagerScreenState extends State<FileManagerScreen> {
  int activeCategory = 0;
  List<String> categoryName = ["Foydali", "Badiiy", "Dasturlash", "Sarguzasht"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("File Managaer Screen"),
        backgroundColor: Color(0xff29BB89),
      ),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        Text(
          "Welcome",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        GestureDetector(
          onTap: () {
            showSearch(context: context, delegate: CustomSearchDelegate());
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(4, 4),
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12)
                ]),
            child: Row(
              children: [
                Icon(Icons.search, color: Color(0xff29BB89)),
                Text(
                  "Search for books...",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.withOpacity(0.4),
                  ),
                )
              ],
            ),
          ),
        ),
        Text(
          "Category",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 56,
          width: 50,
          child: ListView.builder(
              itemCount: categoryName.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      activeCategory = index;
                    });
                  },
                  child: CategoryItemCard(
                    categoryName: categoryName[index],
                    color: activeCategory == index
                        ? Color(0xff29BB89)
                        : Colors.grey.shade200,
                    textColor:
                        activeCategory == index ? Colors.white : Colors.black,
                  ),
                );
              }),
        ),
        Expanded(
            child: Column(
          children: List.generate(
            context
                .read<FileRepository>()
                .files
                .where((file) => categoryName[activeCategory] == file.category)
                .length,
            (index) {
              final List<FileDataModel> activeCategoryFiles = context
                  .read<FileRepository>()
                  .files
                  .where(
                      (file) => categoryName[activeCategory] == file.category)
                  .toList();
              FileDataModel fileDataModel = activeCategoryFiles[index];
              FileManagerBloc fileManagerBloc = FileManagerBloc();

              return BlocProvider.value(
                value: fileManagerBloc,
                child: BlocBuilder<FileManagerBloc, FileManagerState>(
                  builder: (context, state) {
                    debugPrint("CURRENT MB: ${state.progress}");
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: NetworkImage(fileDataModel.iconPath),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              SizedBox(width: 20),
                              SizedBox(
                                height: 150,
                                width: 150,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 40,
                                        width: 150,
                                        child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          fileDataModel.fileName,style: TextStyle(fontWeight: FontWeight.bold),),
                                      ),
                                      SizedBox(height: 20),
                                      Visibility(
                                        visible: state.progress != 0,
                                        child: LinearProgressIndicator(
                                          value: state.progress,
                                          backgroundColor: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () async {
                                  if (state.newFileLocation.isEmpty) {
                                    fileManagerBloc.add(
                                      DownloadFileEvent(
                                        fileDataModel: fileDataModel,
                                      ),
                                    );
                                  } else {
                                    await OpenFilex.open(state.newFileLocation);
                                  }
                                },
                                icon: Icon(Icons.download),
                                color: Colors.blue,
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        )),
      ]),
    );
  }
}

class CategoryItemCard extends StatelessWidget {
  final String categoryName;
  final Color color;
  final Color textColor;

  const CategoryItemCard(
      {super.key,
      required this.categoryName,
      required this.color,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      // height: ,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 5),
      // width: 70,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(25)),
      child: Text(
        categoryName,
        style: TextStyle(color: textColor),
      ),
    );
  }
}
