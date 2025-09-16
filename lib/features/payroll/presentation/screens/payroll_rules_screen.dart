import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Data models and enums from the original file
class PayrollRule {
  final String id;
  String name;
  RuleType type;
  CalculationMethod calcMethod;
  double value;
  String? description;
  bool isAutomatic;
  String? customFormula;

  PayrollRule({
    required this.id,
    required this.name,
    required this.type,
    required this.calcMethod,
    required this.value,
    this.description,
    this.isAutomatic = false,
    this.customFormula,
  });
}

enum RuleType { allowance, deduction }

enum CalculationMethod { fixed, percentage, perHour, custom }

class PayrollRulesScreen extends StatefulWidget {
  const PayrollRulesScreen({super.key});

  @override
  State<PayrollRulesScreen> createState() => _PayrollRulesScreenState();
}

class _PayrollRulesScreenState extends State<PayrollRulesScreen> {
  // Dummy data
  final List<PayrollRule> _rules = [
    PayrollRule(
        id: '1',
        name: 'بدل مواصلات',
        type: RuleType.allowance,
        calcMethod: CalculationMethod.fixed,
        value: 500,
        description: 'بدل مواصلات شهري',
        isAutomatic: true),
    PayrollRule(
        id: '2',
        name: 'خصم تأمينات اجتماعية',
        type: RuleType.deduction,
        calcMethod: CalculationMethod.percentage,
        value: 11,
        description: 'نسبة التأمينات الاجتماعية',
        isAutomatic: true),
    PayrollRule(
        id: '3',
        name: 'مكافأة أداء',
        type: RuleType.allowance,
        calcMethod: CalculationMethod.fixed,
        value: 1000,
        description: 'مكافأة بناءً على الأداء',
        isAutomatic: false),
    PayrollRule(
        id: '4',
        name: 'خصم غياب يوم',
        type: RuleType.deduction,
        calcMethod: CalculationMethod.custom,
        value: 0,
        description: 'خصم يومي للغياب بدون إذن',
        isAutomatic: true,
        customFormula: '(basicSalary / 30) * absenceDays'),
  ];

  // Semantic Colors
  static const Color successColor = Color(0xFF10B981);
  static const Color errorColor = Color(0xFFEF4444);

  void _showRuleFormDialog({PayrollRule? rule}) {
    // Dialog logic remains mostly the same, but with updated UI
    final isEditing = rule != null;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: rule?.name ?? '');
    final valueController =
        TextEditingController(text: rule?.value.toString() ?? '');
    final descriptionController =
        TextEditingController(text: rule?.description ?? '');
    final formulaController =
        TextEditingController(text: rule?.customFormula ?? '');
    RuleType selectedType = rule?.type ?? RuleType.allowance;
    CalculationMethod selectedCalcMethod =
        rule?.calcMethod ?? CalculationMethod.fixed;
    bool isAutomatic = rule?.isAutomatic ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateInDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: Text(isEditing ? 'تعديل القاعدة' : 'إضافة قاعدة جديدة'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                          controller: nameController,
                          decoration:
                              const InputDecoration(labelText: 'اسم القاعدة'),
                          validator: (v) => v!.isEmpty ? 'مطلوب' : null),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<RuleType>(
                        value: selectedType,
                        decoration:
                            const InputDecoration(labelText: 'نوع القاعدة'),
                        items: const [
                          DropdownMenuItem(
                              value: RuleType.allowance,
                              child: Text('إضافة (Allowance)')),
                          DropdownMenuItem(
                              value: RuleType.deduction,
                              child: Text('خصم (Deduction)')),
                        ],
                        onChanged: (v) =>
                            setStateInDialog(() => selectedType = v!),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<CalculationMethod>(
                        value: selectedCalcMethod,
                        decoration:
                            const InputDecoration(labelText: 'طريقة الحساب'),
                        items: const [
                          DropdownMenuItem(
                              value: CalculationMethod.fixed,
                              child: Text('مبلغ ثابت')),
                          DropdownMenuItem(
                              value: CalculationMethod.percentage,
                              child: Text('نسبة مئوية (%)')),
                          DropdownMenuItem(
                              value: CalculationMethod.perHour,
                              child: Text('لكل ساعة')),
                          DropdownMenuItem(
                              value: CalculationMethod.custom,
                              child: Text('معادلة مخصصة')),
                        ],
                        onChanged: (v) =>
                            setStateInDialog(() => selectedCalcMethod = v!),
                      ),
                      const SizedBox(height: 16),
                      if (selectedCalcMethod != CalculationMethod.custom)
                        TextFormField(
                            controller: valueController,
                            decoration:
                                const InputDecoration(labelText: 'القيمة'),
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.isEmpty ? 'مطلوب' : null),
                      if (selectedCalcMethod == CalculationMethod.custom)
                        TextFormField(
                            controller: formulaController,
                            decoration: const InputDecoration(
                                labelText: 'المعادلة المخصصة'),
                            validator: (v) => v!.isEmpty ? 'مطلوب' : null),
                      const SizedBox(height: 16),
                      TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                              labelText: 'الوصف (اختياري)')),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('تطبيق تلقائي'),
                        value: isAutomatic,
                        onChanged: (v) =>
                            setStateInDialog(() => isAutomatic = v),
                        activeColor: successColor,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إلغاء')),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Save logic...
                      Navigator.pop(context);
                    }
                  },
                  child:
                      const Text('حفظ', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة قواعد الرواتب'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard_outlined),
            onPressed: () => GoRouter.of(context).go('/payroll'),
            tooltip: 'لوحة تحكم الرواتب',
          ),
        ],
      ),
      body: _rules.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _rules.length,
              itemBuilder: (context, index) {
                final rule = _rules[index];
                return _buildRuleCard(rule);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showRuleFormDialog,
        tooltip: 'إضافة قاعدة جديدة',
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.rule_folder_outlined,
              size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'لا توجد قواعد بعد',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'أضف أول قاعدة للبدء في بناء نظام الرواتب',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('إضافة قاعدة جديدة'),
            onPressed: _showRuleFormDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildRuleCard(PayrollRule rule) {
    final isAllowance = rule.type == RuleType.allowance;
    final color = isAllowance ? successColor : errorColor;

    String valueString;
    switch (rule.calcMethod) {
      case CalculationMethod.fixed:
        valueString = '${rule.value.toStringAsFixed(0)} EGP';
        break;
      case CalculationMethod.percentage:
        valueString = '${rule.value.toStringAsFixed(0)}%';
        break;
      case CalculationMethod.perHour:
        valueString = '${rule.value.toStringAsFixed(0)} EGP/ساعة';
        break;
      case CalculationMethod.custom:
        valueString = rule.customFormula ?? 'معادلة مخصصة';
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          rule.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (rule.isAutomatic)
                          const Chip(
                            label: Text('تلقائي'),
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                          )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      valueString,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (rule.description != null &&
                        rule.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          rule.description!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.edit_outlined,
                      color: Theme.of(context).primaryColor),
                  onPressed: () => _showRuleFormDialog(rule: rule),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: errorColor),
                  onPressed: () {
                    setState(() => _rules.remove(rule));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
