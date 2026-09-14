class Failure {
  final String errorMessage;
  final int? code;

  const Failure(
      this.errorMessage, {
        this.code,
      });

  @override
  String toString() => errorMessage;
}