package com.czh.tvmerchantapp.live.push.java.view

import android.view.View
import androidx.fragment.app.Fragment
import androidx.viewpager.widget.ViewPager
import com.blankj.utilcode.util.LogUtils
import com.czh.tvmerchantapp.R
import com.czh.tvmerchantapp.base.Constant
import com.czh.tvmerchantapp.base.MyFragmentPagerAdapter
import com.czh.tvmerchantapp.base.dialog.BaseBottomDialogFragment
import com.czh.tvmerchantapp.live.push.java.event.OnNotifyUpdateFragmentTitle
import com.czh.tvmerchantapp.live.push.java.fragment.ProductListFragment
import com.czh.tvmerchantapp.util.EventBusUtils
import com.flyco.tablayout.SlidingTabLayout
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode

class ProductBottomFragmentDialog(var liveId: String) : BaseBottomDialogFragment() {

    private val TAG = "ProductBottomFragmentDialog"

    private var mMyFragmentPagerAdapter: MyFragmentPagerAdapter? = null
    private var mFragments: ArrayList<Fragment>? = null
    private val mTitleList = arrayOf("已上架", "未上架")
    private var slidingTabLayout: SlidingTabLayout? = null

    override fun getLayoutRes(): Int = R.layout.view_product_show

    override fun onStart() {
        setWidthPer(1f)
        setUseSizePerEnabled(true)
        super.onStart()
        EventBusUtils.register(this)
    }

    override fun bindView(v: View?) {
        slidingTabLayout = v?.findViewById(R.id.sliding_tab_layout)
        val viewPager = v?.findViewById<ViewPager>(R.id.view_pager)
        mFragments = ArrayList()
        mFragments?.add(ProductListFragment.getInstance(liveId, Constant.ProductStatus.ON_SELL))
        mFragments?.add(ProductListFragment.getInstance(liveId, Constant.ProductStatus.ON_PENDING))
        viewPager?.offscreenPageLimit = mFragments?.size!!
        mMyFragmentPagerAdapter = MyFragmentPagerAdapter(childFragmentManager, mFragments!!)
        viewPager?.adapter = mMyFragmentPagerAdapter
        slidingTabLayout?.setViewPager(viewPager, mTitleList)
    }

    // 另外一个商品列表信息
    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onNotifyUpdateFragmentTitle(onNotifyUpdateFragmentTitle: OnNotifyUpdateFragmentTitle) {
        try {
            if (onNotifyUpdateFragmentTitle.boolean) {
                var num = onNotifyUpdateFragmentTitle.num
                when (onNotifyUpdateFragmentTitle.status) {
                    Constant.ProductStatus.ON_SELL -> {
                        if (num == 0) {
                            slidingTabLayout?.getTitleView(0)?.text = "已上架"
                        } else {
                            slidingTabLayout?.getTitleView(0)?.text = "已上架 ($num)"
                        }
                    }
                    Constant.ProductStatus.ON_PENDING -> {
                        if (num == 0) {
                            slidingTabLayout?.getTitleView(1)?.text = "未上架"
                        } else {
                            slidingTabLayout?.getTitleView(1)?.text = "未上架 ($num)"
                        }
                    }
                }
            }
        } catch (e: Exception) {
            LogUtils.file(TAG, e.toString())
        }
    }

    override fun onStop() {
        super.onStop()
        EventBusUtils.unregister(this)
    }

}

