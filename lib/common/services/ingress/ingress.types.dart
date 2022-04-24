part of ingress;

abstract class Adapter {
  /// Whether the Adapter can parse the HTML
  /// for the [url].
  bool canParse(String url);

  /// Clean the [url].
  /// This involves checking for anything malicious while
  /// also preparing the [url] to be fetched (if needed).
  String sanitizeUrl(String url);

  /// Try to create a [Ingredient] from the
  /// [document].
  Ingredient? ingredient(Document document);

  /// Try to create a [Iteration] from the
  /// [document].
  Iteration? iteration(Document document);

  /// Try to create a [Recipe] from the
  /// [document].
  Recipe? recipe(Document document);

  /// Try to create a [Review] from the
  /// [document].
  Review? review(Document document);

  /// Try to create a [Instruction] from the
  /// [document].
  Instruction? instruction(Document document);
}
