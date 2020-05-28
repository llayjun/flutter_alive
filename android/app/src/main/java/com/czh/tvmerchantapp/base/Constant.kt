package com.czh.tvmerchantapp.base

import com.blankj.utilcode.util.SDCardUtils

object Constant {

    // token
    var token: String? = ""

    // 橱窗已经显示的图片数量
    var windowShowNum: Int = 0

    // 测试图片地址
    var Test_Image_Url = "http://cn.bing.com/az/hprichbg/rb/Dongdaemun_ZH-CN10736487148_1920x1080.jpg"

    // 保存图片的地址
    val PIC_PATH: String = SDCardUtils.getSDCardPathByEnvironment().toString() + "/Czh/ImageCache/"

    // 直播关联商品状态
    object ProductStatus {
        var ON_SELL = "ON_SELL"
        var ON_PENDING = "PENDING"
    }

    // 更新关联商品橱窗状态
    object WindowStatus {
        var SHOW = "SHOW"
        var HIDE = "HIDE"
    }
}