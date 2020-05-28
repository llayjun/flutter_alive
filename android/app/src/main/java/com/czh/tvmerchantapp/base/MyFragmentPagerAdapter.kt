package com.czh.tvmerchantapp.base

import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentPagerAdapter

class MyFragmentPagerAdapter : FragmentPagerAdapter {

    //存储所有的fragment
    private var list: ArrayList<Fragment>
    private var titles: ArrayList<String>? = null

    constructor(fm: FragmentManager?, list: ArrayList<Fragment>) : super(fm!!) {
        this.list = list
    }

    constructor(fm: FragmentManager?, list: ArrayList<Fragment>, titles: ArrayList<String>?) : super(fm!!) {
        this.list = list
        this.titles = titles
    }

    override fun getItem(arg0: Int): Fragment {
        return list[arg0]
    }

    override fun getCount(): Int {
        return list.size
    }

    override fun getPageTitle(position: Int): CharSequence {
        return titles!![position]
    }


    /**
     * 添加 页面
     *
     */
    fun addPager(title: String, fragment: Fragment) {
        this.titles?.add(title)
        this.list.add(fragment)
        notifyDataSetChanged()
    }

    fun setTitles(stringList: List<String>?) {
        titles!!.clear()
        titles!!.addAll(stringList!!)
        notifyDataSetChanged()
    }

}
