import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp/model/library_model.dart';
import 'package:webapp/provider/data_provider.dart';

class AttributeContainer extends StatelessWidget {
  const AttributeContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, myType, child) {
        int entityIndex = myType.entityData.indexWhere((element) => element.id == myType.selectedEntityId);

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
              myType.selectedEntityId == -1
                  ? const SizedBox()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: myType.entityData[entityIndex].superEntityData.length,
                      itemBuilder: (context, index) {
                        return myType.currenState == CurrenState.superEntityEdit && myType.superEntityEditIndex == index
                            ? const Padding(
                                padding: EdgeInsets.all(10),
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
                                        myType
                                            .setSuperEntityId(myType.entityData[entityIndex].superEntityData[index].id);
                                      },
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              //show dialog to edit super entity
                                              TextEditingController superEntityController = TextEditingController();
                                              superEntityController.text =
                                                  myType.entityData[entityIndex].superEntityData[index].entityName;
                                              showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                    title: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        const Text("Edit Super Entity"),
                                                        //close button
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
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: <Widget>[
                                                        TextField(
                                                          controller: superEntityController,
                                                          decoration: const InputDecoration(
                                                            labelText: "Enter super entity name",
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            myType.entityData[entityIndex].superEntityData[index] =
                                                                myType.entityData[entityIndex].superEntityData[index]
                                                                    .copyWith(
                                                              entityName: superEntityController.text,
                                                              attributeData: myType.entityData[entityIndex]
                                                                  .superEntityData[index].attributeData,
                                                            );
                                                            myType.setState(CurrenState.idle);
                                                            Navigator.pop(context);
                                                          },
                                                          child: const Text("Edit"),
                                                        ),
                                                      ],
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
                                              List<SuperEntityModel> tempList =
                                                  List.from(myType.entityData[entityIndex].superEntityData);
                                              tempList.removeAt(index);
                                              myType.entityData[entityIndex] = myType.entityData[entityIndex].copyWith(
                                                superEntityData: tempList,
                                                attributeData: myType.entityData[entityIndex].attributeData,
                                              );
                                              myType.setState(CurrenState.idle);
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox();
                      },
                    ),
              if (myType.selectedEntityId != -1)
                TextButton(
                  onPressed: () {
                    //show dialog to add super entity
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Add Super Entity"),
                              //close button
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
                                ...myType.getEntityList(entityIndex).map(
                                  (e) {
                                    return ListTile(
                                      title: Text(e.entityName),
                                      onTap: () {
                                        myType.addSuperEntity(
                                          SuperEntityModel(
                                            id: e.id,
                                            libraryId: e.libraryId,
                                            systemId: e.systemId,
                                            entityName: e.entityName,
                                            attributeData: e.attributeData,
                                          ),
                                          entityIndex,
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
                  child: const Text(
                    "Add",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              if (entityIndex != -1)
                const Text(
                  "Attributes",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (entityIndex != -1)
                ListView.builder(
                  itemCount: myType.entityData[entityIndex].attributeData.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Text("${index + 1}"),
                      title: Text(
                        myType.entityData[entityIndex].attributeData[index].toString(),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              if ([AttributeType.int, AttributeType.string]
                                  .contains(myType.entityData[entityIndex].attributeData[index].attributeType)) {
                                TextEditingController attributeController = TextEditingController();
                                TextEditingController nameController = TextEditingController();
                                attributeController.text =
                                    myType.entityData[entityIndex].attributeData[index].value.toString();
                                nameController.text = myType.entityData[entityIndex].attributeData[index].name;

                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                          "Edit ${myType.entityData[entityIndex].attributeData[index].attributeType}"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: nameController,
                                            decoration: const InputDecoration(
                                              labelText: "Enter attribute name",
                                            ),
                                          ),
                                          TextField(
                                            controller: attributeController,
                                            decoration: const InputDecoration(
                                              labelText: "Enter attribute value",
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  List<Attribute> tempList =
                                                      List.from(myType.entityData[entityIndex].attributeData);
                                                  tempList[index] = Attribute(
                                                    attributeType: myType
                                                        .entityData[entityIndex].attributeData[index].attributeType,
                                                    value: myType.entityData[entityIndex].attributeData[index]
                                                                .attributeType !=
                                                            AttributeType.int
                                                        ? attributeController.text
                                                        : int.parse(attributeController.text),
                                                    name: nameController.text,
                                                  );
                                                  myType.entityData[entityIndex] =
                                                      myType.entityData[entityIndex].copyWith(
                                                    attributeData: tempList,
                                                  );
                                                  myType.setState(CurrenState.idle);
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
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              } else if (myType.entityData[entityIndex].attributeData[index].attributeType ==
                                  AttributeType.collection) {
                                List<String> collectionList = List.from(
                                    myType.entityData[entityIndex].attributeData[index].value as List<String>);
                                TextEditingController dataController = TextEditingController();
                                TextEditingController nameController = TextEditingController();
                                nameController.text = myType.entityData[entityIndex].attributeData[index].name;
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: (BuildContext context, setState) {
                                        return AlertDialog(
                                          title: const Text("Add Collection"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                controller: nameController,
                                                decoration: const InputDecoration(
                                                  labelText: "Enter Collection name",
                                                ),
                                              ),
                                              SizedBox(
                                                height: 300,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: <Widget>[
                                                      ...collectionList.map(
                                                        (e) {
                                                          return ListTile(
                                                            title: Text(e),
                                                            trailing: IconButton(
                                                              onPressed: () {
                                                                collectionList.remove(e);
                                                                setState(() {});
                                                              },
                                                              icon: const Icon(Icons.close),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              TextField(
                                                controller: dataController,
                                                decoration: InputDecoration(
                                                  labelText: "Enter Collection data",
                                                  suffix: IconButton(
                                                    onPressed: () {
                                                      collectionList.add(dataController.text);
                                                      dataController.clear();
                                                      setState(() {});
                                                    },
                                                    icon: const Icon(Icons.add),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      if (dataController.text.isNotEmpty) {
                                                        collectionList.add(dataController.text);
                                                        dataController.clear();
                                                      }
                                                      List<Attribute> tempList =
                                                          List.from(myType.entityData[entityIndex].attributeData);
                                                      //replace the attribute with new one
                                                      tempList[index] = Attribute(
                                                        attributeType: AttributeType.collection,
                                                        value: collectionList,
                                                        name: nameController.text,
                                                      );
                                                      myType.entityData[entityIndex] =
                                                          myType.entityData[entityIndex].copyWith(
                                                        attributeData: tempList,
                                                      );
                                                      myType.setState(CurrenState.idle);
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
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              } else {
                                TextEditingController nameController = TextEditingController();
                                TextEditingController trueController = TextEditingController();
                                TextEditingController falseController = TextEditingController();
                                List<String> value =
                                    myType.entityData[entityIndex].attributeData[index].value.split(" - ");
                                nameController.text = myType.entityData[entityIndex].attributeData[index].name;
                                trueController.text = value[0];
                                falseController.text = value[1];

                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                          "Edit ${myType.entityData[entityIndex].attributeData[index].attributeType}"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: nameController,
                                            decoration: const InputDecoration(
                                              labelText: "Enter attribute name",
                                            ),
                                          ),
                                          TextField(
                                            controller: trueController,
                                            decoration: const InputDecoration(
                                              labelText: "Enter start value",
                                            ),
                                          ),
                                          TextField(
                                            controller: falseController,
                                            decoration: const InputDecoration(
                                              labelText: "Enter end value",
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  List<Attribute> tempList =
                                                      List.from(myType.entityData[entityIndex].attributeData);
                                                  tempList[index] = Attribute(
                                                    attributeType: AttributeType.range,
                                                    value: "${trueController.text} - ${falseController.text}",
                                                    name: nameController.text,
                                                  );
                                                  myType.entityData[entityIndex] =
                                                      myType.entityData[entityIndex].copyWith(
                                                    attributeData: tempList,
                                                  );
                                                  myType.setState(CurrenState.idle);
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
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.green,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              List<Attribute> tempList = List.from(myType.entityData[entityIndex].attributeData);
                              tempList.removeAt(index);
                              myType.entityData[entityIndex] = myType.entityData[entityIndex].copyWith(
                                attributeData: tempList,
                              );
                              myType.setState(CurrenState.idle);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              if (myType.selectedEntityId != -1)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextButton(
                    onPressed: () {
                      myType.setState(CurrenState.attributeAdd);
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
                            title: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text("Select attribute type"),
                                IconButton(
                                  onPressed: () {
                                    myType.setState(CurrenState.idle);
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: const Text("String"),
                                  onTap: () {
                                    //show dialog to add a string
                                    TextEditingController attributeController = TextEditingController();
                                    TextEditingController nameController = TextEditingController();

                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Add String"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                controller: nameController,
                                                decoration: const InputDecoration(
                                                  labelText: "Enter attribute name",
                                                ),
                                              ),
                                              TextField(
                                                controller: attributeController,
                                                decoration: const InputDecoration(
                                                  labelText: "Enter attribute value",
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      List<Attribute> tempList =
                                                          List.from(myType.entityData[entityIndex].attributeData);
                                                      tempList.add(Attribute(
                                                        attributeType: AttributeType.string,
                                                        value: attributeController.text,
                                                        name: nameController.text,
                                                      ));
                                                      myType.entityData[entityIndex] =
                                                          myType.entityData[entityIndex].copyWith(
                                                        attributeData: tempList,
                                                      );
                                                      myType.setState(CurrenState.idle);
                                                      Navigator.pop(context);
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
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                ListTile(
                                  title: const Text("Int"),
                                  onTap: () {
                                    //show dialog to add a int
                                    TextEditingController attributeController = TextEditingController();
                                    TextEditingController nameController = TextEditingController();
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Add Int"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                controller: nameController,
                                                decoration: const InputDecoration(
                                                  labelText: "Enter attribute name",
                                                ),
                                              ),
                                              TextField(
                                                controller: attributeController,
                                                decoration: const InputDecoration(
                                                  labelText: "Enter attribute value",
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      List<Attribute> tempList =
                                                          List.from(myType.entityData[entityIndex].attributeData);
                                                      tempList.add(Attribute(
                                                        attributeType: AttributeType.int,
                                                        value: int.parse(attributeController.text),
                                                        name: nameController.text,
                                                      ));
                                                      myType.entityData[entityIndex] =
                                                          myType.entityData[entityIndex].copyWith(
                                                        attributeData: tempList,
                                                      );
                                                      myType.setState(CurrenState.idle);
                                                      Navigator.pop(context);
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
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                ListTile(
                                  title: const Text("Range"),
                                  onTap: () {
                                    //show dialog to add a bool
                                    TextEditingController nameController = TextEditingController();
                                    TextEditingController trueController = TextEditingController();
                                    TextEditingController falseController = TextEditingController();
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Add range"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: 400,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    TextField(
                                                      controller: nameController,
                                                      decoration: const InputDecoration(
                                                        labelText: "Enter attribute name",
                                                      ),
                                                    ),
                                                    TextField(
                                                      controller: trueController,
                                                      decoration: const InputDecoration(
                                                        labelText: "Enter start value",
                                                      ),
                                                    ),
                                                    TextField(
                                                      controller: falseController,
                                                      decoration: const InputDecoration(
                                                        labelText: "Enter end value",
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () {
                                                            List<Attribute> tempList =
                                                                List.from(myType.entityData[entityIndex].attributeData);
                                                            tempList.add(Attribute(
                                                              attributeType: AttributeType.range,
                                                              value: "${trueController.text} - ${falseController.text}",
                                                              name: nameController.text,
                                                            ));
                                                            myType.entityData[entityIndex] =
                                                                myType.entityData[entityIndex].copyWith(
                                                              attributeData: tempList,
                                                            );
                                                            myType.setState(CurrenState.idle);
                                                            Navigator.pop(context);
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
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                ListTile(
                                  title: const Text("Bool"),
                                  onTap: () {
                                    //show dialog to add a bool
                                    TextEditingController nameController = TextEditingController();
                                    TextEditingController trueController = TextEditingController();
                                    TextEditingController falseController = TextEditingController();
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Add Bool"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: 400,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    TextField(
                                                      controller: nameController,
                                                      decoration: const InputDecoration(
                                                        labelText: "Enter attribute name",
                                                      ),
                                                    ),
                                                    TextField(
                                                      controller: trueController,
                                                      decoration: const InputDecoration(
                                                        labelText: "Enter true value",
                                                      ),
                                                    ),
                                                    TextField(
                                                      controller: falseController,
                                                      decoration: const InputDecoration(
                                                        labelText: "Enter false value",
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () {
                                                            List<Attribute> tempList =
                                                                List.from(myType.entityData[entityIndex].attributeData);
                                                            tempList.add(Attribute(
                                                              attributeType: AttributeType.bool,
                                                              value: "${trueController.text} - ${falseController.text}",
                                                              name: nameController.text,
                                                            ));
                                                            myType.entityData[entityIndex] =
                                                                myType.entityData[entityIndex].copyWith(
                                                              attributeData: tempList,
                                                            );
                                                            myType.setState(CurrenState.idle);
                                                            Navigator.pop(context);
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
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                ListTile(
                                  title: const Text("Collection"),
                                  onTap: () {
                                    //show dialog to add collections
                                    List<String> collectionList = [];
                                    TextEditingController dataController = TextEditingController();
                                    TextEditingController nameController = TextEditingController();
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (BuildContext context, setState) {
                                            return AlertDialog(
                                              title: const Text("Add Collection"),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    controller: nameController,
                                                    decoration: const InputDecoration(
                                                      labelText: "Enter Collection name",
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 400,
                                                    child: SingleChildScrollView(
                                                      child: Column(
                                                        children: <Widget>[
                                                          ...collectionList.map(
                                                            (e) {
                                                              return ListTile(
                                                                title: Text(e),
                                                                trailing: IconButton(
                                                                  onPressed: () {
                                                                    collectionList.remove(e);
                                                                    setState(() {});
                                                                  },
                                                                  icon: const Icon(Icons.close),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  TextField(
                                                    controller: dataController,
                                                    decoration: InputDecoration(
                                                      labelText: "Enter Collection data",
                                                      suffix: IconButton(
                                                        onPressed: () {
                                                          collectionList.add(dataController.text);
                                                          dataController.clear();
                                                          setState(() {});
                                                        },
                                                        icon: const Icon(Icons.add),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          if (dataController.text.isNotEmpty) {
                                                            collectionList.add(dataController.text);
                                                            dataController.clear();
                                                          }
                                                          List<Attribute> tempList =
                                                              List.from(myType.entityData[entityIndex].attributeData);
                                                          tempList.add(Attribute(
                                                            attributeType: AttributeType.collection,
                                                            value: collectionList,
                                                            name: nameController.text,
                                                          ));
                                                          myType.entityData[entityIndex] =
                                                              myType.entityData[entityIndex].copyWith(
                                                            attributeData: tempList,
                                                          );
                                                          myType.setState(CurrenState.idle);
                                                          Navigator.pop(context);
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
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
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
