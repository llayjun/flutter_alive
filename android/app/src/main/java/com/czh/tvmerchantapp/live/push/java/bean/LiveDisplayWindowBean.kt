package com.czh.tvmerchantapp.live.push.java.bean

data class LiveDisplayWindowBean(
        var displayWindow: String,
        val id: String,
        val img: String,
        val name: String,
        val originPrice: Double,
        val price: Double,
        val productId: String,
        val saleAmount: Int,
        val status: String,
        val totalStockNum: Int
)