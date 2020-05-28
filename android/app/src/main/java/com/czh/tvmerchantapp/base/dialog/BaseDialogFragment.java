package com.czh.tvmerchantapp.base.dialog;


import android.app.Dialog;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;

import androidx.annotation.FloatRange;
import androidx.annotation.LayoutRes;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.DialogFragment;

import com.czh.tvmerchantapp.R;


/**
 * DialogFragment 的基类
 */
public abstract class BaseDialogFragment extends DialogFragment {
    /* 默认的背景透明度 */
    private final float DEF_VISIBLE_ALPHA = 0.5f;
    /* 是否使用 dialog 的百分比尺寸 */
    private final boolean DEF_USE_SIZE_PER = false;
    /* 默认的 dialog 的宽占屏宽的比 */
    private final float DEF_WIDTH_PER = 0.75f;
    /* 默认的 dialog 的高占屏高的比，此处表示自适应 */
    private final float DEF_HEIGHT_PER = ViewGroup.LayoutParams.WRAP_CONTENT;

    /* 显示时的屏幕背景透明度 */
    private float mVisibleAlpha = DEF_VISIBLE_ALPHA;
    /* 是否使用对话框宽高占屏百分比 */
    private boolean isUseSizePer = DEF_USE_SIZE_PER;
    /* 对话框宽所占屏幕的百分比 */
    private float mWidthPer = DEF_WIDTH_PER;
    /* 对话框高所占屏幕的百分比 */
    private float mHeightPer = DEF_HEIGHT_PER;

    @Override
    public void onStart() {
        super.onStart();
        setBgAlpha(mVisibleAlpha);
        if (isUseSizePer) {
            setSizePercent(mWidthPer, mHeightPer);
        }
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setStyle(DialogFragment.STYLE_NO_TITLE, R.style.DialogNoTitleStyle);
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View v = inflater.inflate(getLayoutRes(), container, false);
        bindView(v);
        return v;
    }

    @LayoutRes
    public abstract int getLayoutRes();

    public abstract void bindView(View v);

    /**
     * 设置弹框显示消失动画
     *
     * @param dialog    dialog
     * @param animStyle 动画样式
     */
    public void setWindowAnim(Dialog dialog, int animStyle) {
        Window window = dialog.getWindow();
        window.setWindowAnimations(animStyle);
    }

    /**
     * 设置是否使用对话框的宽高占屏百分比
     *
     * @param enable {@code true}: 使用<br>{@code false}: 不使用
     */
    public void setUseSizePerEnabled(boolean enable) {
        this.isUseSizePer = enable;
    }

    /**
     * 设置对话框的宽度占屏百分比
     *
     * @param per 宽度占屏百分比
     */
    public void setWidthPer(@FloatRange(from = 0.0) float per) {
        mWidthPer = per;
    }

    /**
     * 设置对话框的高度占屏百分比
     *
     * @param per 高度占屏百分比
     */
    public void setHeightPer(@FloatRange(from = 0.0) float per) {
        mHeightPer = per;
    }

    /**
     * 设置dialog宽高的占屏比
     *
     * @param wp dialog 的宽的占屏比
     * @param hp dialog 的高的占屏比
     */
    private void setSizePercent(@FloatRange(from = 0.0) float wp, @FloatRange(from = 0.0) float hp) {
        Dialog dialog = getDialog();
        if (dialog != null) {
            DisplayMetrics dm = new DisplayMetrics();
            getActivity().getWindowManager().getDefaultDisplay().getMetrics(dm);
            if (wp < 0) {
                wp = ViewGroup.LayoutParams.WRAP_CONTENT;
            }
            if (hp < 0) {
                hp = ViewGroup.LayoutParams.WRAP_CONTENT;
            }
            if (wp == 1 && hp == 1) {
                Window window = dialog.getWindow();
                window.setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
            } else {
                dialog.getWindow().setLayout(
                        wp == ViewGroup.LayoutParams.WRAP_CONTENT ? ViewGroup.LayoutParams.WRAP_CONTENT : (int) (dm.widthPixels * wp),
                        hp == ViewGroup.LayoutParams.WRAP_CONTENT ? ViewGroup.LayoutParams.WRAP_CONTENT : (int) (dm.heightPixels * hp));
            }
        }
    }

    /**
     * 设置屏幕的背景透明度
     *
     * @param alpha 透明度
     */
    public void setVisibleAlpha(@FloatRange(from = 0.0, to = 1.0) float alpha) {
        this.mVisibleAlpha = alpha;
    }

    /**
     * 设置屏幕的背景透明度
     *
     * @param bgAlpha 0-1（0：屏幕完全透明，1：背景最暗）
     */
    private void setBgAlpha(@FloatRange(from = 0.0, to = 1.0) float bgAlpha) {
        if (bgAlpha < 0) {
            bgAlpha = 0;
        }
        if (bgAlpha > 1) {
            bgAlpha = 1;
        }
        Window window = getDialog().getWindow();
        WindowManager.LayoutParams lp = window.getAttributes();
        lp.dimAmount = bgAlpha;
        lp.flags |= WindowManager.LayoutParams.FLAG_DIM_BEHIND;
        window.setAttributes(lp);
    }
}
