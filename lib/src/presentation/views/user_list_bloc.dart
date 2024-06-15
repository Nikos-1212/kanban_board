import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/src/utils/utils.dart';
import '../blocs/get_user_bloc/getuser_bloc.dart';

class UserPageList extends StatelessWidget {
  const UserPageList(this.limit, this.offset, {super.key});

  final int offset;
  final int limit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppConst.userList,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<GetuserBloc, GetuserState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is GetuserLoding) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetuserError) {
              return Center(child: Text(state.error));
            } else if (state is GetuserLodded) {
              final res = state.userModel.users ?? [];
              return RefreshIndicator(
                onRefresh: () async {
                  try {
                    await Future.delayed(const Duration(
                        milliseconds: 1000)); //Showing bottom Loading
                    context
                        .read<GetuserBloc>()
                        .add(const InitialGetuserEvent(1, 20));
                    // context.read<GetuserBloc>().refreshController.refreshCompleted();
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
                child: ListView.builder(
                    itemCount: res.length +
                        context.select(
                            (GetuserBloc bloc) => bloc.isLoading ? 1 : 0),
                    // itemCount:context.read<GetuserBloc>().isLoading ? res.length+1:res.length,
                    controller: context.read<GetuserBloc>().scrollController,
                    itemBuilder: (context, int index) {
                      if (index < res.length) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                if (res[index].profilePicture == '') ...[
                                  CircleAvatar(
                                    radius: 32.5,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                    child: Center(
                                      child: Text(
                                        '${res[index].firstName?[0].toUpperCase()}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  )
                                ] else ...[
                                  CircleAvatar(
                                    radius: 32.5,
                                    backgroundImage: CachedNetworkImageProvider(
                                      res[index].profilePicture ?? '',
                                    ),
                                  ),
                                ],
                                const SizedBox(
                                  width: 12,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Text(res[index].firstName ?? '')],
                                )
                              ],
                            ),
                            const Divider(),
                          ],
                        );
                      } else {
                        return Container(
                          height: 50,
                          width: 50,
                          // Adjust the height of the loading indicator
                          alignment: Alignment.bottomCenter,
                          child: const CupertinoActivityIndicator(
                            color: Colors.black,
                          ),
                        );
                      }
                    }),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
