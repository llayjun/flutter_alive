package com.czh.tvmerchantapp.live.pull

import android.os.Bundle
import android.view.SurfaceHolder
import android.view.SurfaceView
import androidx.appcompat.app.AppCompatActivity
import com.czh.tvmerchantapp.R
import com.pili.pldroid.player.AVOptions
import com.pili.pldroid.player.PLMediaPlayer

class PlayActivity : AppCompatActivity() {

    companion object {
        const val LIVE_URL_KEY = "LIVE_URL_KEY"
    }

    private var mMediaPlayer: PLMediaPlayer? = null
    private var mSurfaceView: SurfaceView? = null
    private var mAVOptions: AVOptions? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.play_activity)
        val url = intent.getStringExtra(LIVE_URL_KEY)
        mSurfaceView = findViewById(R.id.surface_view)
        mAVOptions = AVOptions()
        mAVOptions?.setInteger(AVOptions.KEY_PREPARE_TIMEOUT, 10 * 1000)
        mMediaPlayer = PLMediaPlayer(this, mAVOptions)
        mSurfaceView?.holder?.addCallback(object : SurfaceHolder.Callback {
            override fun surfaceCreated(holder: SurfaceHolder) {
                mMediaPlayer?.setDisplay(mSurfaceView?.holder)
                mMediaPlayer?.dataSource = url
                mMediaPlayer?.prepareAsync()
                mMediaPlayer?.start()
            }

            override fun surfaceChanged(holder: SurfaceHolder, format: Int, width: Int, height: Int) {}
            override fun surfaceDestroyed(holder: SurfaceHolder) {}
        })
    }
}