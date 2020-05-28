package com.czh.tvmerchantapp.live.push.java.fragment

import android.os.Bundle
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProviders
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import com.blankj.utilcode.util.ToastUtils
import com.bumptech.glide.Glide
import com.chad.library.adapter.base.BaseQuickAdapter
import com.chad.library.adapter.base.viewholder.BaseViewHolder
import com.czh.tvmerchantapp.R
import com.czh.tvmerchantapp.base.BaseFragment
import com.czh.tvmerchantapp.base.Constant
import com.czh.tvmerchantapp.databinding.ViewProductListBinding
import com.czh.tvmerchantapp.live.push.java.bean.LiveDisplayWindowBean
import com.czh.tvmerchantapp.live.push.java.event.OnNotifyUpdateFragmentTitle
import com.czh.tvmerchantapp.live.push.java.event.OnNotifyUpdateOtherProduct
import com.czh.tvmerchantapp.live.push.java.view.ProductFrameView
import com.czh.tvmerchantapp.live.push.java.view.base.CommonItemDecoration
import com.czh.tvmerchantapp.live.push.java.viewmodel.DisplayWindowListener
import com.czh.tvmerchantapp.live.push.java.viewmodel.ProductListListener
import com.czh.tvmerchantapp.live.push.java.viewmodel.ProductListViewModel
import com.czh.tvmerchantapp.util.EventBusUtils
import com.ruffian.library.widget.RImageView
import com.ruffian.library.widget.RTextView
import kotlinx.android.synthetic.main.view_product_list.*
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode

class ProductListFragment : BaseFragment<ProductListViewModel, ViewProductListBinding>() {

    private lateinit var mLiveId: String
    private lateinit var mStatus: String
    private var mList = ArrayList<LiveDisplayWindowBean>()
    private var mAdapter: BaseQuickAdapter<LiveDisplayWindowBean, BaseViewHolder>? = null

    companion object {

        @JvmField
        val LiveId = "LiveId"

        @JvmField
        val ProductType = "ProductType"

        @JvmStatic
        fun getInstance(liveId: String, type: String): ProductListFragment {
            val productListFragment = ProductListFragment()
            val bundle = Bundle()
            bundle.putString(LiveId, liveId)
            bundle.putString(ProductType, type)
            productListFragment.arguments = bundle
            return productListFragment
        }
    }

    override fun getLayoutId(): Int = R.layout.view_product_list

    override fun initViewModel(): ProductListViewModel {
        return ViewModelProviders.of(this).get(ProductListViewModel::class.java)
    }

    override fun initView(savedInstanceState: Bundle?) {
        recycle_view.layoutManager = LinearLayoutManager(activity)
        recycle_view.addItemDecoration(CommonItemDecoration(activity, DividerItemDecoration.VERTICAL, resources.getDrawable(R.drawable.divider_gray_1_margin_45)))
        mAdapter = object : BaseQuickAdapter<LiveDisplayWindowBean, BaseViewHolder>(R.layout.item_product_info, mList) {
            override fun convert(helper: BaseViewHolder, item: LiveDisplayWindowBean) {
                when (mStatus) {
                    Constant.ProductStatus.ON_PENDING -> {
                        helper.setVisible(R.id.rt_show, false).setVisible(R.id.view_line, false)
                        val rtView = helper.getView<RTextView>(R.id.rt_off)
                        rtView.text = "上架"
                        rtView.helper.iconNormal = resources.getDrawable(R.mipmap.ic_up)
                    }
                    Constant.ProductStatus.ON_SELL -> {
                        val rtShow = helper.getView<RTextView>(R.id.rt_show)
                        when (item.displayWindow) {
                            Constant.WindowStatus.SHOW -> {
                                rtShow.helper.iconNormal = resources.getDrawable(R.mipmap.ic_eye_close)
                                rtShow.text = "取消展示"
                            }
                            Constant.WindowStatus.HIDE -> {
                                rtShow.helper?.iconNormal = resources.getDrawable(R.mipmap.ic_eye_open)
                                rtShow.text = "屏幕展示"
                            }
                        }
                    }
                }
                val ivImage = helper.getView<RImageView>(R.id.ri_header)
                mContext?.let { Glide.with(it).load(item.img).placeholder(R.mipmap.ic_pic_holder).into(ivImage) }
                helper.setText(R.id.tv_title, item.name)
                        .setText(R.id.tv_left_top_text, "${mList.size - helper.adapterPosition}")
                        .setText(R.id.tv_num, "库存：${item.totalStockNum}  销量：${item.saleAmount}")
                        .setText(R.id.tv_price, "¥${item.price}")
            }
        }
        recycle_view.adapter = mAdapter
        mAdapter?.addChildClickViewIds(R.id.rt_show, R.id.rt_off)
        mAdapter?.setOnItemChildClickListener { adapter, view, position ->
            val productBean: LiveDisplayWindowBean = mList[position]
            when (view.id) {
                R.id.rt_show -> {
                    if (productBean.displayWindow == Constant.WindowStatus.HIDE && Constant.windowShowNum >= ProductFrameView.MaxNum) {
                        ToastUtils.showShort("最多可展示4个商品，请先删除其他商品")
                        return@setOnItemChildClickListener
                    }
                    mViewModel?.updateProductWindow(productBean.id, if (productBean.displayWindow == Constant.WindowStatus.SHOW) Constant.WindowStatus.HIDE else Constant.WindowStatus.SHOW, object : DisplayWindowListener {

                        override fun onDisplayWindow(displayWindow: String) {
                            productBean.displayWindow = displayWindow
                            adapter.notifyItemChanged(position)
                        }

                    })
                }
                R.id.rt_off -> {
                    mViewModel?.updateProductList(productBean.id, if (productBean.status == Constant.ProductStatus.ON_SELL) Constant.ProductStatus.ON_PENDING else Constant.ProductStatus.ON_SELL, object : ProductListListener {

                        override fun onProductList(status: String) {
                            mList.removeAt(position)
                            adapter.notifyItemRemoved(position)
                            adapter.notifyItemRangeChanged(0, mList.size)
                            // 通知fragment的title
                            EventBusUtils.post(OnNotifyUpdateFragmentTitle(true, productBean.status, mList.size))
                        }
                    })
                }
            }
        }
    }

    override fun loadData(savedInstanceState: Bundle?) {
        mLiveId = arguments?.getString(LiveId).toString()
        mStatus = arguments?.getString(ProductType).toString()
        mViewModel?.getProductListInfo(mLiveId, mStatus)
        mViewModel?.getProductLiveDate()?.observe(this, Observer {
            mList.clear()
            mList.addAll(it)
            mAdapter?.notifyDataSetChanged()
            // 通知fragment的title
            EventBusUtils.post(OnNotifyUpdateFragmentTitle(true, mStatus, mList.size))
        })
    }

    // 另外一个商品列表信息
    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onNotifyUpdateOtherProduct(onNotifyUpdateOtherProduct: OnNotifyUpdateOtherProduct) {
        if (onNotifyUpdateOtherProduct.boolean) {
            if (mStatus == onNotifyUpdateOtherProduct.status)
                mViewModel?.getProductListInfo(mLiveId, onNotifyUpdateOtherProduct.status)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        EventBusUtils.register(this)
    }

    override fun onDestroy() {
        super.onDestroy()
        EventBusUtils.unregister(this)
    }

}
