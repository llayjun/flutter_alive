package com.czh.tvmerchantapp.live.push.java.adapte

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.czh.tvmerchantapp.R
import com.czh.tvmerchantapp.live.push.java.bean.LiveDisplayWindowBean
import com.ruffian.library.widget.RImageView

class ProductFrameAdapter(var list: List<LiveDisplayWindowBean>, var maxSize: Int, var context: Context, var click: ProductListener) : RecyclerView.Adapter<RecyclerView.ViewHolder>() {

    private val VIEW = 1
    private val ADD_VIEW = 2

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
        return when (viewType) {
            VIEW -> {
                var viewView = LayoutInflater.from(context).inflate(R.layout.view_show_image, parent, false)
                ViewViewHolder(viewView)
            }
            else -> {
                var addView = LayoutInflater.from(context).inflate(R.layout.view_show_add_image, parent, false)
                AddViewHolder(addView)
            }
        }
    }

    override fun getItemCount(): Int {
        return if (list.size < maxSize) {
            list.size + 1
        } else {
            list.size
        }
    }

    override fun getItemViewType(position: Int): Int {
        return if (isShowAdd(position)) {
            ADD_VIEW
        } else {
            VIEW
        }
    }

    /**
     * 根据 position 判断显示什么布局
     */
    private fun isShowAdd(position: Int): Boolean {
        val size = if (list.isEmpty()) 0 else list.size
        return position == size
    }

    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        when (holder) {
            is ViewViewHolder -> {
                var viewViewHolder = holder as ViewViewHolder
                Glide.with(context).load(list[position].img).placeholder(R.mipmap.ic_pic_holder).into(viewViewHolder.mIvImage!!)
                viewViewHolder.mIvDelete?.setOnClickListener {
                    click.onProductClickDelete(position)
                }
                viewViewHolder.mIvImage?.setOnClickListener {
                    click.onProductClickView(position)
                }
            }
            is AddViewHolder -> {
                var addViewHolder = holder as AddViewHolder
                addViewHolder.mAddImage?.setOnClickListener {
                    click.onProductClickAdd()
                }
            }
        }
    }

    class AddViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        var mAddImage: ImageView? = null

        init {
            mAddImage = itemView.findViewById(R.id.iv_add_image)
        }
    }

    class ViewViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        var mIvImage: RImageView? = null
        var mIvDelete: ImageView? = null

        init {
            mIvImage = itemView.findViewById(R.id.iv_image)
            mIvDelete = itemView.findViewById(R.id.iv_delete)
        }
    }

}

interface ProductListener {
    fun onProductClickAdd()// 新增
    fun onProductClickDelete(position: Int)// 删除
    fun onProductClickView(position: Int)// 放大
}