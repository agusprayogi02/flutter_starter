import '../../../../common/base/base_dio_remote_source.dart';
import '../../../../common/utils/api_path.dart';
import '../../../../data/models/post/post_model.dart';
import 'post_remote.dart';

class PostRemoteImpl extends BaseDioRemoteSource implements PostRemote {
  PostRemoteImpl(super.dio, super.session);

  @override
  Future<List<PostModel>> getPosts(int startIn, int limit) {
    return networkRequest(
      request: (dio) => dio.get(
        ApiPath.posts,
        queryParameters: {'_start': startIn, '_limit': limit},
      ),
      isResponseAll: true,
      onResponse: (json) => json != null
          ? (json as List)
              .map<PostModel>(
                (post) => PostModel.fromJson(post),
              )
              .toList()
          : [],
    );
  }
}
