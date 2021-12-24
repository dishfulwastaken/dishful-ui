/// Expected format of [s]:
/// HH:mm:ss.ssssss
///
/// This can be achieved easily with [Duration.toString()].
Duration parseDuration(String s) {
  List<String> parts = s.split(':');
  final hours = int.tryParse(parts[0]);
  final minutes = int.tryParse(parts[1]);

  List<String> secondsParts = parts[2].split('.');
  final seconds = int.tryParse(secondsParts[0]);

  return Duration(
    hours: hours ?? 0,
    minutes: minutes ?? 0,
    seconds: seconds ?? 0,
  );
}
