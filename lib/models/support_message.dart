class SupportMessage {
  final String message;
  final bool withTechData;
  final bool withUserData;

  SupportMessage(
    this.message, {
    this.withTechData = false,
    this.withUserData = false,
  });
}
