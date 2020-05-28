package com.czh.tvmerchantapp.live.push.chat

import android.os.Bundle
import android.text.TextUtils
import android.util.Log
import android.view.View
import androidx.lifecycle.ViewModelProviders
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.blankj.utilcode.util.LogUtils
import com.czh.tvmerchantapp.MyFlutterApplication
import com.czh.tvmerchantapp.R
import com.czh.tvmerchantapp.base.BaseFragment
import com.czh.tvmerchantapp.base.Constant
import com.czh.tvmerchantapp.databinding.FragmentChatInfoBinding
import com.czh.tvmerchantapp.live.push.chat.bean.ChatMessageBean
import com.czh.tvmerchantapp.live.push.java.event.OnNotifyUpdateLikeNum
import com.czh.tvmerchantapp.live.push.java.viewmodel.ALiveViewModel
import com.czh.tvmerchantapp.util.EventBusUtils
import com.google.gson.Gson
import io.socket.client.Socket
import io.socket.emitter.Emitter
import kotlinx.android.synthetic.main.fragment_chat_info.*
import org.json.JSONObject

class ChatSocketFragment : BaseFragment<ALiveViewModel, FragmentChatInfoBinding>() {

    private val TAG: String = ChatSocketFragment::class.java.getName()

    private var mSocket: Socket? = null

    var mHandler = android.os.Handler()

    // chat message adapter
    private var mChatAdapter: RecyclerView.Adapter<*>? = null
    private var mMessages: ArrayList<ChatMessageBean> = ArrayList()

    companion object {

        @JvmStatic
        fun newInstance(): ChatSocketFragment {
            val args = Bundle()
            val fragment = ChatSocketFragment()
            fragment.arguments = args
            return fragment
        }
    }

    override fun getLayoutId(): Int = R.layout.fragment_chat_info

    override fun initView(savedInstanceState: Bundle?) {
        mChatAdapter = mContext?.let { ChatMessageAdapter(it, mMessages) }
        rv_chat.layoutManager = LinearLayoutManager(activity)
        rv_chat.adapter = mChatAdapter
    }

    override fun loadData(savedInstanceState: Bundle?) {

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val application = activity?.application as MyFlutterApplication
        mSocket = application.getSocket()
        mSocket?.on(Socket.EVENT_CONNECT, onConnect)
        mSocket?.on(Socket.EVENT_DISCONNECT, onDisconnect)
        mSocket?.on(Socket.EVENT_CONNECT_ERROR, onConnectError)
        mSocket?.on(Socket.EVENT_CONNECT_TIMEOUT, onConnectTimeOut)
        mSocket?.on(EventAction.Auth, onAuth)
        mSocket?.on(EventAction.Join, onJoin)
        mSocket?.on(EventAction.Chat, onChat)
        mSocket?.on(EventAction.Enter, onEnter)
        mSocket?.on(EventAction.Leave, onLeave)
        mSocket?.on(EventAction.View, onView)
        mSocket?.on(EventAction.Like, onLike)
        mSocket?.on(EventAction.Notice, onNotice)
        mSocket?.on(EventAction.Disabled, onDisabled)
        mSocket?.on(EventAction.Disable, onDisable)
        mSocket?.on(EventAction.Enable, onEnable)
    }

    override fun onDestroy() {
        super.onDestroy()
        mSocket?.disconnect()
        mSocket?.off(Socket.EVENT_CONNECT, onConnect)
        mSocket?.off(Socket.EVENT_DISCONNECT, onDisconnect)
        mSocket?.off(Socket.EVENT_CONNECT_ERROR, onConnectError)
        mSocket?.off(Socket.EVENT_CONNECT_TIMEOUT, onConnectTimeOut)
        mSocket?.off(EventAction.Auth, onAuth)
        mSocket?.off(EventAction.Join, onJoin)
        mSocket?.off(EventAction.Chat, onChat)
        mSocket?.off(EventAction.Enter, onEnter)
        mSocket?.off(EventAction.Leave, onLeave)
        mSocket?.off(EventAction.View, onView)
        mSocket?.off(EventAction.Like, onLike)
        mSocket?.off(EventAction.Notice, onNotice)
        mSocket?.off(EventAction.Disabled, onDisabled)
        mSocket?.off(EventAction.Disable, onDisable)
        mSocket?.off(EventAction.Enable, onEnable)
        mHandler.removeCallbacks(runnable)
    }

    private val onConnect = Emitter.Listener {
        try {
            val broadInfoBean = mViewModel?.getBroadInfoLD()?.value
            Log.i(TAG, "connect--------------------------${broadInfoBean?.nickname + broadInfoBean?.id}")
            val authJson = JSONObject()
            authJson.put("jwt", Constant.token)
            authJson.put("nickname", broadInfoBean?.nickname)
            authJson.put("roomId", broadInfoBean?.id)
            authJson.put("roomName", broadInfoBean?.title)
            mSocket?.emit("join", authJson)
        } catch (e: Exception) {
            LogUtils.file(TAG, e.toString())
        }
    }

    private val onDisconnect = Emitter.Listener { args ->
        Log.i(TAG, "onDisconnect--------------------------")
    }

    private val onConnectError = Emitter.Listener { args ->
        Log.i(TAG, "onConnectError--------------------------$args[0]")
    }

    private val onConnectTimeOut = Emitter.Listener { args ->
        Log.i(TAG, "onConnectTimeOut--------------------------")
    }

    // 授权
    private val onAuth = Emitter.Listener { args ->
        Log.i(TAG, "onAuth--------------------------授权" + args[0])
    }

    // 加入房间
    private val onJoin = Emitter.Listener { args ->
        Log.i(TAG, "onJoin--------------------------加入房间" + args[0])
    }

    // 新消息
    private val onChat = Emitter.Listener { args ->
        try {
            Log.i(TAG, "onChat--------------------------新消息" + args[0])
            if (args != null && args[0] != null && !TextUtils.isEmpty(args[0].toString())) {
                activity?.runOnUiThread {
                    var chatBean = Gson().fromJson(args[0].toString(), ChatMessageBean::class.java)
                    mMessages.add(chatBean)
                    mChatAdapter?.notifyDataSetChanged()
                    scrollToBottom()
                }
            }
        } catch (e: Exception) {
            LogUtils.file(TAG, e.toString())
        }
    }

    // 进入房间
    private val onEnter = Emitter.Listener { args ->
        try {
            Log.i(TAG, "onEnter--------------------------进入房间" + args[0])
            if (args != null && args[0] != null && !TextUtils.isEmpty(args[0].toString())) {
                activity?.runOnUiThread {
                    var chatBean = Gson().fromJson(args[0].toString(), ChatMessageBean::class.java)
                    val nickName = mViewModel?.getBroadInfoLD()?.value?.nickname
                    if (nickName.equals(chatBean?.nickname)) return@runOnUiThread
                    rt_one_come.text = chatBean.nickname + "来了"
                    rt_one_come.visibility = View.VISIBLE
                    mHandler.postDelayed(runnable, 2000)
                }
            }
        } catch (e: Exception) {
            LogUtils.file(TAG, e.toString())
        }
    }

    var runnable = {
        rt_one_come?.visibility = View.INVISIBLE
    }

    // 离开房间
    private val onLeave = Emitter.Listener { args ->
        try {
            Log.i(TAG, "onLeave--------------------------离开房间" + args[0])
        } catch (e: Exception) {
            LogUtils.file(TAG, e.toString())
        }
    }

    // 离开房间
    private val onView = Emitter.Listener { args ->
        Log.i(TAG, "onView--------------------------提醒商品去买")
    }

    // 点赞
    private val onLike = Emitter.Listener { args ->
        try {
            Log.i(TAG, "onLike--------------------------点赞")
            if (args != null && args[0] != null && !TextUtils.isEmpty(args[0].toString())) {
                var chatBean = Gson().fromJson(args[0].toString(), ChatMessageBean::class.java)
                EventBusUtils.post(OnNotifyUpdateLikeNum(true, chatBean.content))
            }
        } catch (e: Exception) {
            LogUtils.file(TAG, e.toString())
        }
    }

    // 系统通知
    private val onNotice = Emitter.Listener { args ->
        Log.i(TAG, "onNotice--------------------------系统通知")
    }

    // 已被禁言
    private val onDisabled = Emitter.Listener { args ->
        Log.i(TAG, "onDisabled--------------------------已被禁言")
    }

    // 禁言
    private val onDisable = Emitter.Listener { args ->
        Log.i(TAG, "onDisable--------------------------禁言")
    }

    // 不禁言
    private val onEnable = Emitter.Listener { args ->
        Log.i(TAG, "onEnable--------------------------不禁言")
    }

    /**
     * 消息滑动到底部
     */
    private fun scrollToBottom() {
        rv_chat.scrollToPosition(mChatAdapter!!.itemCount - 1)
    }

    override fun initViewModel(): ALiveViewModel {
        return ViewModelProviders.of(activity!!).get(ALiveViewModel::class.java)
    }
}

object EventAction {
    public val Auth = "auth"// 认证，过期需要重新获取
    public val Join = "join"// 加入房间
    public val Enter = "enter"// 进入房间
    public val Leave = "leave"// 离开房间
    public val Chat = "chat"// 发送消息
    public val View = "view"// 商品点击提醒
    public val Like = "like"// 点赞
    public val Notice = "notice"// 系统通知
    public val Disabled = "disabled"// 已经被禁言
    public val Disable = "disable"
    public val Enable = "enable"
}