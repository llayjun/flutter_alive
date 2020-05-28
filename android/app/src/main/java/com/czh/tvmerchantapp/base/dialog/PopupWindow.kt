package com.czh.tvmerchantapp.base

import android.app.Activity
import android.content.Context
import android.graphics.drawable.BitmapDrawable
import android.os.Build
import android.util.AttributeSet
import android.view.Gravity
import android.view.View
import android.view.WindowManager
import android.widget.PopupWindow
import androidx.annotation.FloatRange


/**
 * PopupWindow 的基类
 */
abstract class BasePopupWindow : PopupWindow {
    private val DEF_SHOW_ALPHA = 0.5f
    private val DEF_DISMISS_ALPHA = 1.0f

    /* 显示时的屏幕背景透明度 */
    private var mShowAlpha = 0f

    /* 关闭时的屏幕背景透明度 */
    var mDisAlpha = 0f

    private var mContext: Context

    constructor(context: Context) : super(context) {
        mContext = context
        init()
    }

    constructor(context: Context, attrs: AttributeSet?) : super(context, attrs) {
        mContext = context
        init()
    }

    constructor(context: Context, attrs: AttributeSet?, defStyleAttr: Int) : super(context, attrs, defStyleAttr) {
        mContext = context
        init()
    }

    private fun init() {
        mShowAlpha = DEF_SHOW_ALPHA
        mDisAlpha = DEF_DISMISS_ALPHA
    }

    /**
     * 设置弹窗宽高
     *
     * @param width  弹窗的宽度
     * @param height 弹窗的高度
     */
    fun setPopSize(width: Int, height: Int) {
        setWidth(width)
        setHeight(height)
    }

    /**
     * 点击空白处消失
     *
     * @param enabled `true`: 点击空白处消失<br></br>`false`: 点击空白处不消失
     */
    fun touchOutSideDismiss(enabled: Boolean) {
        setTouchable(enabled)
        setOutsideTouchable(enabled)
        setBackgroundDrawable(BitmapDrawable())
    }

    /**
     * 设置屏幕的背景透明度
     *
     * @param alpha 背景透明度
     */
    private fun setBgAlpha(@FloatRange(from = 0.0, to = 1.0) alpha: Float) {
        // 设置背景颜色变暗
        val lp: WindowManager.LayoutParams = (mContext as Activity).getWindow().getAttributes()
        lp.alpha = alpha
        (mContext as Activity).getWindow().setAttributes(lp)
    }

    /**
     * 设置弹窗显示时的背景透明度
     *
     * @param alpha 背景透明度
     */
    open fun setShowAlpha(@FloatRange(from = 0.0, to = 1.0) alpha: Float) {
        mShowAlpha = alpha
        setBgAlpha(mShowAlpha)
    }

    /**
     * 设置弹窗关闭时的背景透明度
     *
     * @param alpha 背景透明度
     */
    open fun setDisAlpha(@FloatRange(from = 0.0, to = 1.0) alpha: Float) {
        mDisAlpha = alpha
    }

    override fun dismiss() {
        setBgAlpha(mDisAlpha)
        super.dismiss()
    }

    /**
     * @param anchor
     * @param xOff
     * @param yOff
     * @return
     */
    fun showAsDropDownNew(anchor: View, xOff: Int, yOff: Int) {
        //解决华为7.0以上popwindow位置错乱
        if (Build.VERSION.SDK_INT === Build.VERSION_CODES.N) {
            val mLocation = IntArray(2)
            anchor.getLocationInWindow(mLocation)
            showAtLocation(anchor, Gravity.NO_GRAVITY, mLocation[0] + xOff, mLocation[1] + anchor.getHeight())
        } else {
            showAsDropDown(anchor, xOff, yOff)
        }
    }

    val context: Context
        get() = mContext

    /**
     * 获取弹窗显示时的背景透明度
     *
     * @return 背景透明度
     */
    open fun getShowAlpha(): Float {
        return mShowAlpha
    }

    /**
     * 获取弹窗关闭时的背景透明度
     *
     * @return 背景透明度
     */
    open fun getDisAlpha(): Float {
        return mDisAlpha
    }

}