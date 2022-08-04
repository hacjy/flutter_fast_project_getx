import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

Widget refresh({
  OnRefreshCallback? onRefresh,
  required Widget child,
  OnRefreshCallback? onLoad,
  required EasyRefreshController refreshController,
  bool? firstRefresh,
}) =>
    EasyRefresh(
      enableControlFinishLoad: true,
      enableControlFinishRefresh: true,
      controller: refreshController,
      header: ClassicalHeader(
        //   refreshText: '下拉刷新',
        //   refreshReadyText: '准备刷新',
        //   refreshingText: '刷新中...',
        //   refreshedText: '刷新完成',
        bgColor: Colors.transparent,
        textColor: Colors.black87,
        showInfo: false,
        //   refreshFailedText: '刷新失败!',
        completeDuration: const Duration(seconds: 0),
      ),
      onRefresh: onRefresh,
      footer: ClassicalFooter(
        //   loadText: '上拉加载',
        //   loadReadyText: '准备加载',
        //   loadingText: '加载中...',
        //   loadedText: '加载完成',
        //   noMoreText: '--我也是有底线的--',
        bgColor: Colors.transparent,
        textColor: Colors.black87,
        showInfo: false,
        //   loadFailedText: '加载失败!',
        completeDuration: const Duration(seconds: 0),
      ),
      onLoad: onLoad,
      child: child,
      firstRefresh: firstRefresh ?? true,
      // firstRefreshWidget: Center(child: CupertinoActivityIndicator()),
      emptyWidget: null,
    );
