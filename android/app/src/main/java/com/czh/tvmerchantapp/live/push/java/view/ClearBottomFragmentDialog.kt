package com.czh.tvmerchantapp.live.push.java.view

import android.view.View
import android.widget.TextView
import com.czh.tvmerchantapp.R
import com.czh.tvmerchantapp.base.dialog.BaseBottomDialogFragment

class ClearBottomFragmentDialog(var click: ClickChooseListener, var state: Clear) : BaseBottomDialogFragment() {

    var mTvHd: TextView? = null
    var mTvFluent: TextView? = null

    override fun getLayoutRes(): Int = R.layout.view_choose_clear

    override fun onStart() {
        setWidthPer(1f)
        setUseSizePerEnabled(true)
        super.onStart()
    }

    override fun bindView(v: View?) {
        mTvHd = v?.findViewById(R.id.tv_hd)
        mTvFluent = v?.findViewById(R.id.tv_fluent)
        mTvHd?.setOnClickListener {
            click.onClickChooseListener(Clear.HD)
        }
        mTvFluent?.setOnClickListener {
            click.onClickChooseListener(Clear.FLUENT)
        }
        setClearState(state)
    }

    fun setClearState(clearState: Clear) {
        when (clearState) {
            Clear.HD -> {
                mTvHd?.text = "清晰（已选）"
                mTvHd?.setTextColor(resources.getColor(R.color.color_F63825))
                mTvFluent?.text = "流畅"
                mTvFluent?.setTextColor(resources.getColor(R.color.color_333333))
            }
            Clear.FLUENT -> {
                mTvHd?.text = "清晰"
                mTvHd?.setTextColor(resources.getColor(R.color.color_333333))
                mTvFluent?.text = "流畅（已选）"
                mTvFluent?.setTextColor(resources.getColor(R.color.color_F63825))
            }
        }
    }

}

interface ClickChooseListener {
    fun onClickChooseListener(clearState: Clear)
}

enum class Clear {
    HD,//  高清
    FLUENT// 流畅
}