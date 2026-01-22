import 'package:equatable/equatable.dart';

class IndexState extends Equatable {
  final int selectedIndexPage;

  const IndexState({required this.selectedIndexPage});

  @override
  List<Object> get props => [selectedIndexPage];

  IndexState copyWith({int? selectedIndexPage}) {
    return IndexState(
      selectedIndexPage: selectedIndexPage ?? this.selectedIndexPage,
    );
  }
}
