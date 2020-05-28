package com.czh.tvmerchantapp.live.push.java.view

import android.content.Context
import android.util.AttributeSet
import android.view.View
import android.widget.LinearLayout
import androidx.recyclerview.widget.LinearLayoutManager
import com.czh.tvmerchantapp.R
import com.czh.tvmerchantapp.base.Api
import com.czh.tvmerchantapp.base.Constant
import com.czh.tvmerchantapp.bean.BaseBean
import com.czh.tvmerchantapp.live.push.java.adapte.ProductFrameAdapter
import com.czh.tvmerchantapp.live.push.java.adapte.ProductListener
import com.czh.tvmerchantapp.live.push.java.bean.LiveDisplayWindowBean
import com.czh.tvmerchantapp.live.push.java.event.OnNotifyUpdateDisplay
import com.czh.tvmerchantapp.util.EventBusUtils
import com.github.kittinunf.fuel.gson.responseObject
import com.github.kittinunf.fuel.httpPut
import kotlinx.android.synthetic.main.view_product_frame.view.*

class ProductFrameView : LinearLayout {
    private var mView: View? = null
    private var mProductFrameAdapter: ProductFrameAdapter? = null
    private var mList = ArrayList<LiveDisplayWindowBean>()

    companion object {
        @JvmField
        var MaxNum = 4 // 最大数量
    }

    constructor(context: Context) : super(context) {
        initView(context)
    }

    constructor(context: Context, attrs: AttributeSet) : super(context, attrs) {
        initView(context)
    }

    constructor(context: Context, attrs: AttributeSet?, defStyleAttr: Int) : super(context, attrs, defStyleAttr) {
        initView(context)
    }

    private fun initView(context: Context) {
        mView = View.inflate(context, R.layout.view_product_frame, this)
        rc_close.setOnClickListener {
            this.visibility = View.GONE
        }
        mProductFrameAdapter = ProductFrameAdapter(mList, MaxNum, context, object : ProductListener {
            override fun onProductClickAdd() {
                addItemListener.onAddItemView()
            }

            override fun onProductClickDelete(position: Int) {
                if (position < 0) return
                Api.liveWindowUpdate(id = mList[position].id, displayWindow = Constant.WindowStatus.HIDE).httpPut().responseObject<BaseBean<String>>() { _, _, result ->
                    result.fold(success = {
                        if (it.success) {
                            mList.removeAt(position)
                            Constant.windowShowNum = mList.size
                            mProductFrameAdapter?.notifyItemRemoved(position)
                            mProductFrameAdapter?.notifyItemRangeChanged(0, mList.size)
                            EventBusUtils.post(OnNotifyUpdateDisplay(true))
                        }
                    }, failure = {
                    })
                }
            }

            override fun onProductClickView(position: Int) {
                if (position < 0) return
            }

        })
        rv_product.layoutManager = LinearLayoutManager(context)
        rv_product.adapter = mProductFrameAdapter
    }

    /**
     * 更新数据
     */
    fun setDataList(list: List<LiveDisplayWindowBean>) {
        mList.clear()
        mList.addAll(list)
        Constant.windowShowNum = mList.size
        mProductFrameAdapter?.notifyDataSetChanged()
    }

    private lateinit var addItemListener: AddItemListener

    public fun setOnAddItemListener(addItemListener: AddItemListener) {
        this.addItemListener = addItemListener
    }

}

interface AddItemListener {
    fun onAddItemView()
}

