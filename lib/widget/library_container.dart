import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp/model/library_model.dart';
import 'package:webapp/provider/data_provider.dart';

class LibraryContainer extends StatelessWidget {
  const LibraryContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, myType, child) {
        return Container(
          height: 300,
          margin: const EdgeInsets.all(10),
          width: 200,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey,
              width: 2,
            ),
          ),
          child: Column(
            children: <Widget>[
              const Text(
                "Library",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: myType.libraryData.length,
                  itemBuilder: (context, index) {
                    return myType.currenState == CurrenState.libraryEdit && myType.libraryEditIndex == index
                        ? Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                              controller: myType.libraryController,
                              decoration: InputDecoration(
                                labelText: 'Enter Library',
                                suffix: IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    myType.libraryData[myType.libraryEditIndex] =
                                        myType.libraryData[myType.libraryEditIndex].copyWith(
                                      libraryName: myType.libraryController.text,
                                    );
                                    myType.libraryController.clear();
                                    myType.setState(CurrenState.idle);
                                    myType.setLibraryEditIndex(-1);
                                  },
                                ),
                              ),
                            ),
                          )
                        : Container(
                            color: myType.libraryData[index].id == myType.selectedLibraryId
                                ? Colors.green.shade300
                                : Colors.transparent,
                            child: ListTile(
                              title: Text(myType.libraryData[index].libraryName),
                              onTap: () {
                                myType.setLibraryId(myType.libraryData[index].id);
                                myType.setSystemId(-1);
                                myType.setEntityId(-1);
                                myType.setSuperEntityId(-1);
                              },
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min, // this line is extr
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      myType.libraryController.text = myType.libraryData[index].libraryName;
                                      myType.setState(CurrenState.libraryEdit);
                                      myType.setLibraryEditIndex(index);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      if (myType.libraryData[index].id == myType.selectedLibraryId) {
                                        myType.setLibraryId(-1);
                                      }
                                      myType.libraryData.removeAt(index);
                                      myType.setState(CurrenState.idle);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                  },
                ),
              ),
              if (myType.currenState == CurrenState.libraryAdd)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: myType.libraryController,
                    decoration: InputDecoration(
                      labelText: 'Enter Library',
                      suffix: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          myType.libraryData.add(
                            LibraryModel(
                              id: Random().nextInt(1000),
                              libraryName: myType.libraryController.text,
                            ),
                          );
                          myType.libraryController.clear();
                          myType.setState(CurrenState.idle);
                        },
                      ),
                    ),
                  ),
                ),
              //if (myType.currenState != CurrenState.idle &&
              //myType.selectedLibraryId != -1)
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextButton(
                  onPressed: () {
                    myType.setState(CurrenState.libraryAdd);
                  },
                  child: const Text(
                    "Add",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
