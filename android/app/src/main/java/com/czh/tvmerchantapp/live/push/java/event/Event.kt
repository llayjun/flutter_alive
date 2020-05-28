package com.czh.tvmerchantapp.live.push.java.event

// 通知刷新橱窗
data class OnNotifyUpdateDisplay(var boolean: Boolean)

// 通知另外一个fragment刷新数据
data class OnNotifyUpdateOtherProduct(var boolean: Boolean, var status: String)

// 刷新tab顶部数字
data class OnNotifyUpdateFragmentTitle(var boolean: Boolean, var status: String, var num: Int)

// 通知点赞个数
data class OnNotifyUpdateLikeNum(var boolean: Boolean, var num: String)