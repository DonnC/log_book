import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:momentum/momentum.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:log_book/widgets/index.dart';

class GithubStatsView extends StatefulWidget {
  const GithubStatsView({Key key}) : super(key: key);

  @override
  _GithubStatsViewState createState() => _GithubStatsViewState();
}

class _GithubStatsViewState extends MomentumState<GithubStatsView> {
  bool loading = false;
  GitHub github;
  List<Repository> repos = [];
  List<RepositoryCommit> commits = [];

  void update(bool val) {
    setState(() {
      loading = val ?? false;
    });
  }

  void initGithub() async {
    update(true);
    List<Repository> data = [];
    List<RepositoryCommit> commitsData = [];

    const String token = dotenv.env['GITHUB_TOKEN'];

    /* or Create a GitHub Client using an auth token */
    final _github = GitHub(auth: Authentication.withToken(token));

    Stream<Repository> _repos = _github.repositories
        .listRepositories(type: 'private', sort: 'updated', direction: 'desc');

    await for (var _repo in _repos) {
      print(_repo.fullName);
      data.add(_repo);
    }

    setState(() {
      github = _github;
      repos = data;
    });

    // load all commits
    repos.forEach((gitRepo) async {
      RepositorySlug slug = RepositorySlug(gitRepo.name, gitRepo.defaultBranch);
      Stream<RepositoryCommit> commitResults =
          github.repositories.listCommits(slug);

      await for (RepositoryCommit commit in commitResults) {
        commitsData.add(commit);
      }
    });

    setState(() {
      commits = commitsData;
    });

    update(false);
  }
  /*
  await github.repositories.listRepositories(sort: 'updated');

    RepositorySlug slug = RepositorySlug("donnc", "log_book");
    Stream<RepositoryCommit> commitResults =
        github.repositories.listCommits(slug);

    await for (RepositoryCommit commit in commitResults) {
      print(commit);
      print(commit.commit.author.date);
      print(commit.commit.message);
    }
  */

  @override
  void initMomentumState() {
    initGithub();
    super.initMomentumState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RelativeBuilder(
        builder: (context, height, width, sy, sx) {
          return CustomAppBar(
            child: Scaffold(
              appBar: AppBar(),
              body: loading
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Github repos'),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: repos.length,
                                separatorBuilder: (_, x) =>
                                    SizedBox(height: 20),
                                itemBuilder: (context, index) {
                                  Repository repo = repos[index];
                                  return Container(
                                    // height: 100,
                                    width: double.infinity,
                                    color: Colors.red,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(repo.fullName),
                                        Text(repo.description),
                                        Text(repo.name),
                                        Text('${repo.createdAt}'),
                                        Text(repo.slug().toString()),
                                        Text('${repo.updatedAt}'),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                          SizedBox(height: 30),
                          Text('Github Repo Commits'),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: commits.length,
                                separatorBuilder: (_, x) =>
                                    SizedBox(height: 20),
                                itemBuilder: (context, index) {
                                  RepositoryCommit comit = commits[index];
                                  return Container(
                                    // height: 100,
                                    width: double.infinity,
                                    color: Colors.blue,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(comit.author.name),
                                        Text(comit.commit.message),
                                        Text('${comit.commit.author.date}'),
                                      ],
                                    ),
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
