import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_temp_bloc/views/home_page.dart';

import '../../core/theme/app_text_style.dart';
import '../../viewmodels/index_cubit/index_cubit.dart';
import '../../viewmodels/index_cubit/index_state.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});
  final List<Widget> pages = const [HomePage(), HomePage(), HomePage()];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IndexCubit(),
      child: BlocBuilder<IndexCubit, IndexState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              centerTitle: true,
              title: Text('Flutter Template Bloc', style: MyTextStyles.bold24),
            ),
            body: pages[state.selectedIndexPage],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.selectedIndexPage,
              onTap: (index) => context.read<IndexCubit>().changePage(index),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
