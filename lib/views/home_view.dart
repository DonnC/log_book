import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:log_book/components/index.dart';
import 'package:log_book/utils/index.dart';
import 'package:momentum/momentum.dart';
import 'package:relative_scale/relative_scale.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends MomentumState<HomeView> {
  HomeViewController _homeViewController;

  @override
  void initMomentumState() {
    _homeViewController = Momentum.controller<HomeViewController>(context);
    super.initMomentumState();
  }

  @override
  Widget build(BuildContext context) {
    return RouterPage(
      child: SafeArea(
        child: RelativeBuilder(
          builder: (context, height, width, sy, sx) {
            return Scaffold(
              body: MomentumBuilder(
                controllers: [HomeViewController],
                builder: (context, snapshot) {
                  final model = snapshot<HomeViewModel>();

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(sy(13)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Dashboard',
                                    style: kStyle(
                                      size: sy(25),
                                      color: Colors.white,
                                    ),
                                  ),
                                  Spacer(),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blue,
                                      minimumSize: Size(
                                        sy(80),
                                        sy(50),
                                      ),
                                    ),
                                    onPressed: () {
                                      // TODO: goto printing page
                                    },
                                    icon: Icon(Feather.printer),
                                    label: Text(
                                      'Print LogBook',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: sy(40)),
                              Row(
                                children: [
                                  Text(
                                    'My TODOs',
                                    style: kStyle(
                                      size: sy(25),
                                      color: Colors.white,
                                    ),
                                  ),
                                  Spacer(),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blue,
                                      minimumSize: Size(
                                        sy(80),
                                        sy(40),
                                      ),
                                    ),
                                    onPressed: () {
                                      // TODO: add new todo
                                    },
                                    icon: Icon(AntDesign.addfile),
                                    label: Text(
                                      'New ToDo',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: sy(125),
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Container(
                                        //  height: sy(120),
                                        width: sy(180),
                                        padding: EdgeInsets.all(defaultPadding),
                                        decoration: BoxDecoration(
                                          color: secondaryColor,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                height: sy(30),
                                                width: sy(30),
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: bgColor,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    AntDesign.delete,
                                                    color: textColor,
                                                    size: sy(13),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            Text(
                                              'Submit Arrival Form\nTo Manager in charge',
                                              style: kStyle(
                                                size: 15,
                                                color: whiteColor,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                '17 May 2021',
                                                style: kStyle(
                                                  size: 11,
                                                  color: textColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (_, index) =>
                                      SizedBox(width: sy(20)),
                                  itemCount: 9,
                                ),
                              ),
                              SizedBox(height: sy(40)),
                              Row(
                                children: [
                                  Text(
                                    'My LogBooks',
                                    style: kStyle(
                                      size: sy(25),
                                      color: Colors.white,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    height: sy(30),
                                    width: sy(30),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Entypo.grid,
                                        color: textColor,
                                        size: sy(13),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: sy(25)),
                                  Container(
                                    height: sy(30),
                                    width: sy(30),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Entypo.list,
                                        color: textColor,
                                        size: sy(13),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: EdgeInsets.all(defaultPadding),
                                    decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: bgColor,
                                          radius: sy(30),
                                          child: Icon(
                                            Entypo.book,
                                            color: textColor,
                                            size: sy(30),
                                          ),
                                        ),
                                        SizedBox(width: sy(8)),
                                        Text(
                                          'Introduction to Company Human Resources',
                                          softWrap: true,
                                        ),
                                        Spacer(),
                                        Text(
                                          '17 May 2021',
                                          style: kStyle(
                                            size: 13,
                                            color: textColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (_, index) =>
                                    SizedBox(height: sy(25)),
                                itemCount: 9,
                              ),
                            ],
                          ),
                        ),
                        // Expanded(flex: 5, child: Text('logbook 2'),),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
