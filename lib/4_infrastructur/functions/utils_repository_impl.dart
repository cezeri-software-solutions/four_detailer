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

Future<String?> getMainBranchId() async {
  final ownerId = await getOwnerId();
  if (ownerId == null) return null;

  try {
    final response = await supabase.from('branches').select('id').eq('owner_id', ownerId).eq('is_main_branch', true).single();

    return response['id'];
  } catch (e) {
    logger.e(e);
    return null;
  }
}

Future<String?> getMainBranchSettingsId() async {
  final ownerId = await getOwnerId();
  if (ownerId == null) return null;

  try {
    final response = await supabase.from('branches').select('settings_id').eq('owner_id', ownerId).eq('is_main_branch', true).single();

    return response['settings_id'];
  } catch (e) {
    logger.e(e);
    return null;
  }
}
