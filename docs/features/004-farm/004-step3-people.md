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
- [ ] Create PeopleListScreen UI
  - [ ] Display list of people for a farm
  - [ ] Show person name, type, and admin status
  - [ ] Add floating action button to add person
  - [ ] Add search functionality
  - [ ] Add filter by person type
  - [ ] Show empty state
  - [ ] Add pull-to-refresh
- [ ] Create PersonCard/PersonTile widget
  - [ ] Display person info
  - [ ] Show role badge
  - [ ] Show admin indicator
  - [ ] Add tap to view details
  - [ ] Add swipe actions (edit, remove)
- [ ] Implement PeopleListController/Bloc
  - [ ] Fetch people by farm ID
  - [ ] Handle real-time updates
  - [ ] Implement search and filter
- [ ] Add widget tests

### Person Creation
- [ ] Create PersonFormScreen (create mode) UI
  - [ ] Add name input field
  - [ ] Add description text area
  - [ ] Add person type selector (dropdown/radio)
  - [ ] Add admin toggle switch
  - [ ] Add user search/link field (optional for existing users)
  - [ ] Add form validation
  - [ ] Add submit button
- [ ] Implement PersonController/Bloc
  - [ ] Handle form submission
  - [ ] Validate data
  - [ ] Create person record
  - [ ] Handle success/error states
- [ ] Add user search functionality
  - [ ] Search by email or username
  - [ ] Link existing user to farm
  - [ ] Auto-fill name if user exists
- [ ] Add widget tests

### Person Details
- [ ] Create PersonDetailsScreen UI
  - [ ] Display person information
  - [ ] Show associated user info
  - [ ] Display activity log (future)
  - [ ] Add edit button
  - [ ] Add remove button
- [ ] Implement PersonDetailsController/Bloc
  - [ ] Fetch person by ID
  - [ ] Handle real-time updates
- [ ] Add widget tests

### Person Editing
- [ ] Create PersonFormScreen (edit mode) UI
  - [ ] Pre-populate form with person data
  - [ ] Allow editing all fields except user_id
  - [ ] Add form validation
  - [ ] Add save button
- [ ] Implement edit logic in controller
  - [ ] Update person record
  - [ ] Handle success/error states
- [ ] Add widget tests

### Person Removal
- [ ] Implement removal confirmation dialog
  - [ ] Show warning message
  - [ ] Prevent removing last owner
  - [ ] Add confirm and cancel buttons
- [ ] Implement removal logic
  - [ ] Validate can be removed
  - [ ] Delete person record
  - [ ] Handle errors
- [ ] Add widget tests

### Permission Validation
- [ ] Implement permission checks
  - [ ] Only Owner/Manager can add people
  - [ ] Only Owner/Manager can edit people
  - [ ] Only Owner can remove people
  - [ ] Admin can override
- [ ] Add UI permission guards
  - [ ] Hide/disable buttons based on permissions
  - [ ] Show permission denied messages
- [ ] Add backend validation (Firestore rules)

### Person Type Management
- [ ] Create PersonType enum
  - [ ] Owner
  - [ ] Manager
  - [ ] Worker
  - [ ] Arrendatario
- [ ] Create PersonTypeSelector widget
  - [ ] Display all types with descriptions
  - [ ] Add icons for each type
  - [ ] Handle selection
- [ ] Add type-specific validation
  - [ ] At least one Owner required
  - [ ] Validate permissions for type changes

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
- [ ] Create PersonState
  - [ ] PersonInitial
  - [ ] PersonLoading
  - [ ] PersonLoaded
  - [ ] PersonError
  - [ ] PersonOperationInProgress
  - [ ] PersonOperationSuccess
  - [ ] PersonOperationFailure
- [ ] Create PersonEvent
  - [ ] LoadPeople
  - [ ] LoadPersonDetails
  - [ ] CreatePerson
  - [ ] UpdatePerson
  - [ ] RemovePerson
  - [ ] SearchUsers
- [ ] Implement PersonBloc

### Validation
- [ ] Person name validation
  - [ ] Required, 3-100 characters
- [ ] Person type validation
  - [ ] Required, must be valid enum
- [ ] User ID validation
  - [ ] Must exist in users collection
  - [ ] Cannot duplicate in same farm
- [ ] At least one owner rule
  - [ ] Prevent removing last owner
  - [ ] Prevent changing last owner to different type

### Internationalization
- [ ] Add translation keys for people screens
- [ ] Add person type labels
- [ ] Add validation messages
- [ ] Add confirmation messages

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

- [ ] All CRUD operations for people working
- [ ] Person type selection working
- [ ] Admin flag management working
- [ ] Permission checks enforced
- [ ] User linking functional
- [ ] Validation rules enforced
- [ ] All tests passing (>70% coverage)
- [ ] Internationalization complete
- [ ] Code reviewed

## Next Step

After completing this step, proceed to:
**[Step 4: Cattle Lot Management](004-step4-cattle-lots.md)**

---

**Step:** 3/10
**Estimated Time:** 3-4 days
**Dependencies:** Steps 1-2
**Status:** Ready to implement
