import '../models/person_model.dart';
import '../constants/enums.dart';

class LotPermissionChecker {
  final Person currentUser;

  const LotPermissionChecker(this.currentUser);

  bool get canCreate => true; // All person types can create

  bool get canEdit {
    if (currentUser.isAdmin) return true;
    return currentUser.type == PersonType.owner ||
        currentUser.type == PersonType.manager ||
        currentUser.type == PersonType.worker;
  }

  bool get canClose {
    if (currentUser.isAdmin) return true;
    return currentUser.type == PersonType.owner || currentUser.type == PersonType.manager;
  }

  bool get canDelete {
    if (currentUser.isAdmin) return true;
    return currentUser.type == PersonType.owner || currentUser.type == PersonType.manager;
  }

  bool get canView => true; // All can view
}
