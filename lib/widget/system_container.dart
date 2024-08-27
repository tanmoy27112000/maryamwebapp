import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp/model/library_model.dart';
import 'package:webapp/provider/data_provider.dart';

class SystemContainer extends StatelessWidget {
  const SystemContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, myType, child) {
        return Container(
          margin: const EdgeInsets.all(10),
          height: 300,
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
                "System",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: myType.systemData.length,
                  itemBuilder: (context, index) {
                    return myType.currenState == CurrenState.systemEdit && myType.systemEditIndex == index
                        ? Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                              controller: myType.systemController,
                              decoration: InputDecoration(
                                hintText: 'Enter system',
                                suffix: IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    myType.systemData[myType.systemEditIndex] =
                                        myType.systemData[myType.systemEditIndex].copyWith(
                                      systemName: myType.systemController.text,
                                    );
                                    myType.systemController.clear();
                                    myType.setState(CurrenState.idle);
                                    myType.setSystemEditIndex(-1);
                                  },
                                ),
                              ),
                            ),
                          )
                        : myType.systemData[index].libraryId == myType.selectedLibraryId ||
                                myType.selectedLibraryId == -1
                            ? Container(
                                color: myType.systemData[index].id == myType.selectedSystemId
                                    ? Colors.green.shade300
                                    : Colors.transparent,
                                child: ListTile(
                                  title: Text(myType.systemData[index].systemName),
                                  onTap: () {
                                    myType.setLibraryId(myType.systemData[index].libraryId);
                                    myType.setSystemId(myType.systemData[index].id);
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
                                          myType.systemController.text = myType.systemData[index].systemName;
                                          myType.setState(CurrenState.systemEdit);
                                          myType.setSystemEditIndex(index);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          if (myType.systemData[index].id == myType.selectedSystemId) {
                                            myType.setSystemId(-1);
                                          }
                                          myType.systemData.removeAt(index);
                                          myType.setState(CurrenState.idle);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox();
                  },
                ),
              ),
              if (myType.currenState == CurrenState.systemAdd)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: myType.systemController,
                    decoration: InputDecoration(
                      labelText: 'Enter System',
                      suffix: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          myType.systemData.add(
                            SystemModel(
                              id: Random().nextInt(1000),
                              libraryId: myType.selectedLibraryId,
                              systemName: myType.systemController.text,
                            ),
                          );
                          myType.systemController.clear();
                          myType.setState(CurrenState.idle);
                        },
                      ),
                    ),
                  ),
                ),
              if (myType.selectedLibraryId != -1 && myType.currenState != CurrenState.systemAdd)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextButton(
                    onPressed: () {
                      myType.setState(CurrenState.systemAdd);
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
