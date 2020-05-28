package com.czh.tvmerchantapp.live.push.java.viewmodel

import androidx.lifecycle.MutableLiveData
import com.czh.tvmerchantapp.base.Api
import com.czh.tvmerchantapp.base.lifecycle.BaseViewModel
import com.czh.tvmerchantapp.bean.BaseBean
import com.czh.tvmerchantapp.live.push.java.bean.BroadInfoBean
import com.czh.tvmerchantapp.live.push.java.bean.LiveDisplayWindowBean
import com.github.kittinunf.fuel.gson.responseObject
import com.github.kittinunf.fuel.httpGet

class ALiveViewModel : BaseViewModel() {

    private var mBroadInfoLD = MutableLiveData<BroadInfoBean>()

    fun getBroadInfoLD(): MutableLiveData<BroadInfoBean> {
        return mBroadInfoLD
    }

    // 获取直播推流url
    fun getBroadInfo(lbId: String?) {
        mShowDialog?.setValue(true)
        Api.broadDetail(lbId).httpGet().responseObject<BaseBean<BroadInfoBean>>() { request, response, result ->
            result.fold(success = {
                mShowDialog?.setValue(false)
                if (it.success) {
                    mBroadInfoLD.setValue(it.data)
                } else {
                    mToast?.setValue(it.msg)
                }
            }, failure = {
                // 请求失败，执行错误处理
                mShowDialog?.setValue(false)
                mThrowable?.setValue(it)
            })
        }
    }

    private var mLiveDisplayWindowLD = MutableLiveData<List<LiveDisplayWindowBean>>()

    fun getLiveWindowDisplay(): MutableLiveData<List<LiveDisplayWindowBean>> {
        return mLiveDisplayWindowLD
    }

    // 获取橱窗展示列表数据
    fun getDisplayWindowInfo(lbId: String?) {
        mShowDialog?.setValue(true)
        Api.liveWindowDisplayUrl(lbId).httpGet().responseObject<BaseBean<List<LiveDisplayWindowBean>>>() { _, _, result ->
            result.fold(success = {
                mShowDialog?.setValue(false)
                if (it.success) {
                    mLiveDisplayWindowLD.setValue(it.data)
                } else {
                    mToast?.setValue(it.msg)
                }
            }, failure = {
                // 请求失败，执行错误处理
                mShowDialog?.setValue(false)
                mThrowable?.setValue(it)
            })
        }
    }

}