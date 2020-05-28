package com.czh.tvmerchantapp.base

import android.content.Context
import android.content.res.Resources
import android.os.Bundle
import androidx.annotation.LayoutRes
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import com.blankj.utilcode.util.AdaptScreenUtils
import com.blankj.utilcode.util.NetworkUtils
import com.blankj.utilcode.util.ToastUtils
import com.czh.tvmerchantapp.R
import com.czh.tvmerchantapp.base.dialog.LoadingDialog
import com.llayjun.ajetpack.util.ActivityUtil
import org.json.JSONException
import java.net.ConnectException
import java.net.SocketTimeoutException

abstract class BaseNoModelActivity<DB : ViewDataBinding> : AppCompatActivity() {

    private var mDataBinding: DB? = null

    public var mContext: Context? = null

    private var mLoadingDialog: LoadingDialog? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        mContext = this
        initWindow(savedInstanceState)
        setContentView(getLayoutId())
        mDataBinding = initDataBinding(getLayoutId())
        ActivityUtil.getInstance()?.addActivity(this)
        initView(savedInstanceState)
        loadData(savedInstanceState)
    }

    /**
     * 作为window操作
     */
    open fun initWindow(savedInstanceState: Bundle?) {}

    /**
     * 返回布局界面
     */
    abstract fun getLayoutId(): Int

    /**
     * 初始化DataBinding
     */
    open fun initDataBinding(@LayoutRes layoutId: Int): DB {
        return DataBindingUtil.setContentView(this, getLayoutId())
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
     * 今日头条适配方式
     *
     * @return
     */
    override fun getResources(): Resources? {
        return AdaptScreenUtils.adaptWidth(super.getResources(), 1080)
    }

    /**
     * 显示用户等待框
     */
    protected open fun showDialog() {
        if (mLoadingDialog == null) {
            mLoadingDialog = LoadingDialog.create(this, "加载中...", false, null)
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
    protected fun showThrowable(throwable: Throwable?) {
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
        ActivityUtil.getInstance()?.removeActivity(this)
    }

}