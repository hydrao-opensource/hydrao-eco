import 'package:build/build.dart'; // ignore: depend_on_referenced_packages
import 'package:hydrao_flutter_offline/builders/generate_merge/companion_merge_generator.dart';
import 'package:source_gen/source_gen.dart'; // ignore: depend_on_referenced_packages

Builder generateMerge(BuilderOptions options) {
  return PartBuilder([CompanionMergeGenerator()], '.merge.g.dart');
}
