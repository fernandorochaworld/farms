# Step 7: Goals Management - Feature 004

## Overview

Implement farm goal management with progress tracking, deadline notifications, and achievement reporting.

## Goals

- Create and manage farm goals
- Track weight and birth quantity targets
- Monitor goal progress
- Send deadline reminders
- Track goal completion

## Implementation Checklist

### Goal Listing
- [ ] Create GoalListScreen UI
  - [ ] Display goals for a farm
  - [ ] Show goal type (weight/birth)
  - [ ] Display target and current progress
  - [ ] Show deadline and status
  - [ ] Add floating action button
  - [ ] Filter by status (active/completed/overdue)
  - [ ] Show empty state
- [ ] Create GoalCard widget
  - [ ] Show goal information
  - [ ] Display progress bar
  - [ ] Show status badge
  - [ ] Show days remaining
- [ ] Implement GoalListController/Bloc
- [ ] Add widget tests

### Goal Creation
- [ ] Create GoalFormScreen UI
  - [ ] Add definition date picker
  - [ ] Add target date picker
  - [ ] Add goal type selector
  - [ ] Add average weight target (optional)
  - [ ] Add birth quantity target (optional)
  - [ ] Add description field
  - [ ] Validate at least one target set
- [ ] Implement goal creation logic
- [ ] Add widget tests

### Goal Details
- [ ] Create GoalDetailsScreen UI
  - [ ] Display goal information
  - [ ] Show progress metrics
  - [ ] Display timeline
  - [ ] Add edit button
  - [ ] Add complete/cancel buttons
- [ ] Implement progress calculation
  - [ ] Compare current vs target weight
  - [ ] Compare current vs target births
  - [ ] Calculate percentage complete
- [ ] Add widget tests

### Goal Status Management
- [ ] Implement status updates
  - [ ] Active: goal in progress
  - [ ] Completed: goal achieved
  - [ ] Overdue: past deadline
  - [ ] Cancelled: manually cancelled
- [ ] Auto-update overdue status
- [ ] Manual completion marking
- [ ] Add widget tests

### Goal Notifications
- [ ] Create notification service
  - [ ] Deadline approaching (7 days)
  - [ ] Deadline approaching (1 day)
  - [ ] Goal overdue
  - [ ] Goal achieved
- [ ] Implement notification scheduling
- [ ] Add notification preferences
- [ ] Add unit tests

### Testing
- [ ] Unit tests for progress calculations
- [ ] Unit tests for status logic
- [ ] Widget tests for all screens
- [ ] Integration tests
- [ ] Target: >70% coverage

## UI Screens

### Goal List

```
┌─────────────────────────────────┐
│  ←  Goals (3)               [+] │
├─────────────────────────────────┤
│  [Active] [Completed] [Overdue] │
│                                 │
│  ┌─────────────────────────┐   │
│  │ Q1 Weight Target  ✓     │   │
│  │ Target: 250 kg avg      │   │
│  │ Current: 245 kg (98%)   │   │
│  │ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░  │   │
│  │ 5 days remaining        │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │ Birth Goal 2025   !     │   │
│  │ Target: 120 births      │   │
│  │ Current: 85 (71%)       │   │
│  │ ▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░  │   │
│  │ OVERDUE by 3 days       │   │
│  └─────────────────────────┘   │
│                                 │
└─────────────────────────────────┘
```

## Completion Criteria

- [ ] Goal CRUD functional
- [ ] Progress tracking working
- [ ] Status updates working
- [ ] Notifications functional
- [ ] All tests passing
- [ ] Code reviewed

## Next Step

**[Step 8: Services Management](004-step8-services.md)**

---

**Step:** 7/10
**Estimated Time:** 2-3 days
**Dependencies:** Steps 1-6
