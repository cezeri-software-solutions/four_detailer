//* Formatiert eine Duration in einen String im folgenden Format: z.B. HH:mm
extension ConvertDurationToHHMM on Duration {
  String toHHMM() {
    return '${inHours.toString().padLeft(2, '0')}:${(inMinutes % 60).toString().padLeft(2, '0')}';
  }
}
