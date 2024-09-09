import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp/model/library_model.dart';
import 'package:webapp/provider/data_provider.dart';

class AttributeContainerV2 extends StatelessWidget {
  const AttributeContainerV2({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        int entityIndex = dataProvider.entityData.indexWhere(
          (element) => element.id == dataProvider.selectedEntityId,
        );
        bool isSuperEntitySelected = dataProvider.selectedSuperEntityId != -1;
        return Container(
          margin: const EdgeInsets.all(10),
          width: 300,
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
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dataProvider.superEntityData.length,
                itemBuilder: (context, index) {
                  return dataProvider.currenState == CurrenState.superEntityEdit &&
                          dataProvider.superEntityEditIndex == index
                      ? const Padding(
                          padding: EdgeInsets.all(10),
                        )
                      : shouldShowSuperEntity(index, dataProvider)
                          ? ListTile(
                              title: Text(dataProvider.superEntityData[index].entityName),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      // Show dialog to edit super entity
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                            title: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text("Change Super Entity"),
                                                // Close button
                                                IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  ...dataProvider.getEntityList(entityIndex).map(
                                                    (e) {
                                                      return ListTile(
                                                        title: Text(e.entityName),
                                                        onTap: () {
                                                          // Replace the existing super entity
                                                          int index = dataProvider.superEntityData.indexWhere(
                                                              (element) =>
                                                                  element.id == dataProvider.selectedSuperEntityId);
                                                          dataProvider.updateSuperEntity(
                                                            SuperEntityModel(
                                                              entityId: dataProvider.selectedEntityId,
                                                              libraryId: e.libraryId,
                                                              systemId: e.systemId,
                                                              entityName: e.entityName,
                                                              id: dataProvider.selectedSuperEntityId,
                                                            ),
                                                            index,
                                                          );
                                                          Navigator.pop(context);
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.green,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      dataProvider.superEntityData.removeWhere(
                                        (element) => element.id == dataProvider.selectedSuperEntityId,
                                      );
                                      dataProvider.setSuperEntityId(-1);
                                      // Update the state after deletion
                                      dataProvider.setState(CurrenState.idle);
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox();
                },
              ),
              if (dataProvider.selectedEntityId != -1 && !isSuperEntitySelected)
                TextButton(
                  onPressed: () {
                    // Show dialog to add super entity
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Add Super Entity"),
                              // Close button
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ...dataProvider.getEntityList(entityIndex).map(
                                  (e) {
                                    return ListTile(
                                      title: Text(e.entityName),
                                      onTap: () {
                                        final data = SuperEntityModel(
                                          entityId: dataProvider.selectedEntityId,
                                          libraryId: e.libraryId,
                                          systemId: e.systemId,
                                          entityName: e.entityName,
                                          id: Random().nextInt(1000),
                                        );
                                        dataProvider.superEntityData.add(data);
                                        dataProvider.setSuperEntityId(data.id);
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          )),
                    );
                  },
                  child: const Text(
                    "Add",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              const SizedBox(height: 20),
              // Show 'Attributes' title if the selected entity exists

              const Text(
                "Attributes",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Display the list of attributes for the selected entity

              ListView.builder(
                itemCount: dataProvider.attributeData.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  var attribute = dataProvider.attributeData[index];
                  return shouldShowAttribute(index, dataProvider)
                      ? ListTile(
                          leading: Text("${index + 1}"),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Label and Value for 'Name'
                              Text(
                                "Name: ${attribute.name}",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              // Label and Value for 'Type'
                              Text(
                                "Type: ${attribute.attributeType.name}",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              // Label and Value for 'Value'
                              Text(
                                "Value: ${attribute.value}",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Edit Button for each attribute
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.green),
                                onPressed: () {
                                  _handleEditAttribute(context, dataProvider, entityIndex, index);
                                },
                              ),
                              // Delete Button for each attribute
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  _handleDeleteAttribute(dataProvider, entityIndex, index);
                                },
                              ),
                            ],
                          ),
                        )
                      : const SizedBox();
                },
              ),
              // Show the 'Add' button if any entity is selected
              if (dataProvider.selectedEntityId != -1)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextButton(
                    onPressed: () {
                      _showNameDialog(context, dataProvider, entityIndex);
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

  // Function to handle editing an attribute
  void _handleEditAttribute(
    BuildContext context,
    DataProvider dataProvider,
    int entityIndex,
    int attributeIndex,
  ) {
    var attribute = dataProvider.attributeData[attributeIndex];
    TextEditingController attributeController = TextEditingController(text: attribute.value.toString());
    TextEditingController nameController = TextEditingController(text: attribute.name);

    // Open a dialog to edit the attribute based on its type
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _buildEditDialog(
          context,
          dataProvider,
          entityIndex,
          attributeIndex,
          nameController,
          attributeController,
        );
      },
    );
  }

  // Function to handle deleting an attribute
  void _handleDeleteAttribute(DataProvider dataProvider, int entityIndex, int attributeIndex) {
    List<AttributeModel> updatedAttributes = List.from(dataProvider.attributeData);
    updatedAttributes.removeAt(attributeIndex);

    // Update the entity with the modified list of attributes
    // dataProvider.entityData[entityIndex] = dataProvider.entityData[entityIndex].copyWith();

    // Trigger a state update
    dataProvider.setState(CurrenState.idle);
  }

  // New function to show a dialog asking for the 'name' first
  void _showNameDialog(BuildContext context, DataProvider dataProvider, int entityIndex) {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter attribute name"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Attribute Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the name dialog
                _showTypeSelectionDialog(context, dataProvider, entityIndex, nameController.text);
              },
              child: const Text("Next"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  // Function to show a dialog for selecting the 'type'
  void _showTypeSelectionDialog(
    BuildContext context,
    DataProvider dataProvider,
    int entityIndex,
    String attributeName,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select attribute type"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("String"),
                onTap: () {
                  Navigator.pop(context);
                  _showValueDialog(context, dataProvider, entityIndex, attributeName, AttributeType.string);
                },
              ),
              ListTile(
                title: const Text("Int"),
                onTap: () {
                  Navigator.pop(context);
                  _showValueDialog(context, dataProvider, entityIndex, attributeName, AttributeType.int);
                },
              ),
              ListTile(
                title: const Text("Range"),
                onTap: () {
                  Navigator.pop(context);
                  _showRangeValueDialog(context, dataProvider, entityIndex, attributeName);
                },
              ),
              ListTile(
                title: const Text("Bool"),
                onTap: () {
                  Navigator.pop(context);
                  _showBoolValueDialog(context, dataProvider, entityIndex, attributeName);
                },
              ),
              ListTile(
                title: const Text("Collection"),
                onTap: () {
                  Navigator.pop(context);
                  _showCollectionValueDialog(context, dataProvider, entityIndex, attributeName);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to show a dialog asking for the 'value' based on the type
  void _showValueDialog(
    BuildContext context,
    DataProvider dataProvider,
    int entityIndex,
    String attributeName,
    AttributeType attributeType,
  ) {
    TextEditingController valueController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter value for $attributeName"),
          content: TextField(
            controller: valueController,
            decoration: const InputDecoration(labelText: "Value"),
            keyboardType: attributeType == AttributeType.int ? TextInputType.number : TextInputType.text,
          ),
          actions: [
            TextButton(
              onPressed: () {
                List<AttributeModel> updatedAttributes = List.from(dataProvider.attributeData);
                updatedAttributes.add(AttributeModel(
                  attributeType: attributeType,
                  value: attributeType == AttributeType.int ? int.parse(valueController.text) : valueController.text,
                  name: attributeName,
                  entityId: dataProvider.selectedEntityId,
                  libraryId: dataProvider.selectedLibraryId,
                  systemId: dataProvider.selectedSystemId,
                ));
                dataProvider.attributeData = updatedAttributes;
                dataProvider.setState(CurrenState.idle);
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  // Function to show a dialog for 'Range' values
  void _showRangeValueDialog(
    BuildContext context,
    DataProvider dataProvider,
    int entityIndex,
    String attributeName,
  ) {
    TextEditingController startController = TextEditingController();
    TextEditingController endController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter range values for $attributeName"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: startController,
                decoration: const InputDecoration(labelText: "Start Value"),
              ),
              TextField(
                controller: endController,
                decoration: const InputDecoration(labelText: "End Value"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                List<AttributeModel> updatedAttributes = List.from(dataProvider.attributeData);
                updatedAttributes.add(AttributeModel(
                  attributeType: AttributeType.range,
                  value: "${startController.text} - ${endController.text}",
                  name: attributeName,
                  entityId: dataProvider.selectedEntityId,
                  libraryId: dataProvider.selectedLibraryId,
                  systemId: dataProvider.selectedSystemId,
                ));
                dataProvider.attributeData = updatedAttributes;
                dataProvider.setState(CurrenState.idle);
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  // Function to show a dialog for 'Bool' values
  void _showBoolValueDialog(
    BuildContext context,
    DataProvider dataProvider,
    int entityIndex,
    String attributeName,
  ) {
    TextEditingController trueController = TextEditingController();
    TextEditingController falseController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter boolean values for $attributeName"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: trueController,
                decoration: const InputDecoration(labelText: "True Value"),
              ),
              TextField(
                controller: falseController,
                decoration: const InputDecoration(labelText: "False Value"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                List<AttributeModel> updatedAttributes = List.from(dataProvider.attributeData);
                updatedAttributes.add(AttributeModel(
                  attributeType: AttributeType.bool,
                  value: "${trueController.text} - ${falseController.text}",
                  name: attributeName,
                  entityId: dataProvider.selectedEntityId,
                  libraryId: dataProvider.selectedLibraryId,
                  systemId: dataProvider.selectedSystemId,
                ));
                dataProvider.attributeData = updatedAttributes;
                dataProvider.setState(CurrenState.idle);
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  // Function to show a dialog for 'Collection' values
  void _showCollectionValueDialog(
    BuildContext context,
    DataProvider dataProvider,
    int entityIndex,
    String attributeName,
  ) {
    List<String> collectionList = [];
    TextEditingController dataController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Text("Enter collection values for $attributeName"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 200,
                    child: SingleChildScrollView(
                      child: Column(
                        children: collectionList
                            .map(
                              (e) => ListTile(
                                title: Text(e),
                                trailing: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      collectionList.remove(e);
                                    });
                                  },
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  TextField(
                    controller: dataController,
                    decoration: InputDecoration(
                      labelText: "Add item",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            collectionList.add(dataController.text);
                            dataController.clear();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    List<AttributeModel> updatedAttributes = List.from(dataProvider.attributeData);
                    updatedAttributes.add(AttributeModel(
                      attributeType: AttributeType.collection,
                      value: collectionList,
                      name: attributeName,
                      entityId: dataProvider.selectedEntityId,
                      libraryId: dataProvider.selectedLibraryId,
                      systemId: dataProvider.selectedSystemId,
                    ));
                    dataProvider.attributeData = updatedAttributes;
                    dataProvider.setState(CurrenState.idle);
                    Navigator.pop(context);
                  },
                  child: const Text("Add"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // General function to build edit dialog
  Widget _buildEditDialog(
    BuildContext context,
    DataProvider dataProvider,
    int entityIndex,
    int attributeIndex,
    TextEditingController nameController,
    TextEditingController attributeController,
  ) {
    return AlertDialog(
      title: Text("Edit ${dataProvider.attributeData[attributeIndex].attributeType}"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Enter attribute name"),
          ),
          TextField(
            controller: attributeController,
            decoration: const InputDecoration(labelText: "Enter attribute value"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            List<AttributeModel> updatedAttributes = List.from(dataProvider.attributeData);
            updatedAttributes[attributeIndex] = AttributeModel(
              attributeType: dataProvider.attributeData[attributeIndex].attributeType,
              value: attributeController.text,
              name: nameController.text,
              entityId: dataProvider.selectedEntityId,
              libraryId: dataProvider.selectedLibraryId,
              systemId: dataProvider.selectedSystemId,
            );
            dataProvider.attributeData = updatedAttributes;
            dataProvider.setState(CurrenState.idle);
            Navigator.pop(context);
          },
          child: const Text("Edit"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
      ],
    );
  }

  bool shouldShowSuperEntity(int index, DataProvider myType) {
    //if only library is selected and no system and entity is selected then show all super entities
    if (myType.selectedLibraryId == -1) {
      return false;
    } else if (myType.selectedLibraryId != -1 && myType.selectedSystemId == -1 && myType.selectedEntityId == -1) {
      return myType.superEntityData[index].libraryId == myType.selectedLibraryId;
    } else if (myType.selectedLibraryId != -1 && myType.selectedSystemId == -1 && myType.selectedEntityId == -1) {
      return myType.superEntityData[index].libraryId == myType.selectedLibraryId;
    } else if (myType.selectedLibraryId != -1 && myType.selectedSystemId != -1 && myType.selectedEntityId == -1) {
      return myType.superEntityData[index].libraryId == myType.selectedLibraryId &&
          myType.superEntityData[index].systemId == myType.selectedSystemId;
    } else if (myType.selectedLibraryId != -1 && myType.selectedSystemId != -1 && myType.selectedEntityId != -1) {
      return myType.superEntityData[index].libraryId == myType.selectedLibraryId &&
          myType.superEntityData[index].systemId == myType.selectedSystemId &&
          myType.superEntityData[index].entityId == myType.selectedEntityId;
    } else {
      return false;
    }
  }

  bool shouldShowAttribute(int index, DataProvider myType) {
    //if only library is selected and no system and entity is selected then show all super entities
    if (myType.selectedLibraryId == -1) {
      return false;
    } else if (myType.selectedLibraryId != -1 && myType.selectedSystemId == -1 && myType.selectedEntityId == -1) {
      return myType.attributeData[index].libraryId == myType.selectedLibraryId;
    } else if (myType.selectedLibraryId != -1 && myType.selectedSystemId == -1 && myType.selectedEntityId == -1) {
      return myType.attributeData[index].libraryId == myType.selectedLibraryId;
    } else if (myType.selectedLibraryId != -1 && myType.selectedSystemId != -1 && myType.selectedEntityId == -1) {
      return myType.attributeData[index].libraryId == myType.selectedLibraryId &&
          myType.attributeData[index].systemId == myType.selectedSystemId;
    } else if (myType.selectedLibraryId != -1 && myType.selectedSystemId != -1 && myType.selectedEntityId != -1) {
      return myType.attributeData[index].libraryId == myType.selectedLibraryId &&
          myType.attributeData[index].systemId == myType.selectedSystemId &&
          myType.attributeData[index].entityId == myType.selectedEntityId;
    } else {
      return false;
    }
  }
}
