# Step 9: Reports & Analytics - Feature 004

## Overview

Implement comprehensive reporting and analytics system with data visualization, financial reports, and export capabilities.

## Goals

- Generate various reports
- Create data visualizations
- Financial analysis
- Performance metrics
- Export to PDF and CSV

## Implementation Checklist

### Reports Dashboard
- [ ] Create ReportsDashboardScreen UI
  - [ ] Display available report types
  - [ ] Show recent reports
  - [ ] Add quick stats overview
  - [ ] Add date range selector
  - [ ] Add farm selector (if multiple farms)
- [ ] Create ReportCard widget for each type
- [ ] Implement ReportDashboardController/Bloc
- [ ] Add widget tests

### Farm Overview Report
- [ ] Create FarmOverviewReport
  - [ ] Total cattle count
  - [ ] Breakdown by type
  - [ ] Active vs closed lots
  - [ ] Recent transactions summary
  - [ ] Current capacity usage
- [ ] Generate PDF version
- [ ] Add export functionality
- [ ] Add widget tests

### Financial Report
- [ ] Create FinancialReportScreen
  - [ ] Total purchases (Buy transactions)
  - [ ] Total sales (Sell transactions)
  - [ ] Net profit/loss
  - [ ] Average purchase price
  - [ ] Average sale price
  - [ ] Profit margin
  - [ ] Cost breakdown (services)
  - [ ] Monthly/yearly comparisons
- [ ] Create financial charts
  - [ ] Income vs expenses line chart
  - [ ] Profit/loss bar chart
  - [ ] Cost distribution pie chart
- [ ] Generate PDF report
- [ ] Export to CSV
- [ ] Add widget tests

### Performance Report
- [ ] Create PerformanceReportScreen
  - [ ] Weight gain statistics
  - [ ] Average Daily Gain (ADG) by lot
  - [ ] Mortality rate
  - [ ] Goal achievement rate
  - [ ] Best/worst performing lots
  - [ ] Time-based comparisons
- [ ] Create performance charts
  - [ ] Weight progression charts
  - [ ] ADG comparison charts
  - [ ] Mortality trend chart
- [ ] Generate PDF report
- [ ] Add widget tests

### Inventory Report
- [ ] Create InventoryReport
  - [ ] Current cattle count by lot
  - [ ] Cattle by type breakdown
  - [ ] Cattle by gender breakdown
  - [ ] Age distribution
  - [ ] Value estimation
- [ ] Create inventory charts
  - [ ] Distribution pie charts
  - [ ] Trend line charts
- [ ] Generate PDF report
- [ ] Export to CSV
- [ ] Add widget tests

### Transaction Report
- [ ] Create TransactionReport
  - [ ] All transactions by date range
  - [ ] Filter by type
  - [ ] Transaction summary
  - [ ] Volume analysis
  - [ ] Value analysis
- [ ] Create transaction charts
  - [ ] Transaction volume over time
  - [ ] Transaction value over time
  - [ ] Type distribution
- [ ] Generate PDF report
- [ ] Export to CSV
- [ ] Add widget tests

### Service Cost Report
- [ ] Create ServiceCostReport
  - [ ] Total costs by service type
  - [ ] Monthly cost breakdown
  - [ ] Cost trends
  - [ ] Cost per head analysis
- [ ] Create service charts
  - [ ] Cost over time
  - [ ] Type distribution
- [ ] Generate PDF report
- [ ] Export to CSV
- [ ] Add widget tests

### Custom Report Builder
- [ ] Create CustomReportBuilder UI
  - [ ] Select data sources
  - [ ] Choose metrics
  - [ ] Set date ranges
  - [ ] Select visualization types
  - [ ] Save custom report templates
- [ ] Implement report generation
- [ ] Add widget tests

### Report Generation Service
- [ ] Create ReportGenerationService
  - [ ] Aggregate data from repositories
  - [ ] Calculate metrics
  - [ ] Generate visualizations
  - [ ] Format data for export
- [ ] Implement caching for performance
- [ ] Add unit tests

### PDF Generation
- [ ] Implement PDF generation
  - [ ] Use pdf package
  - [ ] Create report templates
  - [ ] Add charts/graphs
  - [ ] Add tables
  - [ ] Add branding/headers
  - [ ] Generate multi-page reports
- [ ] Create PDFService
- [ ] Add unit tests

### CSV Export
- [ ] Implement CSV export
  - [ ] Format data properly
  - [ ] Include headers
  - [ ] Handle special characters
  - [ ] Create downloadable file
- [ ] Create CSVExportService
- [ ] Add unit tests

### Data Visualization
- [ ] Implement chart library (fl_chart)
- [ ] Create reusable chart widgets
  - [ ] LineChartWidget
  - [ ] BarChartWidget
  - [ ] PieChartWidget
  - [ ] ComboChartWidget
- [ ] Add interactive features
  - [ ] Tooltips
  - [ ] Zoom/pan
  - [ ] Legend
  - [ ] Data labels
- [ ] Add widget tests

### Report Sharing
- [ ] Implement sharing functionality
  - [ ] Share PDF via email
  - [ ] Share via messaging apps
  - [ ] Save to device
  - [ ] Upload to cloud storage
- [ ] Add share options UI
- [ ] Add widget tests

### Report Scheduling
- [ ] Implement automated reports
  - [ ] Schedule report generation
  - [ ] Email delivery
  - [ ] Frequency settings (daily/weekly/monthly)
  - [ ] Recipient management
- [ ] Create scheduling UI
- [ ] Add unit tests

### Analytics Dashboard
- [ ] Create AnalyticsDashboard
  - [ ] Key Performance Indicators (KPIs)
  - [ ] Trend indicators
  - [ ] Quick insights
  - [ ] Alert notifications
  - [ ] Comparison metrics
- [ ] Implement KPI calculations
  - [ ] Cattle per hectare
  - [ ] Revenue per head
  - [ ] Cost per head
  - [ ] Mortality rate
  - [ ] Average sale price
  - [ ] Average weight gain
- [ ] Add widget tests

### Testing
- [ ] Unit tests for ReportGenerationService
- [ ] Unit tests for data calculations
- [ ] Unit tests for PDF generation
- [ ] Unit tests for CSV export
- [ ] Widget tests for all report screens
- [ ] Integration tests for report flows
- [ ] Target: >70% coverage

## UI Screens

### Reports Dashboard

```
┌─────────────────────────────────┐
│  ←  Reports & Analytics         │
├─────────────────────────────────┤
│                                 │
│  📊 Quick Stats                 │
│  ┌────────┬────────┬────────┐  │
│  │ 150    │ 5      │ R$     │  │
│  │ Cattle │ Lots   │ 50K    │  │
│  └────────┴────────┴────────┘  │
│                                 │
│  Available Reports:             │
│                                 │
│  ┌─────────────────────────┐   │
│  │ 📄 Farm Overview        │   │
│  │ Complete farm status    │   │
│  │ [Generate PDF] [View]   │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │ 💰 Financial Report     │   │
│  │ Income, expenses, P&L   │   │
│  │ [Generate PDF] [CSV]    │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │ 📈 Performance Report   │   │
│  │ Weight gain, ADG, more  │   │
│  │ [Generate PDF] [View]   │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │ 📦 Inventory Report     │   │
│  │ Current stock breakdown │   │
│  │ [Generate PDF] [CSV]    │   │
│  └─────────────────────────┘   │
│                                 │
└─────────────────────────────────┘
```

### Financial Report

```
┌─────────────────────────────────┐
│  ←  Financial Report            │
├─────────────────────────────────┤
│  Jan 2025 - Oct 2025            │
│                                 │
│  💰 Summary                     │
│  ┌─────────────────────────┐   │
│  │ Revenue:     R$ 120,000 │   │
│  │ Expenses:    R$  80,000 │   │
│  │ Services:    R$  10,000 │   │
│  │ ───────────────────────  │   │
│  │ Net Profit:  R$  30,000 │   │
│  │ Margin:      25%        │   │
│  └─────────────────────────┘   │
│                                 │
│  📊 Income vs Expenses          │
│  ┌─────────────────────────┐   │
│  │ 150K ┤                  │   │
│  │      ┤  ╱─Income        │   │
│  │ 100K ┤ ╱                │   │
│  │      ┤╱─Expenses        │   │
│  │  50K ┤                  │   │
│  │      └──────────────    │   │
│  └─────────────────────────┘   │
│                                 │
│  📈 Cost Breakdown              │
│  [Pie Chart: Services costs]    │
│                                 │
│  [Export PDF] [Export CSV]      │
│                                 │
└─────────────────────────────────┘
```

## Code Examples

### ReportGenerationService

```dart
class ReportGenerationService {
  final FarmRepository _farmRepo;
  final CattleLotRepository _lotRepo;
  final TransactionRepository _transactionRepo;
  final FarmServiceRepository _serviceRepo;

  Future<FarmOverviewReport> generateFarmOverview(
    String farmId,
    DateTimeRange dateRange,
  ) async {
    // Fetch all data
    final farm = await _farmRepo.getById(farmId);
    final lots = await _lotRepo.getByFarmId(farmId);
    final transactions = await _transactionRepo.getByFarmIdAndDateRange(
      farmId,
      dateRange,
    );

    // Calculate metrics
    final totalCattle = lots.fold(0, (sum, lot) => sum + lot.currentQuantity);
    final activeLots = lots.where((lot) => lot.isActive).length;
    final cattleByType = _groupCattleByType(lots);

    return FarmOverviewReport(
      farm: farm,
      totalCattle: totalCattle,
      activeLots: activeLots,
      cattleByType: cattleByType,
      recentTransactions: transactions.take(10).toList(),
      dateRange: dateRange,
      generatedAt: DateTime.now(),
    );
  }

  Future<FinancialReport> generateFinancialReport(
    String farmId,
    DateTimeRange dateRange,
  ) async {
    final transactions = await _transactionRepo.getByFarmIdAndDateRange(
      farmId,
      dateRange,
    );
    final services = await _serviceRepo.getByFarmIdAndDateRange(
      farmId,
      dateRange,
    );

    // Calculate financial metrics
    final purchases = transactions
        .where((t) => t.type == TransactionType.buy)
        .fold(0.0, (sum, t) => sum + t.value);

    final sales = transactions
        .where((t) => t.type == TransactionType.sell)
        .fold(0.0, (sum, t) => sum + t.value);

    final serviceCosts = services.fold(0.0, (sum, s) => sum + s.value);

    final netProfit = sales - purchases - serviceCosts;
    final profitMargin = sales > 0 ? (netProfit / sales) * 100 : 0;

    return FinancialReport(
      revenue: sales,
      expenses: purchases,
      serviceCosts: serviceCosts,
      netProfit: netProfit,
      profitMargin: profitMargin,
      transactions: transactions,
      services: services,
      dateRange: dateRange,
      generatedAt: DateTime.now(),
    );
  }

  // Implement other report generation methods...
}
```

### PDF Generation

```dart
class PDFService {
  Future<Uint8List> generateFinancialReportPDF(
    FinancialReport report,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          _buildHeader('Financial Report'),
          _buildDateRange(report.dateRange),
          pw.SizedBox(height: 20),
          _buildFinancialSummary(report),
          pw.SizedBox(height: 20),
          _buildTransactionTable(report.transactions),
          pw.SizedBox(height: 20),
          _buildServiceTable(report.services),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildFinancialSummary(FinancialReport report) {
    return pw.Container(
      padding: pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Financial Summary', style: pw.TextStyle(fontSize: 18)),
          pw.SizedBox(height: 10),
          _buildSummaryRow('Revenue', report.revenue),
          _buildSummaryRow('Expenses', report.expenses),
          _buildSummaryRow('Service Costs', report.serviceCosts),
          pw.Divider(),
          _buildSummaryRow('Net Profit', report.netProfit, bold: true),
          _buildSummaryRow(
            'Profit Margin',
            report.profitMargin,
            suffix: '%',
          ),
        ],
      ),
    );
  }

  // Implement other PDF building methods...
}
```

## Completion Criteria

- [ ] All report types generated correctly
- [ ] Charts displaying properly
- [ ] PDF export working
- [ ] CSV export working
- [ ] Data calculations accurate
- [ ] All tests passing (>70% coverage)
- [ ] Performance optimized
- [ ] Code reviewed

## Next Step

**[Step 10: Security & Permissions](004-step10-security.md)**

---

**Step:** 9/10
**Estimated Time:** 4-5 days
**Dependencies:** Steps 1-8
