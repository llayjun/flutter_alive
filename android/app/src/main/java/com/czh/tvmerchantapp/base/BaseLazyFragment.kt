package com.czh.tvmerchantapp.base

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.ViewDataBinding
import com.czh.tvmerchantapp.base.lifecycle.BaseViewModel

abstract class BaseLazyFragment<VM : BaseViewModel, DB : ViewDataBinding> : BaseFragment<VM, DB>() {

    // 懒加载
    private var createView = false

    private var activityCreated = false

    private var lazy = false

    // 这个Fragment是不是tab页面的第一个页面
    private var isFirstTab = false

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        val view = super.onCreateView(inflater, container, savedInstanceState)
        createView = true
        return view
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        activityCreated = true
    }

    override fun setUserVisibleHint(isVisibleToUser: Boolean) {
        super.setUserVisibleHint(isVisibleToUser)
        if (isVisibleToUser && createView && activityCreated && !lazy) {
            //不是第一个Tab的Fragment 进行懒加载请求数据
            lazy = true
            lazyLoad()
        } else if (isVisibleToUser && !createView && !activityCreated && !lazy) {
            //这个Fragment是多个Tab中的第一个
            isFirstTab = true
        } else {
            //对用户可见时，是否需要重新刷新数据
            if (isVisibleToUser) {
                visibleToUser()
            }
        }
    }

    override fun onResume() {
        super.onResume()
        // 第一个Tab页面懒加载
        if (isFirstTab && !lazy) {
            lazy = true
            lazyLoad()
        }
    }

    /**
     * 懒加载，只有在Fragment第一次创建且第一次对用户可见
     */
    protected abstract fun lazyLoad()

    /**
     * 每次在Fragment与用户可见状态且不是第一次对用户可见
     */
    protected abstract fun visibleToUser()
}