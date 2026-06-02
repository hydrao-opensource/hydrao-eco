// lib/builders/companion_merge_generator.dart
import 'package:analyzer/dart/element/element.dart'; // ignore: depend_on_referenced_packages
import 'package:build/build.dart'; // ignore: depend_on_referenced_packages
import 'package:hydrao_flutter_offline/builders/generate_merge/companion_merge_annotation.dart';
import 'package:source_gen/source_gen.dart'; // ignore: depend_on_referenced_packages

/// Générateur qui crée les méthodes mergeWith pour les Companions Drift
class CompanionMergeGenerator extends GeneratorForAnnotation<CompanionMerge> {
  @override
  dynamic generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    // Vérifie que c'est bien une classe
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        'GenerateMerge can only be applied to classes',
        todo: 'Apply @GenerateMerge only to class declarations',
      );
    }

    // Vérifie que c'est une table Drift (hérite de Table)
    final isDriftTable = element.allSupertypes.any(
      (type) => type.getDisplayString() == 'Table',
    );

    if (!isDriftTable) {
      throw InvalidGenerationSourceError(
        'GenerateMerge can only be applied to Drift Table classes',
        todo: 'Apply @GenerateMerge only to classes that extend Table',
      );
    }

    // Récupère le nom de la classe Data générée
    // Par défaut Drift génère : UsersTable -> UsersCompanion
    final tableName = element.name;
    final companionName = '${tableName}Companion';

    // Récupère tous les champs (colonnes) de la table
    final fields = _getTableFields(element);

    if (fields.isEmpty) {
      return ''; // Pas de champs, pas de génération
    }

    // Génère le code de l'extension
    return _generateMergeExtension(companionName, fields);
  }

  /// Récupère tous les champs (getters) de la table Drift
  List<String> _getTableFields(ClassElement element) {
    final fields = <String>[];

    for (final field in element.fields) {
      // on ne prend que les getters publics
      if (!field.isPublic || field.getter == null) continue;

      // on exclut explicitement `primaryKey`
      if (field.name == 'primaryKey') continue;

      final type = field.type;
      final typeStr = type.getDisplayString();

      // on exclut les Set<...> (ex: Set<Column>)
      if (type.isDartCoreSet) continue;

      // on ne garde que les "vraies" colonnes drift (IntColumn, TextColumn, etc.)
      if (typeStr.contains('Column')) {
        fields.add(field.name!);
      }
    }

    return fields;
  }

  /// Génère le code de l'extension mergeWith
  String _generateMergeExtension(String companionName, List<String> fields) {
    final buffer = StringBuffer();

    buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    buffer.writeln();
    buffer.writeln('extension ${companionName}Merge on $companionName {');
    buffer.writeln('  /// Merge ce companion avec un autre');
    buffer.writeln(
      '  /// Les valeurs présentes dans [other] écrasent celles de this',
    );
    buffer.writeln('  $companionName mergeWith($companionName other) {');
    buffer.writeln('    return $companionName(');

    // Génère la ligne pour chaque champ
    for (var i = 0; i < fields.length; i++) {
      final field = fields[i];
      buffer.write(
        '      $field: other.$field.present ? other.$field : $field',
      );

      // Ajoute une virgule sauf pour le dernier élément
      if (i < fields.length - 1) {
        buffer.writeln(',');
      } else {
        buffer.writeln();
      }
    }

    buffer.writeln('    );');
    buffer.writeln('  }');
    buffer.writeln();

    // Ajoute aussi une méthode mergeAll
    buffer.writeln('  /// Merge ce companion avec plusieurs autres');
    buffer.writeln('  /// Les companions sont appliqués dans l\'ordre');
    buffer.writeln('  $companionName mergeAll(List<$companionName> others) {');
    buffer.writeln('    var result = this;');
    buffer.writeln('    for (final other in others) {');
    buffer.writeln('      result = result.mergeWith(other);');
    buffer.writeln('    }');
    buffer.writeln('    return result;');
    buffer.writeln('  }');
    buffer.writeln('}');

    return buffer.toString();
  }
}
