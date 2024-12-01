import '../../constants.dart';

String getCurrentUserId() => supabase.auth.currentUser!.id;

String getCurrentUserEmail() => supabase.auth.currentUser!.email!;

Future<String?> getOwnerId() async {
  final userId = getCurrentUserId();

  try {
    final response = await supabase.from('conditioners').select('owner_id').eq('id', userId).single();

    return response['owner_id'];
  } catch (e) {
    logger.e(e);
    return null;
  }
}
