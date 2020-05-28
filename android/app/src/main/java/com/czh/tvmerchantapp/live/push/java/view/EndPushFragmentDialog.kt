package com.czh.tvmerchantapp.live.push.java.view

import android.text.TextUtils
import android.view.View
import android.widget.TextView
import com.blankj.utilcode.util.LogUtils
import com.blankj.utilcode.util.ToastUtils
import com.czh.tvmerchantapp.R
import com.czh.tvmerchantapp.base.Api
import com.czh.tvmerchantapp.base.dialog.BaseDialogFragment
import com.czh.tvmerchantapp.bean.BaseBean
import com.czh.tvmerchantapp.live.push.java.bean.LiveStatisticBean
import com.github.kittinunf.fuel.gson.responseObject
import com.github.kittinunf.fuel.httpGet
import com.github.kittinunf.fuel.httpPut
import com.ruffian.library.widget.RTextView

class EndPushFragmentDialog(var likeNum: String, var lbId: String, var listener: PushEndListener) : BaseDialogFragment() {

    private val TAG = "EndPushFragmentDialog"

    var mTvSeeNum: TextView? = null
    var mTvZanNum: TextView? = null
    var mRtResume: RTextView? = null
    var mRtStop: RTextView? = null

    override fun onStart() {
        setWidthPer(1f)
        setHeightPer(1f)
        setUseSizePerEnabled(true)
        super.onStart()
    }

    override fun getLayoutRes(): Int {
        return R.layout.view_end_push
    }

    override fun bindView(v: View?) {
        try {
            mTvSeeNum = v?.findViewById(R.id.tv_see_num)
            mTvZanNum = v?.findViewById(R.id.tv_zan_num)
            mRtResume = v?.findViewById(R.id.rt_resume)
            mRtStop = v?.findViewById(R.id.rt_stop)
            mTvZanNum?.text = if (TextUtils.isEmpty(likeNum)) "0" else likeNum
            Api.liveStatistics(lbId = lbId).httpGet().responseObject<BaseBean<LiveStatisticBean>>() { _, _, result ->
                result.fold(success = {
                    if (it.success) {
                        mTvSeeNum?.text = if (TextUtils.isEmpty(it.data.view.toString())) "0" else it.data.view.toString()
                    }
                }, failure = {

                })
            }
            mRtResume?.setOnClickListener {
                dismiss()
            }
            mRtStop?.setOnClickListener {
//            listener.onStopEndListener()
//            dismiss()


                Api.liveOver(lbId = lbId).httpPut().responseObject<BaseBean<String>>() { _, _, result ->
                    result.fold(success = {
                        if (it.success) {
                            dismiss()
                            listener.onStopEndListener()
                            LogUtils.i("直播结束")
                        }
                    }, failure = {
                        dismiss()
                        LogUtils.i("直播结束失败")
                    })
                }
            }
        } catch (e: Exception) {
            LogUtils.file(TAG, e.toString())
        }
    }

}

interface PushEndListener {
    fun onStopEndListener()// 确定结束
}