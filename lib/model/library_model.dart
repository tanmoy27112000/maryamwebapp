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

  EntityModel({
    required this.id,
    required this.libraryId,
    required this.systemId,
    required this.entityName,
  });

  //copy with
  EntityModel copyWith({
    int? id,
    int? libraryId,
    int? systemId,
    String? entityName,
  }) {
    return EntityModel(
      id: id ?? this.id,
      libraryId: libraryId ?? this.libraryId,
      systemId: systemId ?? this.systemId,
      entityName: entityName ?? this.entityName,
    );
  }
}

class SuperEntityModel {
  int id;
  int libraryId;
  int systemId;
  int entityId;
  String entityName;

  SuperEntityModel({
    required this.id,
    required this.libraryId,
    required this.systemId,
    required this.entityId,
    required this.entityName,
  });

  //copy with
  SuperEntityModel copyWith({
    int? id,
    int? libraryId,
    int? systemId,
    String? entityName,
    int? entityId,
  }) {
    return SuperEntityModel(
      id: id ?? this.id,
      libraryId: libraryId ?? this.libraryId,
      systemId: systemId ?? this.systemId,
      entityId: entityId ?? this.entityId,
      entityName: entityName ?? this.entityName,
    );
  }
}

class AttributeModel {
  String name;
  int? libraryId;
  int systemId;
  int entityId;
  AttributeType attributeType;
  dynamic value;

  AttributeModel({
    required this.attributeType,
    this.name = "",
    this.value,
    required this.libraryId,
    required this.systemId,
    required this.entityId,
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
