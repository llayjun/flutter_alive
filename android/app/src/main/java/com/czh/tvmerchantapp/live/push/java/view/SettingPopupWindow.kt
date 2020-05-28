package com.czh.tvmerchantapp.live.push.java.view

import android.content.Context
import android.util.AttributeSet
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.TextView
import com.blankj.utilcode.util.SizeUtils
import com.czh.tvmerchantapp.R
import com.czh.tvmerchantapp.base.BasePopupWindow

class SettingPopupWindow : BasePopupWindow {

    private var mView: View? = null
    private var mTvBeauty: TextView? = null
    private var mTvClear: TextView? = null

    constructor(context: Context) : super(context) {
        initView(context)
    }

    constructor(context: Context, attrs: AttributeSet) : super(context, attrs) {
        initView(context)
    }

    constructor(context: Context, attrs: AttributeSet?, defStyleAttr: Int) : super(context, attrs, defStyleAttr) {
        initView(context)
    }

    fun initView(context: Context) {
        mView = LayoutInflater.from(context).inflate(R.layout.view_setting, null)
        mTvBeauty = mView?.findViewById(R.id.tv_beauty)
        mTvClear = mView?.findViewById(R.id.tv_clear)
        this.setPopSize(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        this.animationStyle = R.style.PopupAnimation
        this.isFocusable = true
        this.touchOutSideDismiss(true)
        this.contentView = mView
    }

    open fun changeBeauty(open: Boolean) {
        if (open) {
            mTvBeauty?.text = "开启美颜"
        } else {
            mTvBeauty?.text = "关闭美颜"
        }
    }

    open fun tvBeautyClick(click: View.OnClickListener) {
        mTvBeauty?.setOnClickListener(click)
    }

    open fun tvClearClick(click: View.OnClickListener) {
        mTvClear?.setOnClickListener(click)
    }

}