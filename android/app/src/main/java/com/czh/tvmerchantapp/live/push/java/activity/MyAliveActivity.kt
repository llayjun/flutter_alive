package com.czh.tvmerchantapp.live.push.java.activity

import android.app.Activity
import android.os.Bundle
import android.view.SurfaceHolder
import android.view.SurfaceView
import com.alivc.live.pusher.*
import com.alivc.live.pusher.SurfaceStatus
import com.blankj.utilcode.util.ToastUtils
import com.czh.tvmerchantapp.R

class MyAliveActivity : Activity() {

    private var mAlivcLivePushConfig: AlivcLivePushConfig? = null
    private var mAlivcLivePusher: AlivcLivePusher? = null
    private var mSurfaceView: SurfaceView? = null
    private var mSurfaceStatus = SurfaceStatus.UNINITED
    private var mAsync = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.my_activity_push)
        mSurfaceView = findViewById(R.id.preview_view)
        mAlivcLivePushConfig = AlivcLivePushConfig()
        mAlivcLivePusher = AlivcLivePusher()
        try {
            mAlivcLivePusher!!.init(applicationContext, mAlivcLivePushConfig)
        } catch (e: IllegalArgumentException) {
            e.printStackTrace()
        } catch (e: IllegalStateException) {
            e.printStackTrace()
        }
        mAlivcLivePusher!!.setLivePushInfoListener(mPushInfoListener)
        mAlivcLivePusher!!.setLivePushErrorListener(mPushErrorListener)
        mSurfaceView?.holder?.addCallback(object : SurfaceHolder.Callback {

            override fun surfaceCreated(holder: SurfaceHolder?) {
                if (mSurfaceStatus == SurfaceStatus.UNINITED) {
                    mSurfaceStatus = SurfaceStatus.CREATED
                    if (mAsync) {
                        mAlivcLivePusher?.startPreviewAysnc(mSurfaceView)
                    } else {
                        mAlivcLivePusher?.startPreview(mSurfaceView)
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
    }

    override fun onResume() {
        super.onResume()
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
        try {
            mAlivcLivePusher?.pause()
        } catch (e: IllegalStateException) {
            e.printStackTrace()
        } catch (e: IllegalArgumentException) {
            e.printStackTrace()
        }
    }

    var mPushInfoListener: AlivcLivePushInfoListener = object : AlivcLivePushInfoListener {
        override fun onPreviewStarted(pusher: AlivcLivePusher) {
            ToastUtils.showShort(getString(R.string.start_preview))
        }

        override fun onPreviewStoped(pusher: AlivcLivePusher) {
            ToastUtils.showShort(getString(R.string.stop_preview))
        }

        override fun onPushStarted(pusher: AlivcLivePusher) {
            ToastUtils.showShort(getString(R.string.start_push))
        }

        override fun onFirstAVFramePushed(pusher: AlivcLivePusher) {}
        override fun onPushPauesed(pusher: AlivcLivePusher) {
            ToastUtils.showShort(getString(R.string.pause_push))
        }

        override fun onPushResumed(pusher: AlivcLivePusher) {
            ToastUtils.showShort(getString(R.string.resume_push))
        }

        override fun onPushStoped(pusher: AlivcLivePusher) {
            ToastUtils.showShort(getString(R.string.stop_push))
        }

        /**
         * 推流重启通知
         *
         * @param pusher AlivcLivePusher实例
         */
        override fun onPushRestarted(pusher: AlivcLivePusher) {
            ToastUtils.showShort(getString(R.string.restart_success))
        }

        override fun onFirstFramePreviewed(pusher: AlivcLivePusher) {
            ToastUtils.showShort(getString(R.string.first_frame))
        }

        override fun onDropFrame(pusher: AlivcLivePusher, countBef: Int, countAft: Int) {
            ToastUtils.showShort(getString(R.string.drop_frame).toString() + ", 丢帧前：" + countBef + ", 丢帧后：" + countAft)
        }

        override fun onAdjustBitRate(pusher: AlivcLivePusher, curBr: Int, targetBr: Int) {
            ToastUtils.showShort(getString(R.string.adjust_bitrate).toString() + ", 当前码率：" + curBr + "Kps, 目标码率：" + targetBr + "Kps")
        }

        override fun onAdjustFps(pusher: AlivcLivePusher, curFps: Int, targetFps: Int) {
            ToastUtils.showShort(getString(R.string.adjust_fps).toString() + ", 当前帧率：" + curFps + ", 目标帧率：" + targetFps)
        }
    }

    var mPushErrorListener: AlivcLivePushErrorListener = object : AlivcLivePushErrorListener {
        override fun onSystemError(livePusher: AlivcLivePusher, error: AlivcLivePushError) {
            ToastUtils.showShort(getString(R.string.system_error).toString() + error.toString())
        }

        override fun onSDKError(livePusher: AlivcLivePusher, error: AlivcLivePushError) {
            ToastUtils.showShort(getString(R.string.sdk_error).toString() + error.toString())
        }
    }
}