# Step 3: People Management - Feature 004

## Overview

Implement people management for farms, allowing farm owners/managers to add, edit, and manage personnel with different roles and permissions.

## Goals

- Create CRUD operations for farm people
- Implement role assignment (Owner, Manager, Worker, Arrendatario)
- Link users to farms through Person records
- Enable admin flag management
- Display people list per farm

## Implementation Checklist

### People Listing
- [x] Create PeopleListScreen UI
  - [x] Display list of people for a farm
  - [x] Show person name, type, and admin status
  - [x] Add floating action button to add person
  - [x] Add search functionality
  - [x] Add filter by person type
  - [x] Show empty state
  - [x] Add pull-to-refresh
- [x] Create PersonCard/PersonTile widget
  - [x] Display person info
  - [x] Show role badge
  - [x] Show admin indicator
  - [x] Add tap to view details
  - [x] Add swipe actions (edit, remove)
- [x] Implement PeopleListController/Bloc
  - [x] Fetch people by farm ID
  - [x] Handle real-time updates
  - [x] Implement search and filter
- [ ] Add widget tests

### Person Creation
- [x] Create PersonFormScreen (create mode) UI
  - [x] Add name input field
  - [x] Add description text area
  - [x] Add person type selector (dropdown/radio)
  - [x] Add admin toggle switch
  - [x] Add user search/link field (optional for existing users)
  - [x] Add form validation
  - [x] Add submit button
- [x] Implement PersonController/Bloc
  - [x] Handle form submission
  - [x] Validate data
  - [x] Create person record
  - [x] Handle success/error states
- [ ] Add user search functionality
  - [ ] Search by email or username
  - [ ] Link existing user to farm
  - [ ] Auto-fill name if user exists
- [ ] Add widget tests

### Person Details
- [x] Create PersonDetailsScreen UI
  - [x] Display person information
  - [x] Show associated user info
  - [x] Display activity log (future)
  - [x] Add edit button
  - [x] Add remove button
- [x] Implement PersonDetailsController/Bloc
  - [x] Fetch person by ID
  - [x] Handle real-time updates
- [ ] Add widget tests

### Person Editing
- [x] Create PersonFormScreen (edit mode) UI
  - [x] Pre-populate form with person data
  - [x] Allow editing all fields except user_id
  - [x] Add form validation
  - [x] Add save button
- [x] Implement edit logic in controller
  - [x] Update person record
  - [x] Handle success/error states
- [ ] Add widget tests

### Person Removal
- [x] Implement removal confirmation dialog
  - [x] Show warning message
  - [x] Prevent removing last owner
  - [x] Add confirm and cancel buttons
- [x] Implement removal logic
  - [x] Validate can be removed
  - [x] Delete person record
  - [x] Handle errors
- [ ] Add widget tests

### Permission Validation
- [x] Implement permission checks
  - [x] Only Owner/Manager can add people
  - [x] Only Owner/Manager can edit people
  - [x] Only Owner can remove people
  - [x] Admin can override
- [x] Add UI permission guards
  - [x] Hide/disable buttons based on permissions
  - [x] Show permission denied messages
- [ ] Add backend validation (Firestore rules)

### Person Type Management
- [x] Create PersonType enum
  - [x] Owner
  - [x] Manager
  - [x] Worker
  - [x] Arrendatario
- [x] Create PersonTypeSelector widget
  - [x] Display all types with descriptions
  - [x] Add icons for each type
  - [x] Handle selection
- [x] Add type-specific validation
  - [x] At least one Owner required
  - [x] Validate permissions for type changes

### User Linking
- [ ] Implement user search
  - [ ] Search by email
  - [ ] Search by username
  - [ ] Display search results
- [ ] Create user invite system (future)
  - [ ] Send invitation email
  - [ ] Generate invitation code
  - [ ] Handle invitation acceptance
- [ ] Handle unlinking user
  - [ ] Validation before unlinking
  - [ ] Preserve person record data

### State Management
- [x] Create PersonState
  - [x] PersonInitial
  - [x] PersonLoading
  - [x] PersonLoaded
  - [x] PersonError
  - [x] PersonOperationInProgress
  - [x] PersonOperationSuccess
  - [x] PersonOperationFailure
- [x] Create PersonEvent
  - [x] LoadPeople
  - [x] LoadPersonDetails
  - [x] CreatePerson
  - [x] UpdatePerson
  - [x] RemovePerson
  - [x] SearchUsers
- [x] Implement PersonBloc

### Validation
- [x] Person name validation
  - [x] Required, 3-100 characters
- [x] Person type validation
  - [x] Required, must be valid enum
- [x] User ID validation
  - [x] Must exist in users collection
  - [x] Cannot duplicate in same farm
- [x] At least one owner rule
  - [x] Prevent removing last owner
  - [x] Prevent changing last owner to different type

### Internationalization
- [x] Add translation keys for people screens
- [x] Add person type labels
- [x] Add validation messages
- [x] Add confirmation messages

### Testing
- [ ] Unit tests for PersonBloc
- [ ] Unit tests for validation logic
- [ ] Widget tests for all screens
- [ ] Widget tests for PersonCard
- [ ] Integration tests for add/edit/remove flow
- [ ] Test permission checks
- [ ] Target: >70% coverage

## UI Screens

### People List

```
┌─────────────────────────────────┐
│  ←  People (3)            [+]   │
├─────────────────────────────────┤
│  🔍 Search people...            │
│                                 │
│  ┌─────────────────────────┐   │
│  │ 👤 John Doe             │   │
│  │    Owner • Admin        │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │ 👤 Jane Smith           │   │
│  │    Manager              │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │ 👤 Bob Worker           │   │
│  │    Worker               │   │
│  └─────────────────────────┘   │
│                                 │
└─────────────────────────────────┘
```

### Add Person Form

```
┌─────────────────────────────────┐
│  ←  Add Person                  │
├─────────────────────────────────┤
│                                 │
│  Name *                         │
│  ┌─────────────────────────┐   │
│  │ John Doe                │   │
│  └─────────────────────────┘   │
│                                 │
│  Person Type *                  │
│  ┌─────────────────────────┐   │
│  │ ◉ Owner                 │   │
│  │ ○ Manager               │   │
│  │ ○ Worker                │   │
│  │ ○ Arrendatario          │   │
│  └─────────────────────────┘   │
│                                 │
│  ☑ Admin privileges             │
│                                 │
│  Description                    │
│  ┌─────────────────────────┐   │
│  │ Farm manager            │   │
│  └─────────────────────────┘   │
│                                 │
│  Link to User (optional)        │
│  ┌─────────────────────────┐   │
│  │ Search by email...      │   │
│  └─────────────────────────┘   │
│                                 │
│           [Cancel]  [Add]       │
│                                 │
└─────────────────────────────────┘
```

## Code Examples

### PersonCard Widget

```dart
class PersonCard extends StatelessWidget {
  final Person person;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onRemove;

  const PersonCard({
    Key? key,
    required this.person,
    this.onTap,
    this.onEdit,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text(person.name),
        subtitle: Row(
          children: [
            _buildTypeChip(),
            if (person.isAdmin) ...[
              const SizedBox(width: 8),
              _buildAdminBadge(),
            ],
          ],
        ),
        trailing: _buildActions(context),
        onTap: onTap,
      ),
    );
  }

  Widget _buildTypeChip() {
    return Chip(
      label: Text(_getPersonTypeLabel()),
      avatar: Icon(_getPersonTypeIcon(), size: 16),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildAdminBadge() {
    return Chip(
      label: Text('Admin'),
      backgroundColor: Colors.orange,
      visualDensity: VisualDensity.compact,
    );
  }

  // Helper methods...
}
```

## Permission Matrix Implementation

```dart
class PersonPermissionChecker {
  static bool canAddPerson(Person currentUser) {
    return currentUser.isAdmin ||
        currentUser.personType == PersonType.owner ||
        currentUser.personType == PersonType.manager;
  }

  static bool canEditPerson(Person currentUser, Person targetPerson) {
    if (currentUser.isAdmin) return true;
    if (currentUser.personType == PersonType.owner) return true;
    if (currentUser.personType == PersonType.manager &&
        targetPerson.personType != PersonType.owner) {
      return true;
    }
    return false;
  }

  static bool canRemovePerson(
    Person currentUser,
    Person targetPerson,
    int ownerCount,
  ) {
    // Cannot remove last owner
    if (targetPerson.personType == PersonType.owner && ownerCount <= 1) {
      return false;
    }

    if (currentUser.isAdmin) return true;
    if (currentUser.personType == PersonType.owner) return true;

    return false;
  }
}
```

## Firestore Security Rules Extension

```javascript
match /farms/{farmId}/people/{personId} {
  function getCurrentPerson() {
    return get(/databases/$(database)/documents/farms/$(farmId)/people/$(request.auth.uid)).data;
  }

  function isOwnerOrManager() {
    let person = getCurrentPerson();
    return person.person_type in ['Owner', 'Manager'];
  }

  function isOwner() {
    return getCurrentPerson().person_type == 'Owner';
  }

  function countOwners() {
    // This is a simplified check - in production, use a counter field
    return true; // Implement proper owner count check
  }

  allow read: if isAuthenticated() && isPersonInFarm(farmId);
  allow create: if isAuthenticated() && (isAdmin(farmId) || isOwnerOrManager());
  allow update: if isAuthenticated() && (isAdmin(farmId) || isOwnerOrManager());
  allow delete: if isAuthenticated() && (isAdmin(farmId) || isOwner()) && countOwners();
}
```

## Validation Rules

### Business Rules
1. At least one Owner required per farm
2. Cannot remove last Owner
3. User can only be linked to a farm once
4. Person name is required
5. Person type is required

### Permission Rules
1. Only Owner/Manager can add people
2. Only Owner/Manager can edit people
3. Only Owner can remove people
4. Admin can override all restrictions
5. Cannot edit owner count below 1

## Completion Criteria

- [x] All CRUD operations for people working
- [x] Person type selection working
- [x] Admin flag management working
- [x] Permission checks enforced
- [ ] User linking functional
- [x] Validation rules enforced
- [ ] All tests passing (>70% coverage)
- [x] Internationalization complete
- [ ] Code reviewed

## Next Step

After completing this step, proceed to:
**[Step 4: Cattle Lot Management](004-step4-cattle-lots.md)**

---

**Step:** 3/10
**Estimated Time:** 3-4 days
**Dependencies:** Steps 1-2
**Status:** Ready to implement
