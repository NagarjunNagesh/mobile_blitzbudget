import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/domain/entities/response/overview_response.dart';

void main() {
  test(
    'Should be a subclass of Equatable entity',
    () async {
      // assert
      expect(const OverviewResponse(), isA<Equatable>());
    },
  );
}
