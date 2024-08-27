import 'package:flutter/material.dart';
import 'package:webapp/model/library_model.dart';

class DataProvider extends ChangeNotifier {
  List<LibraryModel> libraryData = [];
  List<SystemModel> systemData = [];
  List<EntityModel> entityData = [];

  TextEditingController libraryController = TextEditingController();
  TextEditingController libraryCommentController = TextEditingController();
  TextEditingController systemController = TextEditingController();
  TextEditingController systemCommentController = TextEditingController();
  TextEditingController entityController = TextEditingController();
  TextEditingController superEntityController = TextEditingController();
  TextEditingController subEntityController = TextEditingController();

  CurrenState currenState = CurrenState.idle;
  int libraryEditIndex = -1;
  int systemEditIndex = -1;
  int libraryCommentEditIndex = -1;
  int systemCommentEditIndex = -1;
  int entityEditIndex = -1;
  int superEntityEditIndex = -1;
  int subEntityEditIndex = -1;

  int selectedLibraryId = -1;
  int selectedSystemId = -1;
  int selectedEntityId = -1;
  int selectedSuperEntityId = -1;

  //set Library id
  void setLibraryId(int id) {
    selectedLibraryId = id;
    notifyListeners();
  }

  //set System id
  void setSystemId(int id) {
    selectedSystemId = id;
    notifyListeners();
  }

  //set Entity id
  void setEntityId(int id) {
    selectedEntityId = id;
    notifyListeners();
  }

  void setState(CurrenState state) {
    currenState = state;
    notifyListeners();
  }

  //set Edit Index
  void setLibraryEditIndex(int index) {
    libraryEditIndex = index;
    notifyListeners();
  }

  void setSystemEditIndex(int index) {
    systemEditIndex = index;
    notifyListeners();
  }

  void setEntityEditIndex(int index) {
    entityEditIndex = index;
    notifyListeners();
  }

  void setSuperEntityEditIndex(int index) {
    superEntityEditIndex = index;
    notifyListeners();
  }

  void setLibraryCommentEditIndex(int index) {
    libraryCommentEditIndex = index;
    systemCommentEditIndex = -1;
    notifyListeners();
  }

  void setSystemCommentEditIndex(int index) {
    systemCommentEditIndex = index;
    notifyListeners();
  }

  void setSuperEntityData(int index) {
    // if (entityData[index].superEntityData.isEmpty) {
    //   List superEntityData = entityData
    //       .map(
    //         (e) => SuperEntityModel(
    //           id: e.id,
    //           libraryId: e.libraryId,
    //           systemId: e.systemId,
    //           entityName: e.entityName,
    //         ),
    //       )
    //       .toList();
    //   superEntityData.removeAt(index);
    //   entityData[index].superEntityData = List.from(superEntityData);
    // }
  }

  void setSuperEntityId(int id) {
    selectedSuperEntityId = id;
    notifyListeners();
  }

  void setSubEntityEditIndex(int i) {
    subEntityEditIndex = i;
    notifyListeners();
  }

  List<SuperEntityModel> getEntityList(int index) {
    if (entityData[index].superEntityData.isEmpty) {
      List<SuperEntityModel> superEntityData = entityData
          .map(
            (e) => SuperEntityModel(
              id: e.id,
              libraryId: e.libraryId,
              systemId: e.systemId,
              entityName: e.entityName,
            ),
          )
          .toList();
      superEntityData.removeAt(index);
      return superEntityData;
    } else {
      List<SuperEntityModel> superEntityData = entityData
          .map(
            (e) => SuperEntityModel(
              id: e.id,
              libraryId: e.libraryId,
              systemId: e.systemId,
              entityName: e.entityName,
            ),
          )
          .toList();
      superEntityData.removeAt(index);
      //remove the id that is already in the superEntityData
      for (var element in entityData[index].superEntityData) {
        superEntityData.removeWhere((e) => e.id == element.id);
      }
      return superEntityData;
    }
  }

  void addSuperEntity(SuperEntityModel superEntityModel, int entityIndex) {
    List superEntityData = List.from(entityData[entityIndex].superEntityData);
    superEntityData.add(superEntityModel);
    entityData[entityIndex].superEntityData = List.from(superEntityData);
    notifyListeners();
  }
}

enum CurrenState {
  libraryAdd,
  libraryEdit,
  systemAdd,
  systemEdit,
  entityAdd,
  entityEdit,
  superEntityAdd,
  superEntityEdit,
  subEntityAdd,
  subEntityEdit,
  attributeAdd,
  attributeEdit,
  idle,
}
