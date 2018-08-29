//
//  HttpsHeader.h
//  shangkejiaoyu
//
//  Created by Linlin Ge on 2017/6/14.
//  Copyright © 2017年 ShangKe. All rights reserved.
//

#ifndef HttpsHeader_h
#define HttpsHeader_h

/******************************
 *网络请求*
 *******************************/

#define sHTTPURL @"http://shangke.mingtaokeji.com/index.php/Api/Note204"

//正式服务器
//#define HTTPURL @"http://shangke.mingtaokeji.com/index.php"
#define HTTPURL @"http://shangke.mingtaokeji.com/index.php/Api/Note204"
#define HTTP @"http://api.mingtaokeji.com"

//测试服务器
//#define HTTPURL @"http://newapp.mingtaokeji.com/index.php"

#define skImageUrl @"http://newapp.mingtaokeji.com/"
#define skBannerUrl @"http://shangke.mingtaokeji.com/"

#define ImageURL @"http://xueyuan.mingtaokeji.com/"

/******************************
 *请求体*
 *******************************/
//banner图
#define bannerUrl @"/banner"

//课程分类
#define categoryUrl @"/category"

//视频
#define skVideoUrl @"/video"

//相关视频
#define relatedVideo @"/goods_info"

//推荐视频
#define categoryNew @"/category_new"

#define areaUrl  @"/campus"

//    $page = I('post.page','');
//    $pagesize = I('post.pagesize','');

#endif /* HttpsHeader_h */
