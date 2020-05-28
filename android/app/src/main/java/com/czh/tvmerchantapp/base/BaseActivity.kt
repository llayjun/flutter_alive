package com.czh.tvmerchantapp.base

import androidx.databinding.ViewDataBinding
import androidx.lifecycle.Observer
import com.blankj.utilcode.util.ToastUtils
import com.czh.tvmerchantapp.base.lifecycle.BaseViewModel
import com.czh.tvmerchantapp.bean.DialogBean

abstract class BaseActivity<VM : BaseViewModel, DB : ViewDataBinding> : BaseNoModelActivity<DB>() {

    var mViewModel: VM? = null

    override fun initDataBinding(layoutId: Int): DB {
        val db = super.initDataBinding(layoutId)
        mViewModel = initViewModel()
        initObserve()
        return db
    }

    /**
     * 将initVieModel暴露出去，方便子类自己判断共享ViewModel
     */
    abstract fun initViewModel(): VM

    private fun initObserve() {
        if (mViewModel == null) return
        // 监听当前ViewModel中 showDialog和error的值
        mViewModel?.getShowDialog(this, Observer<DialogBean> {
            if (it.isShow) {
                showDialog()
            } else {
                dismissDialog()
            }
        })
        // 错误
        mViewModel?.getThrowable(this, Observer {
            showThrowable(it)
        })
        // 提示
        mViewModel?.getToast(this, Observer {
            ToastUtils.showShort(it)
        })
    }

}