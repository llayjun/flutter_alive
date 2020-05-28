package com.czh.tvmerchantapp.base

class Api {

    companion object {
        // base url
        var BASE_URL = "https://tv.test.9daye.cn"
        
        // socket url
        // 测试地址
//        var SOCKET_URL = "https://chat.9daye.cn/"
        // 正式地址
        var SOCKET_URL = "https://chat.9daye.com.cn/"

        // 获取直播详情
        fun broadDetail(lbId: String?): String {
            return "/admin/api/live-broadcasts/$lbId"
        }

        // 获取直播橱窗展示列表
        fun liveWindowDisplayUrl(lbId: String?): String {
            return "/admin/api/live-broadcasts/$lbId/products/displayWindow"
        }

        // 获取直播关联商品列表
        fun liveProductListUrl(lbId: String?, status: String?): String {
            return "/admin/api/live-broadcasts/$lbId/products/status/$status"
        }

        // 更新关联商品橱窗展示
        fun liveWindowUpdate(id: String?, displayWindow: String?): String {
            return "/admin/api/live-broadcasts/products/$id/display-window/$displayWindow"
        }

        // 更新关联商品状态
        fun liveProductListUpdate(id: String?, status: String?): String {
            return "/admin/api/live-broadcasts/products/$id/status/$status"
        }

        // 直播中统计数据
        fun liveStatistics(lbId: String?): String {
            return "/admin/api/live-broadcasts/$lbId/statistics"
        }

        // 结束直播
        fun liveOver(lbId: String?): String {
            return "/admin/api/live-broadcasts/$lbId/closure"
        }

    }

}