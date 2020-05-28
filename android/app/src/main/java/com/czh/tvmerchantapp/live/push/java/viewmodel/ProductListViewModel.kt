package com.czh.tvmerchantapp.live.push.java.viewmodel

import androidx.lifecycle.MutableLiveData
import com.czh.tvmerchantapp.base.Api
import com.czh.tvmerchantapp.base.lifecycle.BaseViewModel
import com.czh.tvmerchantapp.bean.BaseBean
import com.czh.tvmerchantapp.live.push.java.bean.LiveDisplayWindowBean
import com.czh.tvmerchantapp.live.push.java.event.OnNotifyUpdateDisplay
import com.czh.tvmerchantapp.live.push.java.event.OnNotifyUpdateOtherProduct
import com.czh.tvmerchantapp.util.EventBusUtils
import com.github.kittinunf.fuel.gson.responseObject
import com.github.kittinunf.fuel.httpGet
import com.github.kittinunf.fuel.httpPut

class ProductListViewModel : BaseViewModel() {

    private var mProductLiveDate = MutableLiveData<List<LiveDisplayWindowBean>>()

    fun getProductLiveDate(): MutableLiveData<List<LiveDisplayWindowBean>> {
        return mProductLiveDate
    }

    /**
     * 获取直播关联的商品列表
     */
    fun getProductListInfo(lbId: String?, status: String?) {
        mShowDialog?.setValue(true)
        Api.liveProductListUrl(lbId = lbId, status = status).httpGet().responseObject<BaseBean<List<LiveDisplayWindowBean>>>() { _, _, result ->
            result.fold(success = {
                mShowDialog?.setValue(false)
                if (it.success) {
                    mProductLiveDate.setValue(it.data)
                } else {
                    mToast?.setValue(it.msg)
                }
            }, failure = {
                mShowDialog?.setValue(false)
                mThrowable?.setValue(it)
            })
        }
    }

    /**
     * 更新关联商品橱窗展示
     */
    fun updateProductWindow(id: String, displayWindow: String, onDisplayWindowListener: DisplayWindowListener) {
        Api.liveWindowUpdate(id = id, displayWindow = displayWindow).httpPut().responseObject<BaseBean<String>>() { _, _, result ->
            result.fold(success = {
                if (it.success) {
                    onDisplayWindowListener.onDisplayWindow(displayWindow)
                    EventBusUtils.post(OnNotifyUpdateDisplay(true))
                }
            }, failure = {
                mThrowable?.setValue(it)
            })
        }
    }

    /**
     * 更新商品上下架
     */
    fun updateProductList(id: String, status: String, productListListener: ProductListListener) {
        Api.liveProductListUpdate(id = id, status = status).httpPut().responseObject<BaseBean<String>>() { _, _, result ->
            result.fold(success = {
                if (it.success) {
                    productListListener.onProductList(status)
                    // 通知橱窗
                    EventBusUtils.post(OnNotifyUpdateDisplay(true))
                    // 通知另外一个商品列表
                    EventBusUtils.post(OnNotifyUpdateOtherProduct(true, status))
                }
            }, failure = {
                mThrowable?.setValue(it)
            })
        }
    }


}

interface DisplayWindowListener {
    fun onDisplayWindow(displayWindow: String)
}

interface ProductListListener {
    fun onProductList(status: String)
}


