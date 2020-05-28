package com.czh.tvmerchantapp.live.push.java.bean

data class BroadInfoBean(
        val bannerCover: BannerCover,
        val beginTime: String,
        val createDate: String,
        val description: String,
        val editTime: Int,
        val endTime: String,
        val id: String,
        val minAppCodeImg: MinAppCodeImg,
        val products: List<Product>,
        val pushUrl: String,
        val squareCover: SquareCover,
        val status: String,
        val title: String,
        val totalPraise: Int,
        val totalView: Int,
        val updateDate: String,
        val sharePosterLive: String,
        val sharePosterPending: String,
        val nickname: String
)

data class BannerCover(
        val createDate: String,
        val description: Any,
        val ext: String,
        val fileId: String,
        val meta: String,
        val name: String,
        val siteId: String,
        val size: Double,
        val updateDate: String,
        val url: String,
        val visitCount: Int
)

data class MinAppCodeImg(
        val createDate: String,
        val description: Any,
        val ext: String,
        val fileId: String,
        val meta: String,
        val name: String,
        val siteId: String,
        val size: Double,
        val updateDate: String,
        val url: String,
        val visitCount: Int
)

data class Product(
        val id: String,
        val img: String,
        val name: String,
        val originPrice: Double,
        val price: Double,
        val productId: String
)

data class SquareCover(
        val createDate: String,
        val description: Any,
        val ext: String,
        val fileId: String,
        val meta: String,
        val name: String,
        val siteId: String,
        val size: Double,
        val updateDate: String,
        val url: String,
        val visitCount: Int
)