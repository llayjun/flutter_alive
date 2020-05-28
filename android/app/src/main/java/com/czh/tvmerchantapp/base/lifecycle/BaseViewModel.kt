package com.czh.tvmerchantapp.base.lifecycle

import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModel
import com.czh.tvmerchantapp.bean.DialogBean

/**
 * BaseViewModel
 */
open class BaseViewModel : ViewModel() {

    // 管理通知Activity/Fragment是否显示等待的Dialog
    public var mShowDialog: DialogLiveData<DialogBean>? = DialogLiveData<DialogBean>()

    // 当ViewModel层出现错误需要通知到Activity／Fragment
    public var mThrowable: MutableLiveData<Throwable>? = MutableLiveData<Throwable>()

    // 当ViewModel层请求正确但数据不对需要通知到Activity／Fragment
    public var mToast: MutableLiveData<String>? = MutableLiveData<String>()


    /**
     * 监听mShowDialog
     */
    fun getShowDialog(owner: LifecycleOwner?, observer: Observer<DialogBean>?) {
        if (owner != null && observer != null) {
            mShowDialog?.observe(owner, observer)
        }
    }

    /**
     * 监听mThrowable
     */
    fun getThrowable(owner: LifecycleOwner?, observer: Observer<Throwable?>?) {
        if (owner != null && observer != null) {
            mThrowable?.observe(owner, observer)
        }
    }

    /**
     * 监听mToast
     */
    fun getToast(owner: LifecycleOwner?, observer: Observer<String>?) {
        if (owner != null && observer != null)
            mToast?.observe(owner, observer)
    }

    /**
     * ViewModel销毁同时也取消请求
     */
    override fun onCleared() {
        super.onCleared()
        mShowDialog = null
        mThrowable = null
        mToast = null
    }

}