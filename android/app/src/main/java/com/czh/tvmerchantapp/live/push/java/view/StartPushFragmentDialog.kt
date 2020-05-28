package com.czh.tvmerchantapp.live.push.java.view

import android.view.View
import android.widget.TextView
import com.blankj.utilcode.util.LogUtils
import com.czh.tvmerchantapp.R
import com.czh.tvmerchantapp.base.dialog.BaseDialogFragment

class StartPushFragmentDialog(var listener: PushStateListener) : BaseDialogFragment() {

    private val TAG = "StartPushFragmentDialog"

    var mTvTime: TextView? = null
    var mHandler = android.os.Handler()
    var TIME: Int = 3

    override fun onStart() {
        setWidthPer(1f)
        setHeightPer(1f)
        setUseSizePerEnabled(true)
        super.onStart()
    }

    override fun getLayoutRes(): Int {
        return R.layout.view_begin_push
    }

    override fun bindView(v: View?) {
        mTvTime = v?.findViewById(R.id.tv_time)
        mTvTime?.text = "$TIME"
        mHandler.postDelayed(runnable, 1000)
    }

    private var runnable = object : Runnable {
        override fun run() {
            try {
                if (--TIME > 0) {
                    mTvTime?.text = "$TIME"
                    mHandler.postDelayed(this, 1000)
                } else {
                    mHandler.removeCallbacks(this)
                    listener.onPushStartListener()
                    dismiss()
                }
            } catch (e: Exception) {
                LogUtils.file(TAG, e.toString())
            }
        }

    }

}

interface PushStateListener {
    fun onPushStartListener()
}