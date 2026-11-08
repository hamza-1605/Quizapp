import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/features/quiz/domain/services/balanced_quotas.dart';

void main() {
  final random = Random(1);

  int sum(Map<int, int> quotas) => quotas.values.fold(0, (a, b) => a + b);

  test('splits 10 questions between 3 categories as 4, 3, 3', () {
    final quotas = calculateBalancedQuotas(
      total: 10,
      available: {1: 30, 2: 30, 3: 30},
      random: random,
    );
    expect(quotas.values.toList()..sort(), [3, 3, 4]);
  });


  test('gives a single category everything', () {
    final quotas = calculateBalancedQuotas(
      total: 20,
      available: {7: 30},
      random: random,
    );
    expect(quotas, {7: 20});
  });


  test('a short category gives its unused share to the others', () {
    final quotas = calculateBalancedQuotas(
      total: 10,
      available: {1: 2, 2: 30},
      random: random,
    );
    expect(quotas, {1: 2, 2: 8});
  });


  test('never asks for more questions than exist', () {
    final quotas = calculateBalancedQuotas(
      total: 30,
      available: {1: 5, 2: 5},
      random: random,
    );
    expect(quotas, {1: 5, 2: 5});
    expect(sum(quotas), 10);
  });


  test('ignores categories without questions', () {
    final quotas = calculateBalancedQuotas(
      total: 10,
      available: {1: 0, 2: 30},
      random: random,
    );
    expect(quotas, {1: 0, 2: 10});
  });


  test('works with no categories', () {
    final quotas = calculateBalancedQuotas(
      total: 10,
      available: {},
      random: random,
    );
    expect(quotas, isEmpty);
  });
}