import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/bloc/pagination_bloc.dart';
import '../../../common/widgets/app_error_widget.dart';
import '../../../common/widgets/loading_indicator_widget.dart';
import '../../../common/widgets/row_loading_widget.dart';
import '../../../injection.dart';
import '../../components/base/base_app_bar.dart';
import '../../components/base/base_scaffold.dart';

part 'post_controller.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  static const path = "/post";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<PaginationBloc>()..add(PaginationFetch()),
      child: const PostView(),
    );
  }
}

class PostView extends StatefulWidget {
  const PostView({super.key});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  late final PostController c;

  @override
  void initState() {
    super.initState();
    c = PostController(context: context);
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: const BaseAppBar(
        title: 'Posts',
      ),
      body: BlocBuilder<PaginationBloc, PaginationState>(
        builder: (context, state) {
          switch (state.status) {
            case PaginationStatus.failure:
              return AppErrorWidget(
                message: state.errorMessage,
                onTap: () => context.read<PaginationBloc>().add(PaginationFetch()),
              );
            case PaginationStatus.success:
              if (state.posts.isEmpty) {
                return const Center(child: Text('no posts'));
              }
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int i) {
                  return i >= state.posts.length
                      ? const RowLoadingWidget()
                      : ListTile(
                          title: Text("${state.posts[i].title}"),
                          subtitle: Text("${state.posts[i].body}"),
                          leading: Text("${state.posts[i].id}"),
                        );
                },
                itemCount: c.itemCount(state),
                controller: c.scrollController,
              );
            case PaginationStatus.initial:
              return const LoadingIndicatorWidget();
          }
        },
      ),
    );
  }
}
