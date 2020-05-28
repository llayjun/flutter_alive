package com.czh.tvmerchantapp.live.push.java.view

import android.view.View
import android.widget.TextView
import com.czh.tvmerchantapp.R
import com.czh.tvmerchantapp.base.dialog.BaseBottomDialogFragment
import com.ruffian.library.widget.RTextView

class ShareBottomFragmentDialog(var shareSavePicListener: ShareSavePicListener) : BaseBottomDialogFragment() {

    override fun getLayoutRes(): Int = R.layout.view_share_show

    override fun onStart() {
        setWidthPer(1f)
        setUseSizePerEnabled(true)
        super.onStart()
    }

    override fun bindView(v: View?) {
        val rtLink = v?.findViewById<RTextView>(R.id.rt_share_link)
        val rtPic = v?.findViewById<RTextView>(R.id.rt_share_pic)
        val ivClose = v?.findViewById<TextView>(R.id.tv_cancel)
        ivClose?.setOnClickListener {
            dismiss()
        }
        rtLink?.setOnClickListener {
            shareSavePicListener.onShareLink()
            dismiss()
        }
        rtPic?.setOnClickListener {
            shareSavePicListener.onShareSavePic()
            dismiss()
        }
    }

}

interface ShareSavePicListener {
    fun onShareLink()
    fun onShareSavePic()
}

