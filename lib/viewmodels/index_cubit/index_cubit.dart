import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_temp_bloc/viewmodels/index_cubit/index_state.dart';

class IndexCubit extends Cubit<IndexState> {
  IndexCubit() : super(const IndexState(selectedIndexPage: 0));

  void changePage(int index) {
    emit(state.copyWith(selectedIndexPage: index));
  }
}
