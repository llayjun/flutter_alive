package com.czh.tvmerchantapp.live.push.chat.bean

data class ChatMessageBean(
        val content: String,
        val createdAt: String,
        val id: String,
        val nickname: String,
        val onlineCount: String,
        val roomId: String,
        val roomName: String
)