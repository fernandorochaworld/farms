# Step 6: Weight Tracking - Feature 004

## Overview

Implement weight history tracking for cattle lots with charts, Average Daily Gain (ADG) calculations, and weight progression analysis.

## Goals

- Record weight history per lot (averaged per lot)
- Display weight progression charts
- Calculate Average Daily Gain (ADG)
- Track weight trends
- Generate weight-based insights

## Implementation Checklist

### Weight History Listing
- [ ] Create WeightHistoryScreen UI
  - [ ] Display weight records for a lot
  - [ ] Show date and average weight
  - [ ] Add floating action button to add record
  - [ ] Add chronological sorting
  - [ ] Show weight change indicators
  - [ ] Add date filtering
  - [ ] Show empty state
- [ ] Create WeightRecordCard widget
- [ ] Implement WeightHistoryController/Bloc
- [ ] Add widget tests

### Weight Entry
- [ ] Create WeightEntryForm UI
  - [ ] Add date picker
  - [ ] Add average weight input (kg per head)
  - [ ] Show current lot quantity
  - [ ] Add notes field
  - [ ] Add form validation
- [ ] Implement weight entry logic
- [ ] Validate weight (> 0, reasonable range)
- [ ] Add widget tests

### Weight Chart
- [ ] Create WeightChartWidget
  - [ ] Line chart showing progression
  - [ ] X-axis: dates
  - [ ] Y-axis: weight (kg)
  - [ ] Add data points
  - [ ] Add trend line
  - [ ] Add zoom/pan capabilities
  - [ ] Show weight gain/loss colors
- [ ] Implement using fl_chart or similar
- [ ] Add widget tests

### ADG Calculation
- [ ] Create ADGCalculator service
  - [ ] Formula: (final_weight - initial_weight) / days
  - [ ] Calculate between any two dates
  - [ ] Calculate for entire lot history
  - [ ] Calculate for date ranges
- [ ] Display ADG in UI
  - [ ] In lot details
  - [ ] In weight history
  - [ ] In statistics
- [ ] Add unit tests

### Weight Statistics
- [ ] Calculate weight statistics
  - [ ] Current average weight
  - [ ] Initial weight
  - [ ] Total weight gain/loss
  - [ ] Average daily gain
  - [ ] Best performing period
  - [ ] Weight distribution
- [ ] Create WeightStatisticsCard
- [ ] Add unit tests

### Weight Comparison
- [ ] Create comparison view
  - [ ] Compare multiple lots
  - [ ] Compare weight goals vs actual
  - [ ] Show relative performance
- [ ] Add comparison charts
- [ ] Add widget tests

### Testing
- [ ] Unit tests for ADG calculations
- [ ] Unit tests for statistics
- [ ] Widget tests for all screens
- [ ] Integration tests for weight flow
- [ ] Target: >70% coverage

## UI Screens

### Weight History

```
┌─────────────────────────────────┐
│  ←  Weight History          [+] │
├─────────────────────────────────┤
│                                 │
│  📊 Current: 245 kg             │
│  ↑ Total Gain: +65 kg           │
│  📈 ADG: 0.76 kg/day            │
│                                 │
│  [Chart View] [List View]       │
│                                 │
│  ┌─────────────────────────┐   │
│  │     Weight Chart        │   │
│  │                         │   │
│  │ 250kg ┤     ╱           │   │
│  │ 220kg ┤   ╱             │   │
│  │ 190kg ┤ ╱               │   │
│  │       └─────────────    │   │
│  │       Jan Feb Mar       │   │
│  └─────────────────────────┘   │
│                                 │
│  Records:                       │
│  ┌─────────────────────────┐   │
│  │ 2025-10-07              │   │
│  │ 245 kg  ↑ +5 kg        │   │
│  └─────────────────────────┘   │
│  ┌─────────────────────────┐   │
│  │ 2025-09-30              │   │
│  │ 240 kg  ↑ +8 kg        │   │
│  └─────────────────────────┘   │
│                                 │
└─────────────────────────────────┘
```

## Completion Criteria

- [ ] Weight recording functional
- [ ] Charts displaying correctly
- [ ] ADG calculations accurate
- [ ] Statistics showing properly
- [ ] All tests passing
- [ ] Code reviewed

## Next Step

**[Step 7: Goals Management](004-step7-goals.md)**

---

**Step:** 6/10
**Estimated Time:** 3 days
**Dependencies:** Steps 1-5
