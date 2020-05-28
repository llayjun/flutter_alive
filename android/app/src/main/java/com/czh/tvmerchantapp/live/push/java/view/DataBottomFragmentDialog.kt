package com.czh.tvmerchantapp.live.push.java.view

import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.blankj.utilcode.util.LogUtils
import com.czh.tvmerchantapp.R
import com.czh.tvmerchantapp.base.Api
import com.czh.tvmerchantapp.base.dialog.BaseBottomDialogFragment
import com.czh.tvmerchantapp.bean.BaseBean
import com.czh.tvmerchantapp.live.push.java.bean.LiveStatisticBean
import com.github.kittinunf.fuel.gson.responseObject
import com.github.kittinunf.fuel.httpGet

class DataBottomFragmentDialog(var lbId: String) : BaseBottomDialogFragment() {

    private val TAG = "DataBottomFragmentDialog"

    override fun getLayoutRes(): Int = R.layout.view_data_show

    override fun onStart() {
        setWidthPer(1f)
        setUseSizePerEnabled(true)
        super.onStart()
    }

    override fun bindView(v: View?) {
        try {
            val tvNetState = v?.findViewById<TextView>(R.id.tv_net_state)
            val tvTotalSeeNum = v?.findViewById<TextView>(R.id.tv_total_see_num)
            val tvCurrentSeeNum = v?.findViewById<TextView>(R.id.tv_current_see_num)
            val tvActiveNum = v?.findViewById<TextView>(R.id.tv_active_num)
            val tvProductClickNum = v?.findViewById<TextView>(R.id.tv_product_click_num)
            val ivClose = v?.findViewById<ImageView>(R.id.iv_close)
            ivClose?.setOnClickListener {
                dismiss()
            }
            Api.liveStatistics(lbId = lbId).httpGet().responseObject<BaseBean<LiveStatisticBean>>() { _, _, result ->
                result.fold(success = {
                    if (it.success) {
                        android.os.Handler().post {
                            tvNetState?.text = "网络良好"
                            tvTotalSeeNum?.text = it.data.view.toString()
                            tvCurrentSeeNum?.text = it.data.online.toString()
                            tvActiveNum?.text = it.data.interaction.toString()
                            tvProductClickNum?.text = it.data.productView.toString()
                        }
                    }
                }, failure = {
                })
            }
        } catch (e: Exception) {
            LogUtils.file(TAG, e.toString())
        }
    }

}

