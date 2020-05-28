package com.czh.tvmerchantapp.live.push.chat

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import androidx.recyclerview.widget.RecyclerView.ViewHolder
import com.czh.tvmerchantapp.R
import com.czh.tvmerchantapp.live.push.chat.bean.ChatMessageBean

class ChatMessageAdapter(context: Context, messages: List<ChatMessageBean>) : RecyclerView.Adapter<ChatMessageAdapter.MyViewHolder>() {

    // 消息
    private val mMessages: List<ChatMessageBean> = messages

    // 随机颜色
    private val mUsernameColors: IntArray = context.resources.getIntArray(R.array.username_colors)

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        var layout = -1
        layout = R.layout.item_chat_message
//        when (viewType) {
//            Message.TYPE_MESSAGE -> layout = R.layout.item_chat_message
//            Message.TYPE_LOG -> layout = R.layout.item_log
//            Message.TYPE_ACTION -> layout = R.layout.item_action
//        }
        val v = LayoutInflater.from(parent.context).inflate(layout, parent, false)
        return MyViewHolder(v)
    }


    override fun getItemCount(): Int {
        return mMessages.size
    }

    override fun getItemViewType(position: Int): Int {
        return 0
    }

    override fun onBindViewHolder(holder: MyViewHolder, position: Int) {
        var message = mMessages.get(position)
        holder.setUsername(message.nickname)
        holder.setMessage(message.content)
    }

    open inner class MyViewHolder(itemView: View) : ViewHolder(itemView) {
        private val mUsernameView: TextView?
        private val mMessageView: TextView?

        init {
            mUsernameView = itemView.findViewById<View>(R.id.username) as TextView
            mMessageView = itemView.findViewById<View>(R.id.message) as TextView
        }

        fun setUsername(username: String) {
            if (null == mUsernameView) return
            mUsernameView.text = username
            mUsernameView.setTextColor(getUsernameColor(username))
        }

        fun setMessage(message: String?) {
            if (null == mMessageView) return
            mMessageView.text = message
        }

        private fun getUsernameColor(username: String): Int {
            var hash = 7
            var i = 0
            val len = username.length
            while (i < len) {
                hash = username.codePointAt(i) + (hash shl 5) - hash
                i++
            }
            val index = Math.abs(hash % mUsernameColors.size)
            return mUsernameColors[index]
        }
    }

}

