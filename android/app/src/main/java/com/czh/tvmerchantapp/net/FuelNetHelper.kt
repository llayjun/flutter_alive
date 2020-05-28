package com.czh.tvmerchantapp.net

import com.blankj.utilcode.util.LogUtils
import com.czh.tvmerchantapp.base.Api
import com.czh.tvmerchantapp.base.Constant
import com.github.kittinunf.fuel.core.*
import com.github.kittinunf.fuel.core.interceptors.LogRequestInterceptor
import com.github.kittinunf.fuel.core.interceptors.LogResponseInterceptor

object FuelNetHelper {

    fun initFuel() {
        // 服务器base地址
        FuelManager.instance.basePath = Api.BASE_URL
        FuelManager.instance.timeoutInMillisecond = 20000
        FuelManager.instance.addRequestInterceptor(tokenInterceptor())
        FuelManager.instance.addRequestInterceptor(cUrlLoggingRequestInterceptor())
        FuelManager.instance.addResponseInterceptor(cUrlLoggingResponseInterceptor)
    }

    // token
    private fun tokenInterceptor() = { next: (Request) -> Request ->
        { req: Request ->
            req.header(mapOf("Authorization" to "${Constant.token}"))
            next(req)
        }
    }

    // 日志拦截
    private fun cUrlLoggingRequestInterceptor() = { next: (Request) -> Request ->
        { r: Request ->
            val logging = StringBuffer()
            logging.append("\n-----Method = ${r.method}")
            logging.append("\n-----headers = ${r.headers}")
            logging.append("\n-----url---->${r.url}")
            if (r.method == Method.POST) {
                logging.append("\n-----request parameters:")
                r.parameters.forEach {
                    logging.append("\n-----${it.first}=${it.second}")
                }
            }
            LogUtils.a(logging.toString())
            next(r)
        }
    }

    // 日志拦截
    object cUrlLoggingResponseInterceptor : FoldableResponseInterceptor {

        override fun invoke(next: ResponseTransformer): ResponseTransformer {
            return { request, response ->
                val logging = StringBuffer()
                logging.append("\n-----statusCode = ${response.statusCode} ${response.url}")
                logging.append("\n-----Response = ${response.responseMessage}")
                logging.append("\n-----Body---->${response.body().asString(response.headers[Headers.CONTENT_TYPE].lastOrNull())}")
                LogUtils.a(logging.toString())
                next(request, response)
            }
        }
    }

}