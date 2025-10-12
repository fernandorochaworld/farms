# Farm Management System - Feature 004

## Overview

Complete farm management system that enables users to manage multiple farms, cattle lots, transactions, weight tracking, goals, services, and personnel. The system provides a comprehensive dashboard with farm summaries and detailed management capabilities for livestock operations.

## Business Context

### Core Concepts

**User → Person → Farm Relationship:**
- A User account can be associated with multiple farms through different Person records
- When a User creates a farm, they automatically become a Person (with admin role) in that farm
- Each farm can have multiple People with different roles and permissions

**Farm Structure:**
- Farms contain: People, Goals, Service History, and Cattle Lots
- Each Cattle Lot belongs to exactly one farm
- Lots cannot be transferred between farms, but cattle can be moved via transactions

**Cattle Management:**
- Cattle are managed in Lots (groups) rather than individually
- Each lot has a name (e.g., "Bezerros 2025-1")
- Lots track quantity, dates, and cattle age ranges
- Weight tracking is averaged per lot

## System Features

### Dashboard
- Real-time summary of all farms
- Cattle count by type
- Active lots overview
- Recent transactions
- Goal progress indicators
- Alerts and notifications

### Farm Management
- Create and manage multiple farms
- Set farm capacity
- Track farm personnel
- Monitor farm performance

### Cattle Lot Management
- Create and organize cattle lots
- Track cattle by type and age
- Monitor lot status and quantities
- Manage lot lifecycle (active/closed)

### Transaction Management
- Record Buy, Sell, Move, and Die transactions
- Automatic quantity updates
- Financial tracking
- Transaction history

### Weight Tracking
- Record average weight per lot
- Track weight progression over time
- Calculate average daily gain (ADG)
- Weight-based analytics

### Goals & Planning
- Set weight and birth quantity goals
- Track goal progress
- Goal deadline reminders
- Achievement reporting

### Services Management
- Track all farm services
- Record service costs
- Service scheduling
- Service history

### Reports & Analytics
- Farm overview reports
- Financial reports (income/expenses)
- Performance analytics
- Export capabilities (PDF, CSV)

### Security & Permissions
- Role-based access control
- Four person types: Owner, Manager, Worker, Arrendatario
- Admin override capability
- Audit logging

## Data Models Summary

### User
User authentication account (from Feature 003)

### Person
Farm personnel with roles and permissions

### Farm
Main farm entity containing all data

### Cattle Lot
Group of cattle tracked together

### Transaction
Cattle movement and financial records (Buy, Sell, Move, Die)

### Weight History
Historical weight data per lot

### Goal
Performance targets for the farm

### Farm Service History
Service activities and costs

## Cattle Type Definitions

Cattle are classified by age:
- **Bezerro**: até 1 ano (up to 1 year)
- **Novilho**: até 2 anos (up to 2 years)
- **Boi (3 anos)**: até 3 anos (up to 3 years)
- **Boi (4 anos)**: até 4 anos (up to 4 years)
- **Boi (5+ anos)**: 5 anos ou mais (5 years or more)

## Transaction Types

### Buy
Purchase cattle and add to a lot

### Sell
Sell cattle and remove from a lot

### Move
Transfer cattle between lots (within same farm)

### Die
Record cattle mortality

## Person Types & Roles

### Owner
Full control over farm, people, and all operations

### Manager
Manage operations, lots, and transactions

### Worker
Add transactions and basic lot operations

### Arrendatario
Limited access - view and add transactions only

**Note:** `is_admin` flag can override restrictions for any person type

## Implementation Steps

This feature is divided into progressive implementation steps:

1. **[Step 1: Foundation & Architecture](004-step1-foundation.md)**
   - Project structure
   - Data models
   - Repository pattern
   - Firestore configuration

2. **[Step 2: Farm CRUD & Dashboard](004-step2-farm-dashboard.md)**
   - Farm creation, editing, deletion
   - Basic dashboard with farm summaries
   - Navigation structure

3. **[Step 3: People Management](004-step3-people.md)**
   - Person CRUD operations
   - Role assignment
   - User-to-Person linking

4. **[Step 4: Cattle Lot Management](004-step4-cattle-lots.md)**
   - Lot creation and management
   - Lot lifecycle
   - Quantity tracking

5. **[Step 5: Transaction Management](004-step5-transactions.md)**
   - Transaction CRUD
   - Transaction type logic
   - Automatic quantity updates

6. **[Step 6: Weight Tracking](004-step6-weight-tracking.md)**
   - Weight history recording
   - Weight charts
   - ADG calculations

7. **[Step 7: Goals Management](004-step7-goals.md)**
   - Goal creation
   - Progress tracking
   - Notifications

8. **[Step 8: Services Management](004-step8-services.md)**
   - Service recording
   - Service types
   - Cost tracking

9. **[Step 9: Reports & Analytics](004-step9-reports.md)**
   - Report generation
   - Data visualization
   - Export functionality

10. **[Step 10: Security & Permissions](004-step10-security.md)**
    - Permission system
    - Firestore security rules
    - Audit logging

## Dependencies

```yaml
dependencies:
  # Firebase
  firebase_core: ^2.24.0
  firebase_auth: ^4.15.0
  cloud_firestore: ^4.13.0

  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5

  # Charts & Visualization
  fl_chart: ^0.65.0

  # PDF & Export
  pdf: ^3.10.7
  printing: ^5.11.1
  csv: ^6.0.0

  # File Management
  file_picker: ^6.1.1
  path_provider: ^2.1.1

  # Utilities
  intl: ^0.18.0
  uuid: ^4.2.2

  # UI Components
  flutter_slidable: ^3.0.1
  pull_to_refresh: ^2.0.0
  shimmer: ^3.0.0
```

## Implementation Roadmap

### Phase 1: Foundation (Weeks 1-2)
- Steps 1-2: Foundation, Farm CRUD, Basic Dashboard

### Phase 2: Core Management (Weeks 3-4)
- Steps 3-5: People, Cattle Lots, Transactions

### Phase 3: Tracking & Goals (Weeks 5-6)
- Steps 6-8: Weight Tracking, Goals, Services

### Phase 4: Analytics & Security (Weeks 7-8)
- Steps 9-10: Reports, Security
- Testing and refinements

## Testing Requirements

- Unit tests for all models and repositories
- Widget tests for all screens
- Integration tests for critical flows
- Performance testing for dashboard and reports
- Security rules testing
- Target: >70% code coverage

## Best Practices

- Follow repository pattern for data access
- Use dependency injection
- Implement proper error handling
- Follow Flutter/Dart naming conventions
- Use internationalization (Feature 001)
- Optimize Firestore queries
- Cache when appropriate
- Implement pagination for lists

## Related Features

- **Feature 001**: Internationalization
- **Feature 002**: Single Sign-On
- **Feature 003**: Login & Authentication

## Architecture Principles

### Repository Pattern
All data access through repository interfaces for:
- Easy testing with mocks
- Database migration capability
- Separation of concerns
- Code reusability

### State Management
Using flutter_bloc for:
- Predictable state changes
- Easy testing
- Clear business logic separation
- Event-driven architecture

### Security First
- Permission checks at UI and API level
- Firestore security rules enforcement
- Role-based access control
- Audit logging for critical actions

## Future Enhancements

- Offline mode with sync
- Photo attachments for lots
- GPS location tracking
- Weather integration
- Market price integration
- Breeding and genetics tracking
- Veterinary prescription management
- Feed management
- AI-based predictions
- Blockchain traceability

## References

- [Firebase Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Flutter Best Practices](https://flutter.dev/docs/development/best-practices)
- [UML Diagram](./uml-farm.png)

---

**Document Version:** 1.0
**Last Updated:** 2025-10-07
**Status:** Ready for Implementation
