package com.czh.tvmerchantapp.live.push.java.activity;

import android.Manifest
import android.content.Intent
import android.content.res.Configuration
import android.hardware.Camera
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import android.text.TextUtils
import android.view.*
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProviders
import com.alivc.component.custom.AlivcLivePushCustomDetect
import com.alivc.component.custom.AlivcLivePushCustomFilter
import com.alivc.live.detect.TaoFaceFilter
import com.alivc.live.filter.TaoBeautyFilter
import com.alivc.live.pusher.*
import com.blankj.utilcode.util.GsonUtils
import com.blankj.utilcode.util.LogUtils
import com.blankj.utilcode.util.ToastUtils
import com.czh.tvmerchantapp.MyFlutterApplication
import com.czh.tvmerchantapp.R
import com.czh.tvmerchantapp.base.BaseActivity
import com.czh.tvmerchantapp.databinding.ActivityPushBinding
import com.czh.tvmerchantapp.live.AlilivePlugin
import com.czh.tvmerchantapp.live.push.chat.ChatSocketFragment
import com.czh.tvmerchantapp.live.push.java.event.OnNotifyUpdateDisplay
import com.czh.tvmerchantapp.live.push.java.event.OnNotifyUpdateLikeNum
import com.czh.tvmerchantapp.live.push.java.view.*
import com.czh.tvmerchantapp.live.push.java.viewmodel.ALiveViewModel
import com.czh.tvmerchantapp.util.EventBusUtils
import com.tbruyelle.rxpermissions2.RxPermissions
import com.umeng.analytics.MobclickAgent
import io.socket.client.Socket
import kotlinx.android.synthetic.main.activity_push.*
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode
import java.io.File

class ALiveActivity : BaseActivity<ALiveViewModel, ActivityPushBinding>(), View.OnClickListener {

    private val TAG = ALiveActivity.javaClass.name

    // 常量
    companion object {
        const val ID_KEY = "ID_KEY"
    }

    // socket
    lateinit var mSocket: Socket

    private lateinit var mLiveId: String
    private var mPushUrl: String? = null

    // ui
    private var mSettingPopupWindow: SettingPopupWindow? = null

    private var mSurfaceStatus = SurfaceStatus.UNINITED
    private var mAlivcLivePusher: AlivcLivePusher? = null
    private var mAlivcLivePushConfig: AlivcLivePushConfig? = null
    private var mAsync = true

    // 美颜
    private var beautyState = true
    private var taoFaceFilter: TaoFaceFilter? = null
    private var taoBeautyFilter: TaoBeautyFilter? = null

    // 清晰度
    private var mClearBottomFragmentDialog: ClearBottomFragmentDialog? = null
    private var mLastClearState = Clear.HD

    // 功能
    private var mCameraId = AlivcLivePushCameraTypeEnum.CAMERA_TYPE_FRONT // 摄像头

    // like数量
    private var mlikeNum = ""

    // 直播中
    private var isLiving = false


    // 权限
    private val permissionManifest = arrayOf(
            Manifest.permission.CAMERA,
            Manifest.permission.RECORD_AUDIO,
            Manifest.permission.WRITE_EXTERNAL_STORAGE,
            Manifest.permission.READ_EXTERNAL_STORAGE
    )

    override fun initWindow(savedInstanceState: Bundle?) {
        super.initWindow(savedInstanceState)
        requestWindowFeature(Window.FEATURE_NO_TITLE)
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        window.addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
        window.setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        EventBusUtils.register(this)
    }

    override fun getLayoutId(): Int = R.layout.activity_push

    override fun initViewModel(): ALiveViewModel {
        return ViewModelProviders.of(this).get(ALiveViewModel::class.java)
    }

    override fun initView(savedInstanceState: Bundle?) {
        val myApplication = application as MyFlutterApplication
        mSocket = myApplication.getSocket()!!
        initPermission()
        exit.setOnClickListener(this)
        setting_button.setOnClickListener(this)
        camera.setOnClickListener(this)
        rt_open.setOnClickListener(this)
        product_show.setOnClickListener(this)
        rt_data.setOnClickListener(this)
        rt_share.setOnClickListener(this)
        initAlive()
        initSetting()
        supportFragmentManager
                .beginTransaction()
                .replace(R.id.frame_layout, ChatSocketFragment.newInstance())
                .commit()
    }

    override fun loadData(savedInstanceState: Bundle?) {
        try {
            mLiveId = intent?.getStringExtra(ID_KEY).toString()
            // 获取直播详情推流url
            mViewModel?.getBroadInfo(mLiveId)
            mViewModel?.getBroadInfoLD()?.observe(this, Observer {
                mPushUrl = it.pushUrl
                tv_package_num.text = it?.products?.size?.toString()
            })
            // 获取关联橱窗列表
            mViewModel?.getDisplayWindowInfo(mLiveId)
            mViewModel?.getLiveWindowDisplay()?.observe(this, Observer {
                product_frame_view.setDataList(it)
                // 通知小程序
                val info = ArrayList<String>()
                for (e in it) {
                    info.add(e.id)
                }
                mSocket.emit("notice", GsonUtils.toJson(mapOf("updateProduct" to info)))
            })
            product_frame_view.setOnAddItemListener(object : AddItemListener {
                override fun onAddItemView() {
                    val mProductBottomFragmentDialog = ProductBottomFragmentDialog(mLiveId)
                    mProductBottomFragmentDialog.show(supportFragmentManager, "")
                }
            })
        } catch (e: Exception) {
            LogUtils.file(TAG, e.toString())
        }
    }

    // 更新橱窗信息
    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onNotifyUpdateDisplay(onNotifyUpdateDisplay: OnNotifyUpdateDisplay) {
        if (onNotifyUpdateDisplay.boolean) {
            mViewModel?.getDisplayWindowInfo(mLiveId)
        }
    }

    // 通知like
    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onNotifyUpdateLikeNum(onNotifyUpdateLikeNum: OnNotifyUpdateLikeNum) {
        if (onNotifyUpdateLikeNum.boolean) {
            val likeNum = onNotifyUpdateLikeNum.num
            mlikeNum = likeNum
            rt_like_num?.text = "$likeNum 赞"
        }
    }

    private fun initAlive() {
        try {
// 直播配置
            mAlivcLivePushConfig = AlivcLivePushConfig()
            // 设置全屏幕
            mAlivcLivePushConfig?.setPreviewOrientation(AlivcPreviewOrientationEnum.ORIENTATION_PORTRAIT)// 竖直模式
//            mAlivcLivePushConfig?.previewDisplayMode = AlivcPreviewDisplayMode.ALIVC_LIVE_PUSHER_PREVIEW_ASPECT_FIT// 模式
            // 设置清晰度，清晰度优先
            mAlivcLivePushConfig?.qualityMode = AlivcQualityModeEnum.QM_RESOLUTION_FIRST// 清晰度优先
            mAlivcLivePushConfig?.setResolution(AlivcResolutionEnum.RESOLUTION_720P)// 默认高清
            mAlivcLivePushConfig?.setVideoEncodeMode(AlivcEncodeModeEnum.Encode_MODE_HARD)
            mAlivcLivePushConfig?.setAudioEncodeMode(AlivcEncodeModeEnum.Encode_MODE_SOFT)
            mAlivcLivePushConfig?.setPreviewMirror(true)
            mAlivcLivePushConfig?.setPushMirror(true)
            // 自动对焦
            mAlivcLivePushConfig?.setAutoFocus(true)
            // 摄像头前置
            mAlivcLivePushConfig?.setCameraType(mCameraId)

            mAlivcLivePusher = AlivcLivePusher()
            mAlivcLivePusher?.init(applicationContext, mAlivcLivePushConfig)
            surface_view?.holder?.addCallback(object : SurfaceHolder.Callback {

                override fun surfaceCreated(holder: SurfaceHolder?) {
                    if (mSurfaceStatus == SurfaceStatus.UNINITED) {
                        mSurfaceStatus = SurfaceStatus.CREATED
                        if (mAsync) {
                            mAlivcLivePusher?.startPreviewAysnc(surface_view)
                        } else {
                            mAlivcLivePusher?.startPreview(surface_view)
                        }
                    } else if (mSurfaceStatus == SurfaceStatus.DESTROYED) {
                        mSurfaceStatus = SurfaceStatus.RECREATED
                    }
                }

                override fun surfaceChanged(holder: SurfaceHolder?, format: Int, width: Int, height: Int) {
                    mSurfaceStatus = SurfaceStatus.CHANGED
                }

                override fun surfaceDestroyed(holder: SurfaceHolder?) {
                    mSurfaceStatus = SurfaceStatus.DESTROYED
                }

            })
            // 推流监听
            mAlivcLivePusher?.setLivePushInfoListener(mPushInfoListener)
            mAlivcLivePusher?.setLivePushNetworkListener(mPushNetworkListener)
            mAlivcLivePusher?.setLivePushErrorListener(mPushErrorListener)
            mAlivcLivePusher?.setCustomDetect(object : AlivcLivePushCustomDetect {

                override fun customDetectCreate() {
                    taoFaceFilter = TaoFaceFilter(applicationContext)
                    taoFaceFilter?.customDetectCreate()
                }

                override fun customDetectProcess(data: Long, width: Int, height: Int, rotation: Int, format: Int, extra: Long): Long {
                    return if (taoFaceFilter != null)
                        taoFaceFilter!!.customDetectProcess(data, width, height, rotation, format, extra)
                    else 0
                }

                override fun customDetectDestroy() {
                    taoFaceFilter?.customDetectDestroy()
                }
            })
            mAlivcLivePusher?.setCustomFilter(object : AlivcLivePushCustomFilter {
                override fun customFilterCreate() {
                    taoBeautyFilter = TaoBeautyFilter()
                    taoBeautyFilter?.customFilterCreate()
                }

                override fun customFilterUpdateParam(fSkinSmooth: Float, fWhiten: Float, fWholeFacePink: Float, fThinFaceHorizontal: Float, fCheekPink: Float, fShortenFaceVertical: Float, fBigEye: Float) {
                    if (taoBeautyFilter != null) {
                        taoBeautyFilter?.customFilterUpdateParam(fSkinSmooth, fWhiten, fWholeFacePink, fThinFaceHorizontal, fCheekPink, fShortenFaceVertical, fBigEye)
                    }
                }

                override fun customFilterSwitch(on: Boolean) {
                    taoBeautyFilter?.customFilterSwitch(on)
                }

                override fun customFilterProcess(inputTexture: Int, textureWidth: Int, textureHeight: Int, extra: Long): Int {
                    return taoBeautyFilter?.customFilterProcess(inputTexture, textureWidth, textureHeight, extra)
                            ?: inputTexture
                }

                override fun customFilterDestroy() {
                    if (taoBeautyFilter != null) {
                        taoBeautyFilter?.customFilterDestroy()
                    }
                    taoBeautyFilter = null
                }

            })
        } catch (e: IllegalArgumentException) {
            e.printStackTrace()
            ToastUtils.showShort(e.message)
        } catch (e: IllegalStateException) {
            e.printStackTrace()
            ToastUtils.showShort(e.message)
        }
    }

    override fun onResume() {
        super.onResume()
        MobclickAgent.onResume(this)
        try {
            if (mAsync)
                mAlivcLivePusher?.resumeAsync()
            else
                mAlivcLivePusher?.resume()
        } catch (e: IllegalStateException) {
            e.printStackTrace()
        } catch (e: IllegalArgumentException) {
            e.printStackTrace()
        }
    }

    override fun onPause() {
        super.onPause()
        MobclickAgent.onPause(this)
        try {
            mAlivcLivePusher?.pause()
        } catch (e: IllegalStateException) {
            e.printStackTrace()
        } catch (e: IllegalArgumentException) {
            e.printStackTrace()
        }
    }

    override fun onDestroy() {
        mAlivcLivePusher?.destroy()
        mAlivcLivePushConfig = null
        mAlivcLivePusher = null
        EventBusUtils.unregister(this)
        super.onDestroy()
    }

    private var mPushInfoListener: AlivcLivePushInfoListener = object : AlivcLivePushInfoListener {
        override fun onPreviewStarted(pusher: AlivcLivePusher) {
//            ToastUtils.showShort("开始预览")
        }

        override fun onPreviewStoped(pusher: AlivcLivePusher) {
//            ToastUtils.showShort("停止预览")
        }

        override fun onPushStarted(pusher: AlivcLivePusher) {
            try {
                isLiving = true
                runOnUiThread {
                    rt_like_num?.visibility = View.VISIBLE
                    rt_open.helper.backgroundColorNormal = resources?.getColor(R.color.color_FFFFFF)!!
                    rt_open.setTextColor(resources?.getColor(R.color.color_F95259)!!)
                    rt_open.text = "结束直播"
                    rt_state.text = "直播中"
                    mViewModel?.mShowDialog?.setValue(false)
                    ToastUtils.showShort("开始直播")
                }
                // 连接socket
                mSocket.connect()
            } catch (e: Exception) {
                LogUtils.file(TAG, e.toString())
            }
        }

        override fun onFirstAVFramePushed(pusher: AlivcLivePusher) {
            LogUtils.i(TAG, "onFirstAVFramePushed")
        }

        override fun onPushPauesed(pusher: AlivcLivePusher) {
//            ToastUtils.showShort("直播暂停")
        }

        override fun onPushResumed(pusher: AlivcLivePusher) {
//            ToastUtils.showShort("直播恢复")
        }

        override fun onPushStoped(pusher: AlivcLivePusher) {
            try {
                isLiving = false
                runOnUiThread {
                    rt_like_num?.visibility = View.INVISIBLE
                    rt_open.helper.backgroundColorNormal = resources?.getColor(R.color.color_F95259)!!
                    rt_open.setTextColor(resources?.getColor(R.color.color_FFFFFF)!!)
                    rt_open.text = "开启直播"
                    rt_state.text = "未开始"
                    mViewModel?.mShowDialog?.setValue(false)
                    ToastUtils.showShort("停止直播")
                    finish()
                }
                // 断开连接socket
                mSocket.disconnect()
            } catch (e: Exception) {
                LogUtils.file(TAG, e.toString())
            }
        }

        override fun onPushRestarted(pusher: AlivcLivePusher) {
            ToastUtils.showShort("重新直播")
        }

        override fun onFirstFramePreviewed(pusher: AlivcLivePusher) {
            LogUtils.i(TAG, "onFirstFramePreviewed")
        }

        override fun onDropFrame(pusher: AlivcLivePusher, countBef: Int, countAft: Int) {
            LogUtils.i(TAG, getString(R.string.drop_frame).toString() + ", 丢帧前：" + countBef + ", 丢帧后：" + countAft)
        }

        override fun onAdjustBitRate(pusher: AlivcLivePusher, curBr: Int, targetBr: Int) {
            LogUtils.i(TAG, getString(R.string.adjust_bitrate).toString() + ", 当前码率：" + curBr + "Kps, 目标码率：" + targetBr + "Kps")
        }

        override fun onAdjustFps(pusher: AlivcLivePusher, curFps: Int, targetFps: Int) {
            LogUtils.i(TAG, getString(R.string.adjust_fps).toString() + ", 当前帧率：" + curFps + ", 目标帧率：" + targetFps)
        }
    }

    private var mPushErrorListener: AlivcLivePushErrorListener = object : AlivcLivePushErrorListener {
        override fun onSystemError(livePusher: AlivcLivePusher, error: AlivcLivePushError) {
            LogUtils.i(TAG, getString(R.string.system_error).toString() + error.toString())
        }

        override fun onSDKError(livePusher: AlivcLivePusher, error: AlivcLivePushError) {
            LogUtils.i(TAG, getString(R.string.sdk_error).toString() + error.toString())
        }
    }

    private var mPushNetworkListener: AlivcLivePushNetworkListener = object : AlivcLivePushNetworkListener {
        override fun onNetworkPoor(pusher: AlivcLivePusher) {
            LogUtils.i(TAG, getString(R.string.network_poor))
        }

        override fun onNetworkRecovery(pusher: AlivcLivePusher) {
            LogUtils.i(TAG, getString(R.string.network_recovery))
        }

        override fun onReconnectStart(pusher: AlivcLivePusher) {
            LogUtils.i(TAG, getString(R.string.reconnect_start))
        }

        override fun onReconnectFail(pusher: AlivcLivePusher) {
            try {
                if (pusher.currentStatus == AlivcLivePushStats.IDLE || pusher.currentStatus == AlivcLivePushStats.ERROR) {
                    ToastUtils.showLong("直播出现问题")
                    runOnUiThread {
                        Handler().postDelayed({
                            AlilivePlugin.methodResult?.success("")
                            finish()
                        }, 2000)
                    }
                }
            } catch (e: Exception) {
                LogUtils.file(TAG, e.toString())
            }
            LogUtils.i(TAG, getString(R.string.reconnect_fail))
        }

        override fun onReconnectSucceed(pusher: AlivcLivePusher) {
            LogUtils.i(TAG, getString(R.string.reconnect_success))
        }

        override fun onSendDataTimeout(pusher: AlivcLivePusher) {
            LogUtils.i(TAG, getString(R.string.senddata_timeout))
        }

        override fun onConnectFail(pusher: AlivcLivePusher) {
            LogUtils.i(TAG, getString(R.string.connect_fail))
        }

        override fun onConnectionLost(pusher: AlivcLivePusher) {
            LogUtils.i(TAG, "推流已断开")
        }

        override fun onPushURLAuthenticationOverdue(pusher: AlivcLivePusher): String {
            LogUtils.i(TAG, "流即将过期，请更换url")
            return ""
        }

        override fun onSendMessage(pusher: AlivcLivePusher) {
            LogUtils.i(TAG, getString(R.string.send_message))
        }

        override fun onPacketsLost(pusher: AlivcLivePusher) {
            LogUtils.i(TAG, "推流丢包通知")
        }
    }

    private fun initPermission() {
        // 开启权限
        val rxPermissions = RxPermissions(this)
        rxPermissions.request(*permissionManifest).subscribe {
            if (!it) {
                ToastUtils.showShort("未授权权限，部分功能不能使用")
            }
        }
    }

    private fun initSetting() {
        try {
            mSettingPopupWindow = SettingPopupWindow(this)
            mSettingPopupWindow?.tvBeautyClick(View.OnClickListener {
                mAlivcLivePusher?.setBeautyOn(!beautyState)
                mSettingPopupWindow?.changeBeauty(beautyState)
                beautyState = !beautyState
                mSettingPopupWindow?.dismiss()
            })
            mSettingPopupWindow?.tvClearClick(View.OnClickListener {
                mClearBottomFragmentDialog = ClearBottomFragmentDialog(object : ClickChooseListener {
                    override fun onClickChooseListener(clearState: Clear) {
                        when (clearState) {
                            Clear.HD -> {
                                mClearBottomFragmentDialog?.setClearState(Clear.HD)
                                mLastClearState = Clear.HD
                                changeClearState(Clear.HD)
                                mClearBottomFragmentDialog?.dismiss()
                            }
                            Clear.FLUENT -> {
                                mClearBottomFragmentDialog?.setClearState(Clear.FLUENT)
                                mLastClearState = Clear.FLUENT
                                changeClearState(Clear.FLUENT)
                                mClearBottomFragmentDialog?.dismiss()
                            }
                        }
                    }
                }, mLastClearState)
                mClearBottomFragmentDialog?.show(supportFragmentManager, "1")
                mSettingPopupWindow?.dismiss()
            })
        } catch (e: Exception) {
            LogUtils.file(TAG, e.toString())
        }
    }

    override fun onClick(v: View?) {
        try {
            when (v?.id) {
                R.id.exit -> {
                    if (isLiving) {
                        showEndDialog()
                    } else {
                        finish()
                    }
                }
                R.id.rt_open -> {
                    if (TextUtils.isEmpty(mPushUrl)) {
                        ToastUtils.showShort("直播地址无效")
                        return
                    }
                    if (isLiving) {
                        showEndDialog()
                    } else {
                        val mStartPushFragmentDialog = StartPushFragmentDialog(object : PushStateListener {
                            override fun onPushStartListener() {
                                try {
                                    mViewModel?.mShowDialog?.setValue(true)
                                    MobclickAgent.onEvent(mContext, "startLive")// 统计开始直播统计
                                    if (mAsync)
                                        mAlivcLivePusher!!.startPushAysnc(mPushUrl)
                                    else
                                        mAlivcLivePusher!!.startPush(mPushUrl)
                                } catch (e: Exception) {
                                    LogUtils.file(e.toString())
                                }
                            }
                        })
                        mStartPushFragmentDialog.show(supportFragmentManager, "")
                    }
                }
                R.id.setting_button -> {
                    mSettingPopupWindow?.showAsDropDownNew(findViewById(R.id.setting_button), 0, 0)
                }
                R.id.camera -> {
                    mCameraId = if (mCameraId == AlivcLivePushCameraTypeEnum.CAMERA_TYPE_FRONT) {
                        AlivcLivePushCameraTypeEnum.CAMERA_TYPE_BACK
                    } else {
                        AlivcLivePushCameraTypeEnum.CAMERA_TYPE_FRONT
                    }
                    mAlivcLivePusher?.switchCamera()
                    changeMirror(mCameraId)
                }
                R.id.product_show -> {
                    product_frame_view.visibility = View.VISIBLE
                    val mProductBottomFragmentDialog = ProductBottomFragmentDialog(mLiveId)
                    mProductBottomFragmentDialog.show(supportFragmentManager, "")
                }
                R.id.rt_data -> {
                    if (!isLiving) {
                        ToastUtils.showShort("直播还未开始")
                        return
                    }
                    val mDataBottomFragmentDialog = DataBottomFragmentDialog(mLiveId)
                    mDataBottomFragmentDialog.show(supportFragmentManager, "")
                }
                R.id.rt_share -> {
                    val mShareBottomFragmentDialog = ShareBottomFragmentDialog(object : ShareSavePicListener {
                        override fun onShareLink() {
                            try {
                                val info = mViewModel?.getBroadInfoLD()?.value
                                val map = mapOf("url" to "${info?.squareCover?.url}", "name" to "${info?.title}", "fileId" to "${info?.squareCover?.fileId}", "description" to "${info?.squareCover?.description}")
                                AlilivePlugin.sharedEvents?.success(map)
                            } catch (e: Exception) {
                                LogUtils.file(TAG, e.toString())
                            }
                        }

                        override fun onShareSavePic() {
                            val mSharePicFragmentDialog = SharePicFragmentDialog(isLiving, mViewModel?.getBroadInfoLD()?.value!!, object : NotifyMediaUpdateListener {
                                override fun onNotifyMediaUpdate(name: String) {
                                    //通知相册
                                    val mediaScanIntent = Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE)
                                    val file = File(name)
                                    val contentUri = Uri.fromFile(file)
                                    mediaScanIntent.data = contentUri
                                    sendBroadcast(mediaScanIntent)
                                }

                            })
                            mSharePicFragmentDialog.show(supportFragmentManager, "")
                        }
                    })
                    mShareBottomFragmentDialog.show(supportFragmentManager, "")
                }
            }
        } catch (e: IllegalArgumentException) {
            e.printStackTrace()
            ToastUtils.showShort(e.message)
        } catch (e: IllegalStateException) {
            e.printStackTrace()
            ToastUtils.showShort(e.message)
        }
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        val rotation = windowManager.defaultDisplay.rotation
        val orientationEnum: AlivcPreviewOrientationEnum
        if (mAlivcLivePusher != null) {
            orientationEnum = when (rotation) {
                Surface.ROTATION_0 -> AlivcPreviewOrientationEnum.ORIENTATION_PORTRAIT
                Surface.ROTATION_90 -> AlivcPreviewOrientationEnum.ORIENTATION_LANDSCAPE_HOME_RIGHT
                Surface.ROTATION_270 -> AlivcPreviewOrientationEnum.ORIENTATION_LANDSCAPE_HOME_LEFT
                else -> AlivcPreviewOrientationEnum.ORIENTATION_PORTRAIT
            }
            try {
                mAlivcLivePusher?.setPreviewOrientation(orientationEnum)
            } catch (e: java.lang.IllegalStateException) {
            }
        }
    }

    /**
     * 视频清晰度
     */
    private fun changeClearState(state: Clear) {
        when (state) {
            Clear.HD -> {
                mAlivcLivePusher?.changeResolution(AlivcResolutionEnum.RESOLUTION_720P)
            }
            Clear.FLUENT -> {
                mAlivcLivePusher?.changeResolution(AlivcResolutionEnum.RESOLUTION_480P)
            }
        }
    }

    /**
     * 切换mirror
     */
    private fun changeMirror(cameraId: AlivcLivePushCameraTypeEnum) {
        when(cameraId) {
            AlivcLivePushCameraTypeEnum.CAMERA_TYPE_FRONT -> {
                mAlivcLivePusher?.setPreviewMirror(true)
                mAlivcLivePusher?.setPushMirror(true)
            }
            AlivcLivePushCameraTypeEnum.CAMERA_TYPE_BACK -> {
                mAlivcLivePusher?.setPreviewMirror(false)
                mAlivcLivePusher?.setPushMirror(false)
            }
        }
    }

    override fun onKeyUp(keyCode: Int, event: KeyEvent?): Boolean {
        when (keyCode) {
            KeyEvent.KEYCODE_BACK -> {
                if (isLiving) {
                    showEndDialog()
                    return true
                }
            }
        }
        return super.onKeyUp(keyCode, event)
    }

    private fun showEndDialog() {
        val mEndPushFragmentDialog = EndPushFragmentDialog(mlikeNum, mLiveId, object : PushEndListener {

            override fun onStopEndListener() {
                try {
                    mViewModel?.mShowDialog?.setValue(true)
                    MobclickAgent.onEvent(mContext, "endLive")// 统计结束直播统计
                    AlilivePlugin.methodResult?.success("")
                    if (mAlivcLivePusher?.currentStatus?.name != "ERROR") {
                        mAlivcLivePusher?.stopPush()
                    }
                } catch (e: Exception) {
                    LogUtils.file(TAG, e.toString())
                    finish()
                }
            }

        })
        mEndPushFragmentDialog.show(supportFragmentManager, "")
    }

}

