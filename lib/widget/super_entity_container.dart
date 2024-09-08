import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp/provider/data_provider.dart';

class SuperEntityContainer extends StatelessWidget {
  const SuperEntityContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, myType, child) {
        int entityIndex = myType.entityData.indexWhere((element) => element.id == myType.selectedEntityId);
        return Container(
          margin: const EdgeInsets.all(10),
          height: 280,
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
                "Super Entity",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: myType.selectedLibraryId != -1 && myType.selectedEntityId == -1 
                    ? const SizedBox()
                    : ListView.builder(
                        itemCount: myType.entityData[entityIndex].superEntityData.length,
                        itemBuilder: (context, index) {
                          return myType.currenState == CurrenState.superEntityEdit &&
                                  myType.superEntityEditIndex == index
                              ? Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: TextField(
                                    controller: myType.superEntityController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter super entity name',
                                      suffix: IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          myType.entityData
                                                  .where((element) => element.id == myType.selectedEntityId)
                                                  .first
                                                  .superEntityData[myType.superEntityEditIndex] =
                                              myType.entityData
                                                  .where((element) => element.id == myType.selectedEntityId)
                                                  .first
                                                  .superEntityData[myType.superEntityEditIndex]
                                                  .copyWith(
                                                    entityName: myType.superEntityController.text,
                                                    attributeData: myType.entityData
                                                        .where((element) => element.id == myType.selectedEntityId)
                                                        .first
                                                        .superEntityData[myType.superEntityEditIndex]
                                                        .attributeData,
                                                  );
                                          myType.superEntityController.clear();
                                          myType.setState(CurrenState.idle);
                                          myType.setSuperEntityEditIndex(-1);
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : (myType.entityData[entityIndex].libraryId == myType.selectedLibraryId ||
                                          myType.selectedLibraryId == -1) &&
                                      (myType.entityData[entityIndex].systemId == myType.selectedSystemId ||
                                          myType.selectedSystemId == -1)
                                  ? Container(
                                      color: myType.entityData[entityIndex].superEntityData[index].id ==
                                              myType.selectedSuperEntityId
                                          ? Colors.green.shade300
                                          : Colors.transparent,
                                      child: ListTile(
                                        title: Text(myType.entityData[entityIndex].superEntityData[index].entityName),
                                        onTap: () {
                                          myType.setLibraryId(myType.entityData[entityIndex].libraryId);
                                          myType.setSystemId(myType.entityData[entityIndex].systemId);
                                          myType.setEntityId(myType.entityData[entityIndex].id);
                                          myType.setSuperEntityId(
                                              myType.entityData[entityIndex].superEntityData[index].id);
                                        },
                                      ),
                                    )
                                  : const SizedBox();
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
