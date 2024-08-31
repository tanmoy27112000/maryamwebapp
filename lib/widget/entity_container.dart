import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp/model/library_model.dart';
import 'package:webapp/provider/data_provider.dart';

class EntityContainer extends StatelessWidget {
  const EntityContainer({
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
                "Entity",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: myType.selectedSystemId == -1
                    ? const SizedBox()
                    : ListView.builder(
                        itemCount: myType.entityData.length,
                        itemBuilder: (context, index) {
                          return myType.currenState == CurrenState.entityEdit && myType.entityEditIndex == index
                              ? Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: TextField(
                                    controller: myType.entityController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter entity name',
                                      suffix: IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          myType.entityData[myType.entityEditIndex] =
                                              myType.entityData[myType.entityEditIndex].copyWith(
                                            entityName: myType.entityController.text,
                                            attributeData: myType.entityData[myType.entityEditIndex].attributeData,
                                          );
                                          myType.entityController.clear();
                                          myType.setState(CurrenState.idle);
                                          myType.setEntityEditIndex(-1);
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : (myType.entityData[index].libraryId == myType.selectedLibraryId ||
                                          myType.selectedLibraryId == -1) &&
                                      (myType.entityData[index].systemId == myType.selectedSystemId ||
                                          myType.selectedSystemId == -1)
                                  ? Container(
                                      color: myType.entityData[index].id == myType.selectedEntityId
                                          ? Colors.green.shade300
                                          : Colors.transparent,
                                      child: ListTile(
                                        title: Text(myType.entityData[index].entityName),
                                        onTap: () {
                                          myType.setLibraryId(myType.entityData[index].libraryId);
                                          myType.setSystemId(myType.entityData[index].systemId);
                                          myType.setEntityId(myType.entityData[index].id);
                                          myType.setSuperEntityData(index);
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
                                                myType.entityController.text = myType.entityData[index].entityName;
                                                myType.setState(CurrenState.entityEdit);
                                                myType.setEntityEditIndex(index);
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                if (myType.entityData[index].id == myType.selectedEntityId) {
                                                  myType.setEntityId(-1);
                                                }
                                                myType.entityData.removeAt(index);
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
              if (myType.currenState == CurrenState.entityAdd)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: myType.entityController,
                    decoration: InputDecoration(
                      labelText: 'Enter Entity',
                      suffix: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          myType.entityData.add(
                            EntityModel(
                              id: Random().nextInt(1000),
                              libraryId: myType.selectedLibraryId,
                              systemId: myType.selectedSystemId,
                              entityName: myType.entityController.text,
                            ),
                          );
                          myType.entityController.clear();
                          myType.setState(CurrenState.idle);
                        },
                      ),
                    ),
                  ),
                ),
              if (myType.selectedLibraryId != -1 &&
                  myType.selectedSystemId != -1 &&
                  myType.currenState != CurrenState.entityAdd)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextButton(
                    onPressed: () {
                      myType.setState(CurrenState.entityAdd);
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
