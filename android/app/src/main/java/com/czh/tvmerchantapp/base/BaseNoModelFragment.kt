package com.czh.tvmerchantapp.base

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.LayoutRes
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import com.blankj.utilcode.util.NetworkUtils
import com.blankj.utilcode.util.ToastUtils
import com.czh.tvmerchantapp.R
import com.czh.tvmerchantapp.base.dialog.LoadingDialog
import org.json.JSONException
import java.net.ConnectException
import java.net.SocketTimeoutException

abstract class BaseNoModelFragment<DB : ViewDataBinding> : Fragment() {

    private var mDataBinding: DB? = null

    var mContext: Context? = null

    public var mActivity: FragmentActivity? = null

    private var mLoadingDialog: LoadingDialog? = null

    override fun onAttach(context: Context) {
        super.onAttach(context)
        this.mContext = context
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        mDataBinding = initDataBinding(inflater, getLayoutId(), container)
        return mDataBinding?.root
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        mActivity = activity
        initView(savedInstanceState)
        loadData(savedInstanceState)
    }

    /**
     * 返回布局界面
     */
    protected abstract fun getLayoutId(): Int

    /**
     * 初始化DataBinding
     */
    protected open fun initDataBinding(inflater: LayoutInflater?, @LayoutRes layoutId: Int, container: ViewGroup?): DB {
        return DataBindingUtil.inflate(inflater!!, layoutId, container, false)
    }

    /**
     * 初始化视图
     */
    protected abstract fun initView(savedInstanceState: Bundle?)

    /**
     * 加载数据
     */
    protected abstract fun loadData(savedInstanceState: Bundle?)

    /**
     * 显示用户等待框
     */
    protected open fun showDialog() {
        if (mLoadingDialog == null) {
            mLoadingDialog = LoadingDialog.create(mContext, "加载中...", false, null)
        }
        if (!mLoadingDialog?.isShowing!!)
            mLoadingDialog?.show()
    }

    /**
     * 隐藏等待框
     */
    protected open fun dismissDialog() {
        if (mLoadingDialog != null && mLoadingDialog!!.isShowing) {
            mLoadingDialog?.dismiss()
            mLoadingDialog = null
        }
    }

    /**
     * 网络错误问题
     */
    fun showThrowable(throwable: Throwable?) {
        if (!NetworkUtils.isConnected()) {
            ToastUtils.showShort(R.string.result_network_error)
            return
        }
        return when (throwable) {
            is ConnectException -> {
                ToastUtils.showShort(R.string.result_server_error)
            }
            is SocketTimeoutException -> {
                ToastUtils.showShort(R.string.result_server_timeout)
            }
            is JSONException -> {
                ToastUtils.showShort(R.string.result_json_error)
            }
            else -> {
                ToastUtils.showShort(R.string.result_empty_error)
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        mDataBinding?.unbind()
    }

}