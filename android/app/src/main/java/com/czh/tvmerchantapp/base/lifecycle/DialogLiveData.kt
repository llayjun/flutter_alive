package com.czh.tvmerchantapp.base.lifecycle

import androidx.lifecycle.MutableLiveData
import com.czh.tvmerchantapp.bean.DialogBean

class DialogLiveData<T> : MutableLiveData<T>() {

    private val bean: DialogBean = DialogBean()

    fun setValue(isShow: Boolean) {
        bean.isShow = isShow
        value = bean as T
    }

    fun postValue(isShow: Boolean){
        bean.isShow = isShow
        postValue(bean as T)
    }

}