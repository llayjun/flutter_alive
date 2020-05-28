package com.czh.tvmerchantapp.live.push.java.view.base;

import android.graphics.Rect;
import android.view.View;

import androidx.recyclerview.widget.RecyclerView;

/**
 * Created by LiLiang on 2017/6/24.
 */

public class SpacesItemDecoration extends RecyclerView.ItemDecoration {

    private int space;
    private int left;
    private int top;
    private int right;
    private int bottom;

    public SpacesItemDecoration(int space) {
        this.space = space;
    }

    public SpacesItemDecoration(int left, int top, int right, int bottom) {
        this.left = left;
        this.top = top;
        this.right = right;
        this.bottom = bottom;
    }

    @Override
    public void getItemOffsets(Rect outRect, View view, RecyclerView parent, RecyclerView.State state) {
        outRect.left = space == 0 ? left : space;
        outRect.right = space == 0 ? right : space;
        outRect.bottom = space == 0 ? bottom : space;
        outRect.top = space == 0 ? top : space;
    }
}
