class LibraryModel {
  int id;
  String libraryName;
  String comment;

  LibraryModel({
    required this.id,
    required this.libraryName,
    this.comment = '',
  });

  //copy with
  LibraryModel copyWith({
    int? id,
    String? libraryName,
    String? comment,
  }) {
    return LibraryModel(
      id: id ?? this.id,
      libraryName: libraryName ?? this.libraryName,
      comment: comment ?? this.comment,
    );
  }
}

class SystemModel {
  int id;
  int libraryId;
  String systemName;
  String comment;

  SystemModel({
    required this.id,
    required this.libraryId,
    required this.systemName,
    this.comment = '',
  });

  //copy with
  SystemModel copyWith({
    int? id,
    int? libraryId,
    String? systemName,
    String? comment,
  }) {
    return SystemModel(
      id: id ?? this.id,
      libraryId: libraryId ?? this.libraryId,
      systemName: systemName ?? this.systemName,
      comment: comment ?? this.comment,
    );
  }
}

class EntityModel {
  int id;
  int libraryId;
  int systemId;
  String entityName;
  List<SuperEntityModel> superEntityData = [];
  List<String> subentityData;
  List<Attribute> attributeData;

  EntityModel({
    required this.id,
    required this.libraryId,
    required this.systemId,
    required this.entityName,
    this.superEntityData = const [],
    this.subentityData = const [],
    this.attributeData = const [],
  });

  //copy with
  EntityModel copyWith({
    int? id,
    int? libraryId,
    int? systemId,
    String? entityName,
    List<SuperEntityModel>? superEntityData,
    List<String>? subentityData,
    required List<Attribute> attributeData,
  }) {
    return EntityModel(
      id: id ?? this.id,
      libraryId: libraryId ?? this.libraryId,
      systemId: systemId ?? this.systemId,
      entityName: entityName ?? this.entityName,
      superEntityData: superEntityData ?? this.superEntityData,
      subentityData: subentityData ?? this.subentityData,
      attributeData: attributeData,
    );
  }
}

class SuperEntityModel {
  int id;
  int libraryId;
  int systemId;
  String entityName;
  List<Attribute> attributeData;

  SuperEntityModel({
    required this.id,
    required this.libraryId,
    required this.systemId,
    required this.entityName,
    this.attributeData = const [],
  });

  //copy with
  SuperEntityModel copyWith({
    int? id,
    int? libraryId,
    int? systemId,
    String? entityName,
    required List<Attribute> attributeData,
  }) {
    return SuperEntityModel(
      id: id ?? this.id,
      libraryId: libraryId ?? this.libraryId,
      systemId: systemId ?? this.systemId,
      entityName: entityName ?? this.entityName,
      attributeData: attributeData,
    );
  }
}

class Attribute {
  String name;
  AttributeType attributeType;
  dynamic value;

  Attribute({
    required this.attributeType,
    this.name = "",
    this.value,
  });

  //override toString method for attributeType
  @override
  String toString() {
    return '$name\n${getAttributeType(attributeType)}\n$value';
  }

  getAttributeType(AttributeType attributeType) {
    switch (attributeType) {
      case AttributeType.int:
        return 'int';
      case AttributeType.string:
        return 'string';
      case AttributeType.range:
        return 'range';
      case AttributeType.bool:
        return 'bool';
      case AttributeType.collection:
        return 'collection';
      default:
        return '';
    }
  }
}

enum AttributeType {
  int,
  string,
  range,
  bool,
  collection,
}
