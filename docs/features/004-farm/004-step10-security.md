# Step 10: Security & Permissions - Feature 004

## Overview

Implement comprehensive security system with role-based access control, Firestore security rules, audit logging, and permission testing.

## Goals

- Complete role-based access control (RBAC)
- Comprehensive Firestore security rules
- Audit logging for critical actions
- Permission testing and validation
- Security documentation

## Implementation Checklist

### Permission System
- [ ] Create PermissionService
  - [ ] Check user permissions
  - [ ] Get user role in farm
  - [ ] Validate action permissions
  - [ ] Cache permission checks
- [ ] Implement permission enums
  - [ ] All permission types
  - [ ] All resource types
- [ ] Add unit tests

### Permission Middleware
- [ ] Create PermissionGuard
  - [ ] Route-level protection
  - [ ] Action-level protection
  - [ ] Resource-level protection
- [ ] Implement permission decorators
- [ ] Add integration tests

### UI Permission Guards
- [ ] Implement UI permission checks
  - [ ] Hide/show buttons based on permissions
  - [ ] Disable actions when no permission
  - [ ] Show permission denied messages
- [ ] Create PermissionWidget
  - [ ] Wrap protected UI elements
  - [ ] Show fallback UI
- [ ] Add widget tests

### Firestore Security Rules
- [ ] Write complete security rules
  - [ ] Farms collection rules
  - [ ] People subcollection rules
  - [ ] Cattle lots subcollection rules
  - [ ] Transactions subcollection rules
  - [ ] Weight history subcollection rules
  - [ ] Goals subcollection rules
  - [ ] Services subcollection rules
- [ ] Implement helper functions
  - [ ] isAuthenticated()
  - [ ] isPersonInFarm()
  - [ ] getPersonType()
  - [ ] isAdmin()
  - [ ] canRead()
  - [ ] canWrite()
  - [ ] canDelete()
- [ ] Test security rules
  - [ ] Use Firebase emulator
  - [ ] Test all scenarios
  - [ ] Test edge cases

### Audit Logging
- [ ] Create AuditLogService
  - [ ] Log critical actions
  - [ ] Log permission denials
  - [ ] Log security events
  - [ ] Log data changes
- [ ] Implement AuditLog model
  - [ ] User ID
  - [ ] Action type
  - [ ] Resource type
  - [ ] Resource ID
  - [ ] Timestamp
  - [ ] Details
  - [ ] IP address (optional)
- [ ] Create AuditLogRepository
- [ ] Add audit log viewing UI (admin only)
- [ ] Add unit tests

### Critical Actions Logging
- [ ] Log farm operations
  - [ ] Farm creation
  - [ ] Farm deletion
  - [ ] Capacity changes
- [ ] Log people operations
  - [ ] Person added
  - [ ] Person removed
  - [ ] Role changes
  - [ ] Admin flag changes
- [ ] Log lot operations
  - [ ] Lot creation
  - [ ] Lot closure
  - [ ] Lot deletion
- [ ] Log transaction operations
  - [ ] High-value transactions
  - [ ] Transaction deletions
  - [ ] Quantity changes

### Permission Matrix Implementation
- [ ] Document complete permission matrix
- [ ] Implement all permission checks
- [ ] Test all combinations
- [ ] Validate against requirements

### Security Testing
- [ ] Create security test suite
  - [ ] Test authentication requirements
  - [ ] Test authorization checks
  - [ ] Test role-based access
  - [ ] Test data isolation
- [ ] Test permission boundaries
  - [ ] Test privilege escalation attempts
  - [ ] Test cross-farm access attempts
  - [ ] Test invalid permission combinations
- [ ] Load test security rules
- [ ] Penetration testing (if applicable)

### Error Handling
- [ ] Implement security error handling
  - [ ] Permission denied errors
  - [ ] Authentication errors
  - [ ] Authorization errors
- [ ] Create user-friendly error messages
- [ ] Log security errors
- [ ] Add rate limiting for failed attempts

### Data Privacy
- [ ] Implement data access controls
  - [ ] User can only see their farms
  - [ ] Person can only see their farm data
  - [ ] Proper data isolation
- [ ] Add data encryption (if needed)
- [ ] Implement data retention policies
- [ ] Add GDPR compliance features (if needed)

### Session Management
- [ ] Implement session timeout
- [ ] Add re-authentication for critical actions
- [ ] Implement device management
- [ ] Add concurrent session handling

### Security Documentation
- [ ] Document security architecture
- [ ] Create security guidelines
- [ ] Document permission matrix
- [ ] Create troubleshooting guide
- [ ] Document audit log usage

### Security Monitoring
- [ ] Implement security monitoring
  - [ ] Failed authentication attempts
  - [ ] Permission denial patterns
  - [ ] Suspicious activities
- [ ] Create security dashboard (admin)
- [ ] Add alerting for security events

### Compliance
- [ ] Document compliance measures
- [ ] Implement required controls
- [ ] Add compliance reporting
- [ ] Regular security audits

## Permission Matrix

| Action | Owner | Manager | Worker | Arrendatario | Admin |
|--------|-------|---------|--------|--------------|-------|
| **Farm** |
| View | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create | ✓ | ✗ | ✗ | ✗ | ✓ |
| Edit | ✓ | ✓ | ✗ | ✗ | ✓ |
| Delete | ✓ | ✗ | ✗ | ✗ | ✓ |
| **People** |
| View | ✓ | ✓ | ✓ | ✓ | ✓ |
| Add | ✓ | ✓ | ✗ | ✗ | ✓ |
| Edit | ✓ | ✓ | ✗ | ✗ | ✓ |
| Remove | ✓ | ✗ | ✗ | ✗ | ✓ |
| **Lots** |
| View | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create | ✓ | ✓ | ✓ | ✓ | ✓ |
| Edit | ✓ | ✓ | ✓ | ✗ | ✓ |
| Close | ✓ | ✓ | ✗ | ✗ | ✓ |
| Delete | ✓ | ✓ | ✗ | ✗ | ✓ |
| **Transactions** |
| View | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create | ✓ | ✓ | ✓ | ✓ | ✓ |
| Edit | ✓ | ✓ | ✗ | ✗ | ✓ |
| Delete | ✓ | ✓ | ✗ | ✗ | ✓ |
| **Weight History** |
| View | ✓ | ✓ | ✓ | ✓ | ✓ |
| Add | ✓ | ✓ | ✓ | ✓ | ✓ |
| Edit | ✓ | ✓ | ✗ | ✗ | ✓ |
| Delete | ✓ | ✓ | ✗ | ✗ | ✓ |
| **Goals** |
| View | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create | ✓ | ✓ | ✗ | ✗ | ✓ |
| Edit | ✓ | ✓ | ✗ | ✗ | ✓ |
| Delete | ✓ | ✓ | ✗ | ✗ | ✓ |
| **Services** |
| View | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create | ✓ | ✓ | ✓ | ✗ | ✓ |
| Edit | ✓ | ✓ | ✗ | ✗ | ✓ |
| Delete | ✓ | ✓ | ✗ | ✗ | ✓ |
| **Reports** |
| View | ✓ | ✓ | ✓ | ✓ | ✓ |
| Generate | ✓ | ✓ | ✓ | ✗ | ✓ |
| Export | ✓ | ✓ | ✓ | ✗ | ✓ |
| **Audit Logs** |
| View | ✓ | ✗ | ✗ | ✗ | ✓ |

## Firestore Security Rules (Complete)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }

    function getUserId() {
      return request.auth.uid;
    }

    function isPersonInFarm(farmId) {
      return exists(/databases/$(database)/documents/farms/$(farmId)/people/$(getUserId()));
    }

    function getPersonData(farmId) {
      return get(/databases/$(database)/documents/farms/$(farmId)/people/$(getUserId())).data;
    }

    function getPersonType(farmId) {
      return getPersonData(farmId).person_type;
    }

    function isAdmin(farmId) {
      return getPersonData(farmId).is_admin == true;
    }

    function isOwner(farmId) {
      return getPersonType(farmId) == 'Owner';
    }

    function isOwnerOrManager(farmId) {
      let personType = getPersonType(farmId);
      return personType == 'Owner' || personType == 'Manager';
    }

    function canRead(farmId) {
      return isAuthenticated() && isPersonInFarm(farmId);
    }

    function canWrite(farmId) {
      return isAdmin(farmId) || isOwnerOrManager(farmId);
    }

    function canDelete(farmId) {
      return isAdmin(farmId) || isOwner(farmId);
    }

    // Farms collection
    match /farms/{farmId} {
      allow read: if canRead(farmId);
      allow create: if isAuthenticated();
      allow update: if canWrite(farmId);
      allow delete: if canDelete(farmId);

      // People subcollection
      match /people/{personId} {
        allow read: if canRead(farmId);
        allow create: if canWrite(farmId);
        allow update: if canWrite(farmId);
        allow delete: if canDelete(farmId);
      }

      // Cattle lots subcollection
      match /cattle_lots/{lotId} {
        allow read: if canRead(farmId);
        allow create: if isAuthenticated() && isPersonInFarm(farmId);
        allow update: if canWrite(farmId) || getPersonType(farmId) == 'Worker';
        allow delete: if canDelete(farmId);

        // Transactions subcollection
        match /transactions/{transactionId} {
          allow read: if canRead(farmId);
          allow create: if isAuthenticated() && isPersonInFarm(farmId);
          allow update: if canWrite(farmId);
          allow delete: if canDelete(farmId);
        }

        // Weight history subcollection
        match /weight_history/{weightId} {
          allow read: if canRead(farmId);
          allow create: if isAuthenticated() && isPersonInFarm(farmId);
          allow update: if canWrite(farmId);
          allow delete: if canDelete(farmId);
        }
      }

      // Goals subcollection
      match /goals/{goalId} {
        allow read: if canRead(farmId);
        allow create: if canWrite(farmId);
        allow update: if canWrite(farmId);
        allow delete: if canDelete(farmId);
      }

      // Services subcollection
      match /services/{serviceId} {
        allow read: if canRead(farmId);
        allow create: if canWrite(farmId) || getPersonType(farmId) == 'Worker';
        allow update: if canWrite(farmId);
        allow delete: if canDelete(farmId);
      }

      // Audit logs subcollection (admin only)
      match /audit_logs/{logId} {
        allow read: if isAdmin(farmId);
        allow create: if isAuthenticated();
        allow update: if false; // Audit logs are immutable
        allow delete: if false; // Audit logs cannot be deleted
      }
    }
  }
}
```

## Code Examples

### PermissionService

```dart
class PermissionService {
  final PersonRepository _personRepo;
  final Map<String, Person> _cache = {};

  Future<bool> canPerformAction({
    required String userId,
    required String farmId,
    required PermissionAction action,
  }) async {
    try {
      final person = await _getPersonWithCache(userId, farmId);

      // Admin can do everything
      if (person.isAdmin) return true;

      // Check specific permissions based on person type
      return _checkPermission(person.personType, action);
    } catch (e) {
      return false;
    }
  }

  Future<Person> _getPersonWithCache(String userId, String farmId) async {
    final key = '$userId-$farmId';
    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }

    final person = await _personRepo.getByUserIdAndFarmId(userId, farmId);
    _cache[key] = person;
    return person;
  }

  bool _checkPermission(PersonType type, PermissionAction action) {
    switch (type) {
      case PersonType.owner:
        return _ownerPermissions.contains(action);
      case PersonType.manager:
        return _managerPermissions.contains(action);
      case PersonType.worker:
        return _workerPermissions.contains(action);
      case PersonType.arrendatario:
        return _arrendatarioPermissions.contains(action);
    }
  }

  static const _ownerPermissions = {
    PermissionAction.viewFarm,
    PermissionAction.editFarm,
    PermissionAction.deleteFarm,
    PermissionAction.addPerson,
    PermissionAction.editPerson,
    PermissionAction.removePerson,
    // ... all permissions
  };

  // Define other permission sets...
}

enum PermissionAction {
  viewFarm,
  editFarm,
  deleteFarm,
  addPerson,
  editPerson,
  removePerson,
  createLot,
  editLot,
  closeLot,
  deleteLot,
  createTransaction,
  editTransaction,
  deleteTransaction,
  // ... all actions
}
```

### AuditLogService

```dart
class AuditLogService {
  final AuditLogRepository _auditLogRepo;

  Future<void> logAction({
    required String userId,
    required String farmId,
    required AuditAction action,
    required String resourceType,
    required String resourceId,
    Map<String, dynamic>? details,
  }) async {
    final log = AuditLog(
      id: uuid.v4(),
      userId: userId,
      farmId: farmId,
      action: action,
      resourceType: resourceType,
      resourceId: resourceId,
      timestamp: DateTime.now(),
      details: details ?? {},
    );

    await _auditLogRepo.create(log);
  }

  Future<void> logFarmCreated(String userId, Farm farm) async {
    await logAction(
      userId: userId,
      farmId: farm.id,
      action: AuditAction.create,
      resourceType: 'farm',
      resourceId: farm.id,
      details: {'name': farm.name},
    );
  }

  Future<void> logPermissionDenied({
    required String userId,
    required String farmId,
    required String action,
  }) async {
    await logAction(
      userId: userId,
      farmId: farmId,
      action: AuditAction.permissionDenied,
      resourceType: 'permission',
      resourceId: action,
      details: {'attempted_action': action},
    );
  }
}

enum AuditAction {
  create,
  update,
  delete,
  permissionDenied,
  login,
  logout,
}
```

## Testing

### Security Rules Tests

```dart
void main() {
  group('Firestore Security Rules', () {
    test('Owner can edit farm', () async {
      // Setup: Create owner person
      // Test: Attempt farm edit
      // Assert: Edit succeeds
    });

    test('Worker cannot delete lot', () async {
      // Setup: Create worker person
      // Test: Attempt lot deletion
      // Assert: Permission denied
    });

    test('User cannot access other farms', () async {
      // Setup: User in Farm A
      // Test: Attempt to read Farm B
      // Assert: Permission denied
    });
  });
}
```

## Completion Criteria

- [ ] Permission system fully implemented
- [ ] All Firestore security rules deployed
- [ ] Audit logging functional
- [ ] All permission checks enforced
- [ ] Security tests passing
- [ ] Documentation complete
- [ ] Security review completed
- [ ] Penetration testing done (if required)
- [ ] Code reviewed

## Final Steps

After completing this step:
1. Perform full system testing
2. Security audit
3. Performance testing
4. User acceptance testing
5. Deploy to production

---

**Step:** 10/10
**Estimated Time:** 3-4 days
**Dependencies:** Steps 1-9
**Status:** Final step - ready to implement
