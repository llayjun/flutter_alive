package com.czh.tvmerchantapp.base.dialog

import android.app.Dialog
import android.content.Context
import android.content.DialogInterface
import android.graphics.drawable.AnimationDrawable
import android.view.Gravity
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.czh.tvmerchantapp.R

class LoadingDialog : Dialog {

    constructor(context: Context?) : super(context!!) {

    }

    constructor(context: Context?, theme: Int) : super(context!!, theme) {

    }

    /**
     * 当窗口焦点改变时调用
     */
    override fun onWindowFocusChanged(hasFocus: Boolean) {
        val imageView = findViewById<View>(R.id.spinnerImageView) as ImageView
        // 获取ImageView上的动画背景
        val spinner = imageView.background as AnimationDrawable
        // 开始动画
        spinner.start()
    }

    companion object {
        private var dialog: LoadingDialog? = null

        /**
         * 弹出自定义ProgressDialog
         *
         * @param context        上下文
         * @param message        提示
         * @param cancelable     是否按返回键取消
         * @param cancelListener 按下返回键监听
         * @return
         */
        fun create(context: Context?, message: CharSequence?, cancelable: Boolean, cancelListener: DialogInterface.OnCancelListener?): LoadingDialog? {
            dialog = LoadingDialog(context, R.style.Custom_Progress)
            dialog?.setTitle("")
            dialog?.setContentView(R.layout.view_progress_net)
            if (message == null || message.length == 0) {
                dialog!!.findViewById<View>(R.id.message).visibility = View.GONE
            } else {
                val txt = dialog!!.findViewById<View>(R.id.message) as TextView
                txt.text = message
            }
            // 按返回键是否取消
            dialog!!.setCancelable(cancelable)
            dialog!!.setCanceledOnTouchOutside(false)
            // 监听返回键处理
            dialog!!.setOnCancelListener(cancelListener)
            // 设置居中
            dialog!!.window!!.attributes.gravity = Gravity.CENTER
            val lp = dialog!!.window!!.attributes
            // 设置背景层透明度
            lp.dimAmount = 0.2f
            dialog!!.window!!.attributes = lp
            // dialog.getWindow().addFlags(WindowManager.LayoutParams.FLAG_BLUR_BEHIND);
            return dialog
        }
    }
}