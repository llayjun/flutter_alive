package com.llayjun.ajetpack.util

import android.app.Activity
import java.util.*

class ActivityUtil {

    companion object {
        private var stack: Stack<Activity>? = null
        private var manager: ActivityUtil? = null

        /**
         * 获取实例
         */
        @Synchronized
        fun getInstance(): ActivityUtil? {
            if (manager == null) {
                manager = ActivityUtil()
                stack = Stack()
            }
            return manager
        }
    }

    /**
     * 添加Activity
     */
    @Synchronized
    fun addActivity(activity: Activity?) {
        stack!!.add(activity)
    }

    /**
     * 移除Activity
     */
    @Synchronized
    fun removeActivity(activity: Activity?) {
        stack!!.remove(activity)
    }

    /**
     * 结束指定类名的Activity
     */
    fun finishActivity(cls: Class<*>) {
        for (activity in stack!!) {
            if (activity.javaClass == cls) {
                finishActivity(activity)
                return
            }
        }
    }

    /**
     * 结束指定的Activity
     */
    fun finishActivity(activity: Activity?) {
        if (activity != null) {
            activity.finish()
            stack!!.remove(activity)
        }
    }

    /**
     * 是否存在Activity
     */
    fun containsActivity(cls: Class<*>): Boolean {
        for (activity in stack!!) {
            if (activity.javaClass == cls) {
                return true
            }
        }
        return false
    }

    /**
     * 结束所有Activity
     */
    fun finishAllActivity() {
        for (activity in stack!!) {
            activity?.finish()
        }
        stack!!.clear()
    }

}
