import '../models/person_model.dart';
import '../constants/enums.dart';

/// Service to check permissions for person-related operations
///
/// This service encapsulates all permission logic for managing people
/// in a farm, ensuring consistent permission checks across the app.
///
/// Permission Rules:
/// - Admin can do anything
/// - Owner can add, edit, and remove people (except last owner)
/// - Manager can add and edit people (except owners)
/// - Worker and Arrendatario cannot manage people
class PersonPermissionChecker {
  /// Check if a person can add new people to the farm
  ///
  /// Returns true if the person is:
  /// - Admin (isAdmin = true), OR
  /// - Owner, OR
  /// - Manager
  static bool canAddPerson(Person currentUser) {
    return currentUser.isAdmin ||
        currentUser.personType == PersonType.owner ||
        currentUser.personType == PersonType.manager;
  }

  /// Check if a person can edit another person's information
  ///
  /// Returns true if the person is:
  /// - Admin (can edit anyone), OR
  /// - Owner (can edit anyone), OR
  /// - Manager (can edit anyone except owners)
  static bool canEditPerson(Person currentUser, Person targetPerson) {
    // Admin can edit anyone
    if (currentUser.isAdmin) return true;

    // Owner can edit anyone
    if (currentUser.personType == PersonType.owner) return true;

    // Manager can edit anyone except owners
    if (currentUser.personType == PersonType.manager &&
        targetPerson.personType != PersonType.owner) {
      return true;
    }

    return false;
  }

  /// Check if a person can remove another person from the farm
  ///
  /// Returns true if:
  /// - Admin (can remove anyone except last owner), OR
  /// - Owner (can remove anyone except last owner)
  ///
  /// Note: This method does NOT check if the target is the last owner.
  /// That check should be done separately using [canRemoveLastOwner].
  static bool canRemovePerson(Person currentUser, Person targetPerson) {
    // Admin can remove anyone
    if (currentUser.isAdmin) return true;

    // Owner can remove anyone
    if (currentUser.personType == PersonType.owner) return true;

    return false;
  }

  /// Check if a person can be removed based on owner count
  ///
  /// Returns true if:
  /// - The person is NOT an owner, OR
  /// - The person is an owner AND there are other owners (ownerCount > 1)
  ///
  /// This ensures at least one owner remains in the farm.
  static bool canRemoveBasedOnOwnerCount(
    Person targetPerson,
    int ownerCount,
  ) {
    // Cannot remove last owner
    if (targetPerson.personType == PersonType.owner && ownerCount <= 1) {
      return false;
    }

    return true;
  }

  /// Check if a person can change another person's type
  ///
  /// Same rules as [canEditPerson], but with additional check:
  /// - Cannot change the last owner to a different type
  static bool canChangePersonType(
    Person currentUser,
    Person targetPerson,
    PersonType newType,
    int ownerCount,
  ) {
    // First check if user can edit the target person
    if (!canEditPerson(currentUser, targetPerson)) {
      return false;
    }

    // If changing from owner to another type, check owner count
    if (targetPerson.personType == PersonType.owner &&
        newType != PersonType.owner &&
        ownerCount <= 1) {
      return false;
    }

    return true;
  }

  /// Check if a person can toggle admin privileges
  ///
  /// Returns true if the person is:
  /// - Admin, OR
  /// - Owner
  static bool canToggleAdmin(Person currentUser) {
    return currentUser.isAdmin || currentUser.personType == PersonType.owner;
  }

  /// Check if a person can view the people list
  ///
  /// All authenticated farm members can view the people list
  static bool canViewPeople(Person currentUser) {
    return true; // All members can view
  }

  /// Get a user-friendly error message when permission is denied
  static String getPermissionDeniedMessage(String action) {
    return 'You do not have permission to $action. Contact a farm owner or admin.';
  }

  /// Get a user-friendly error message for last owner protection
  static String getLastOwnerProtectionMessage() {
    return 'Cannot perform this action: at least one owner is required for the farm.';
  }

  /// Get permission level description for a person type
  static String getPermissionDescription(PersonType personType) {
    switch (personType) {
      case PersonType.owner:
        return 'Full control over farm and all operations';
      case PersonType.manager:
        return 'Manage operations, lots, and transactions';
      case PersonType.worker:
        return 'Add transactions and basic lot operations';
      case PersonType.arrendatario:
        return 'Limited access - view and add transactions only';
    }
  }

  /// Get icon for person type
  static String getPersonTypeIcon(PersonType personType) {
    switch (personType) {
      case PersonType.owner:
        return '👑';
      case PersonType.manager:
        return '👔';
      case PersonType.worker:
        return '👷';
      case PersonType.arrendatario:
        return '🤝';
    }
  }
}
