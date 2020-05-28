package com.czh.tvmerchantapp.live.push.java.view

import android.graphics.Bitmap
import android.view.View
import androidx.constraintlayout.widget.ConstraintLayout
import com.blankj.utilcode.util.ImageUtils
import com.blankj.utilcode.util.LogUtils
import com.blankj.utilcode.util.TimeUtils
import com.blankj.utilcode.util.ToastUtils
import com.bumptech.glide.Glide
import com.czh.tvmerchantapp.R
import com.czh.tvmerchantapp.base.Constant
import com.czh.tvmerchantapp.base.dialog.BaseDialogFragment
import com.czh.tvmerchantapp.live.push.java.bean.BroadInfoBean
import com.ruffian.library.widget.RImageView
import com.ruffian.library.widget.RTextView

class SharePicFragmentDialog(var isLiving: Boolean, var info: BroadInfoBean, var notifyMediaUpdateListener: NotifyMediaUpdateListener) : BaseDialogFragment() {

    private val TAG = "SharePicFragmentDialog"

    override fun onStart() {
        setWidthPer(1f)
        setHeightPer(1f)
        setUseSizePerEnabled(true)
        super.onStart()
    }

    override fun getLayoutRes(): Int {
        return R.layout.view_share_pic
    }

    override fun bindView(v: View?) {
        val constrain = v?.findViewById<ConstraintLayout>(R.id.constrain_middle)
        constrain?.setOnClickListener {
            dismiss()
        }
        val rtSave = v?.findViewById<RTextView>(R.id.rt_save)
        val riPic = v?.findViewById<RImageView>(R.id.rt_big_pic)
        riPic?.setOnClickListener {

        }
        if (isLiving) {
            context?.let { Glide.with(it).load(info.sharePosterLive).placeholder(R.mipmap.ic_pic_holder).into(riPic!!) }
        } else {
            context?.let { Glide.with(it).load(info.sharePosterPending).placeholder(R.mipmap.ic_pic_holder).into(riPic!!) }
        }
        rtSave?.setOnClickListener {
            try {
                var bitmap = ImageUtils.view2Bitmap(riPic)
                // 保存图片
                val pathName: String = Constant.PIC_PATH + TimeUtils.getNowMills() + ".png"
                var bo = ImageUtils.save(bitmap, pathName, Bitmap.CompressFormat.PNG)
                if (bo) ToastUtils.showShort("保存成功") else ToastUtils.showShort("保存失败请重试")
                notifyMediaUpdateListener.onNotifyMediaUpdate(pathName)
                dismiss()
            } catch (e: Exception) {
                LogUtils.file(TAG, e.toString())
            }
        }
    }

}

interface NotifyMediaUpdateListener {
    fun onNotifyMediaUpdate(name: String)
}