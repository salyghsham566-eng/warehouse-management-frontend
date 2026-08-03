import 'package:equatable/equatable.dart';

abstract class PharmacySearchEvent extends Equatable {
  const PharmacySearchEvent();

  @override
  List<Object?> get props => const [];
}

class PharmacySearchRequested extends PharmacySearchEvent {
  const PharmacySearchRequested();
}

class PharmacySearchQueryChanged extends PharmacySearchEvent {
  const PharmacySearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}
