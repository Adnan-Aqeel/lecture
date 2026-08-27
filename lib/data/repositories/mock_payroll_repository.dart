import 'package:lecture/domain/repositories/payroll_repository.dart';
import 'package:lecture/data/models/models.dart';

class MockPayrollRepository implements PayrollRepository {
  @override
  Future<List<PayrollEmployee>> getPayrollEmployees() async => [
    const PayrollEmployee(sno: 1, employeeId: 'EMP001', name: 'Ali Ahmed', doj: '01 Jan 2024', monthDays: 31, workingDays: 22, present: 20, absent: 2, paidDays: 20, unpaidDays: 2, expectedHours: 176, actualHours: 168, extraHours: 0, basicSalary: 50000, salaryPerDay: 2272.73, salaryPerHour: 284.09, houseAllow: 15000, medicalAllow: 5000, travelAllow: 3000),
    const PayrollEmployee(sno: 2, employeeId: 'EMP002', name: 'Zain Malik', doj: '15 Mar 2024', monthDays: 31, workingDays: 22, present: 22, absent: 0, paidDays: 22, unpaidDays: 0, expectedHours: 176, actualHours: 180, extraHours: 4, basicSalary: 60000, salaryPerDay: 2727.27, salaryPerHour: 340.91, houseAllow: 18000, medicalAllow: 6000, travelAllow: 4000),
    const PayrollEmployee(sno: 3, employeeId: 'EMP003', name: 'Hamza Khan', doj: '01 Jun 2025', monthDays: 31, workingDays: 22, present: 18, absent: 4, paidDays: 18, unpaidDays: 4, expectedHours: 176, actualHours: 150, extraHours: 0, basicSalary: 45000, salaryPerDay: 2045.45, salaryPerHour: 255.68, houseAllow: 12000, medicalAllow: 4000, travelAllow: 2500),
  ];

  @override
  Future<List<PayrollApprovalItem>> getPayrollApprovals() async => [
    PayrollApprovalItem(id: 1, name: 'Ali Ahmed', grossSalary: 73000, totalDeductions: 5000, netAmount: 68000, status: 'Pending'),
    PayrollApprovalItem(id: 2, name: 'Zain Malik', grossSalary: 88000, totalDeductions: 6000, netAmount: 82000, status: 'Pending'),
    PayrollApprovalItem(id: 3, name: 'Hamza Khan', grossSalary: 63500, totalDeductions: 4000, netAmount: 59500, status: 'Approved'),
  ];

  @override
  Future<List<PayrollHistoryRecord>> getPayrollHistory() async => [
    const PayrollHistoryRecord(id: 1, period: 'Jul 2026', dateRange: '01 Jul - 31 Jul', status: 'Completed', employees: 45, totalBasic: 2250000, totalAllowances: 900000, totalEarnings: 3150000, totalDeductions: 225000, netSalary: 2925000),
    const PayrollHistoryRecord(id: 2, period: 'Jun 2026', dateRange: '01 Jun - 30 Jun', status: 'Completed', employees: 43, totalBasic: 2150000, totalAllowances: 860000, totalEarnings: 3010000, totalDeductions: 215000, netSalary: 2795000),
    const PayrollHistoryRecord(id: 3, period: 'May 2026', dateRange: '01 May - 31 May', status: 'Completed', employees: 42, totalBasic: 2100000, totalAllowances: 840000, totalEarnings: 2940000, totalDeductions: 210000, netSalary: 2730000),
  ];

  @override
  Future<List<DeductionRule>> getDeductionRules() async => [
    const DeductionRule(id: 1, rule: 'Late Arrival', condition: 'Check-in after 09:15 AM', value: '500 per incident', type: 'Fixed'),
    const DeductionRule(id: 2, rule: 'Absent without Leave', condition: 'No leave application', value: 'Daily Rate', type: 'Variable'),
    const DeductionRule(id: 3, rule: 'Early Departure', condition: 'Check-out before 05:00 PM', value: '250 per incident', type: 'Fixed'),
    const DeductionRule(id: 4, rule: 'PF Contribution', condition: 'Employee share 12%', value: '12% of Basic', type: 'Percentage'),
  ];
}
