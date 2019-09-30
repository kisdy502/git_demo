import 'package:flutter/material.dart';
import 'package:git_demo/common/Git.dart';
import 'package:git_demo/common/Global.dart';
import 'package:git_demo/i10n/i18n.dart';
import 'package:git_demo/models/repo.dart';
import 'package:git_demo/widgets/MyDrawer.dart';
import 'package:git_demo/widgets/RepoItem.dart';
import 'package:provider/provider.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(S.of(context).home),
      ),
      body: Container(
        child: _buildBody(),
      ), // 构建主页面
      drawer: MyDrawer(),
    );
  }

  Widget _buildBody() {
    UserModel userModel = Provider.of<UserModel>(context);
    if (!userModel.isLogin) {
      //用户未登录，显示登录按钮
      return Center(
        child: RaisedButton(
          child: Text(S.of(context).login),
          onPressed: () => Navigator.of(context).pushNamed("login"),
        ),
      );
    } else {
      //已登录，则展示项目列表
      return InfiniteListView();
    }
  }
}

class InfiniteListView<Repo> extends StatefulWidget {
  @override
  _InfiniteListViewState createState() => new _InfiniteListViewState();
}

class _InfiniteListViewState extends State<InfiniteListView> {
  List<Repo> mList = [];

  @override
  void initState() {
    super.initState();
    _retrieveData(0, mList, false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext ctx, int index) {
        return RepoItem(mList[index]);
      },
      separatorBuilder: (context, index) => Divider(height: .0),
    );
  }

  Future<bool> _retrieveData(int page, List<Repo> items, bool refresh) async {
    var data = await Git(context).getRepos(
      refresh: refresh,
      queryParameters: {
        'page': page,
        'page_size': 20,
      },
    );
    //把请求到的新数据添加到items中
    items.addAll(data);
    // 如果接口返回的数量等于'page_size'，则认为还有数据，反之则认为最后一页
    return data.length == 20;
  }
}
