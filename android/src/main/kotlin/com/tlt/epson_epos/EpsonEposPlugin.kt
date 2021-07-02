package com.tlt.epson_epos

import android.app.Activity
import androidx.annotation.NonNull
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.epson.epos2.Log as PrintLog;
import com.google.gson.Gson
import com.epson.epos2.Epos2Exception;
//import com.epson.epos2.discovery.DeviceInfo;
import com.epson.epos2.discovery.Discovery;
import com.epson.epos2.discovery.DiscoveryListener;
import com.epson.epos2.discovery.FilterOption;
import com.epson.epos2.printer.Printer;
import com.epson.epos2.printer.PrinterStatusInfo;
//import com.epson.epos2.printer.ReceiveListener;

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.Exception
import kotlin.collections.ArrayList
import android.util.Base64
import android.R
import com.epson.epos2.printer.ReceiveListener
import java.lang.StringBuilder


interface JSONConvertable {
  fun toJSON(): String = Gson().toJson(this)
}

inline fun <reified T : JSONConvertable> String.toObject(): T = Gson().fromJson(this, T::class.java)

class EpsonEposPrinterInfo(
  var address: String? = null,
  var model: String? = null,
  var type: String? = null,
  var printType: String? = null
) : JSONConvertable

data class EpsonEposPrinterResult(
  var type: String,
  var success: Boolean,
  var message: String? = null,
  var content: Any? = null
) : JSONConvertable

/** EpsonEposPlugin */
class EpsonEposPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var logTag: String = "Epson_ePOS"
  private lateinit var context: Context
  private lateinit var activity: Activity
  private var mPrinter: Printer? = null
  private var mTarget: String? = null
  private var printers: MutableList<Any> = ArrayList()

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity;
  }

  override fun onDetachedFromActivityForConfigChanges() {
    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    TODO("Not yet implemented")
  }

  override fun onDetachedFromActivity() {
    TODO("Not yet implemented")
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "epson_epos")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
    PrintLog.setLogSettings(context, PrintLog.PERIOD_TEMPORARY, PrintLog.OUTPUT_STORAGE, null, 0, 1, PrintLog.LOGLEVEL_LOW);
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull rawResult: Result) {
    val result = MethodResultWrapper(rawResult)
    Thread(MethodRunner(call, result)).start()
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  inner class MethodRunner(call: MethodCall, result: Result) : Runnable, ReceiveListener {
    private val call: MethodCall = call
    private val result: Result = result


    override fun onPtrReceive(p0: Printer?, p1: Int, p2: PrinterStatusInfo?, p3: String?) {
      Log.d(logTag, "${p0?.status} p2 $p2 p3 $p3")
      disconnectPrinter()
    }

    override fun run() {
      Log.d(logTag, "Method Called: ${call.method}")
      when (call.method) {
        "onDiscovery" -> {
          onDiscovery(call, result)
        }
        "onPrint" -> {
          onPrint(call, result)
        }
        "onGetPrinterInfo" -> {
          onGetPrinterInfo(call, result)
        }
        "isPrinterConnected" -> {
          isPrinterConnected(call, result)
        }
        else -> {
          Log.d(logTag, "Method: ${call.method} is not supported yet")
          result.notImplemented()
        }
      }
    }
  }

  class MethodResultWrapper(methodResult: Result) : Result {

    private val methodResult: Result = methodResult
    private val handler: Handler = Handler(Looper.getMainLooper())

    override fun success(result: Any?) {
      handler.post { methodResult.success(result) }
    }

    override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
      handler.post { methodResult.error(errorCode, errorMessage, errorDetails) }
    }

    override fun notImplemented() {
      handler.post { methodResult.notImplemented() }
    }
  }

  /**
   * Stop discovery printer
   */
  private fun stopDiscovery() {
    try {
      Discovery.stop()
    } catch (e: Epos2Exception) {
      if (e.errorStatus != Epos2Exception.ERR_PROCESSING) {

      }
    }
  }

  /**
   * Discovery printers
   */
  private fun onDiscovery(@NonNull call: MethodCall, @NonNull result: Result) {
    val printType: String = call.argument<String>("type") as String
    Log.d(logTag, "onDiscovery type: $printType")
    when (printType) {
      "TCP" -> {
        onDiscoveryTCP(call, result)
      }
      else -> result.notImplemented()
    }
  }

  /**
   * Discovery Printers via TCP/IP
   */
  private fun onDiscoveryTCP(@NonNull call: MethodCall, @NonNull result: Result) {
    printers.clear()
    var filter = FilterOption()
    filter.portType = Discovery.PORTTYPE_TCP
    var resp = EpsonEposPrinterResult("onDiscoveryTCP", false)
    try {
      Discovery.start(context, filter, mDiscoveryListener)
      Handler(Looper.getMainLooper()).postDelayed({
        resp.success = true
        resp.message = "Successfully!"
        resp.content = printers
        result.success(resp.toJSON())
        stopDiscovery()
      }, 7000)

    } catch (e: Exception) {
      Log.e("OnDiscoveryTCP", "Start not working ${call.method}");
      e.printStackTrace()
      resp.success = false
      resp.message = "Error while search printer"
      result.success(resp.toJSON())
    }
  }

  private fun onGetPrinterInfo(@NonNull call: MethodCall, @NonNull result: Result) {
    Log.d(logTag, "onGetPrinterInfo $call $result")
  }

  private fun isPrinterConnected(@NonNull call: MethodCall, @NonNull result: Result) {
    Log.d(logTag, "isPrinterConnected $call $result")
  }

  /**
   * Print
   */
  private fun onPrint(@NonNull call: MethodCall, @NonNull result: Result) {
    val address: String = call.argument<String>("address") as String
    val type: String = call.argument<String>("type") as String
    val series: String = call.argument<String>("series") as String
    val commands: ArrayList<Map<String, Any>> = call.argument<ArrayList<Map<String, Any>>>("commands") as ArrayList<Map<String, Any>>
    var target = "${type}:${address}"
    var resp = EpsonEposPrinterResult("onPrint${type}", false)
    try {
      if(!connectPrinter(target, series)){
        resp.success = false
        resp.message = "Can not connect to the printer."
        result.success(resp.toJSON())
      } else{
        commands.forEach {
          onGenerateCommand(it)
        }
        try {
          val statusInfo: PrinterStatusInfo? = mPrinter!!.status;
          Log.d(logTag, "Printing $target $series Connection: ${statusInfo?.connection} online: ${statusInfo?.online} cover: ${statusInfo?.coverOpen} Paper: ${statusInfo?.paper} ErrorSt: ${statusInfo?.errorStatus} Battery Level: ${statusInfo?.batteryLevel}")
          mPrinter!!.sendData(Printer.PARAM_DEFAULT)
          Log.d(logTag, "Printed $target $series")
        } catch (ex: Epos2Exception) {
          ex.printStackTrace()
          Log.e(logTag, "sendData Error" + ex.errorStatus, ex)
          disconnectPrinter()
        }
      }
    } catch (e: Exception) {
      e.printStackTrace()
      resp.success = false
      resp.message = "Print error"
      result.success(resp.toJSON())
    }
  }

  /// FUNCTIONS

  private val mDiscoveryListener = DiscoveryListener { deviceInfo ->
      Log.d(logTag, "Found: ${deviceInfo?.deviceName}")
      var printer = EpsonEposPrinterInfo(deviceInfo.ipAddress, deviceInfo.deviceName)
      printers.add(printer)
  }

  private fun connectPrinter(target: String, series: String): Boolean{
    var printCons = getPrinterConstant(series)
    if(mPrinter == null || mTarget != target){
      mPrinter = Printer(printCons, 0, context)
      mTarget = target
    }
    Log.d(logTag, "Connect Printer w $series constant: $printCons")

    try {
      val statusInfo: PrinterStatusInfo? = mPrinter!!.status;
      Log.d(logTag, "Printing $target $series Connection: ${statusInfo?.connection} online: ${statusInfo?.online} cover: ${statusInfo?.coverOpen} Paper: ${statusInfo?.paper} ErrorSt: ${statusInfo?.errorStatus} Battery Level: ${statusInfo?.batteryLevel}")
      if(statusInfo?.connection == 0){
        mPrinter!!.connect(target, Printer.PARAM_DEFAULT)
      }
    } catch (e: Epos2Exception) {
//      var errCode = e.errorStatus
      Log.e(logTag, "Connect Error ${e.errorStatus}", e)
      return false
    }
    return true
  }

  private fun disconnectPrinter() {
    if (mPrinter == null) {
      return
    }
    while (true) {
      try {
        mPrinter!!.disconnect()
        mPrinter = null
        mTarget = null
        break
      } catch (e: Exception) {
        mPrinter!!.clearCommandBuffer()
       throw e
      }
    }
    mPrinter!!.clearCommandBuffer()
  }

  private fun onGenerateCommand(command: Map<String, Any>) {
    if (mPrinter == null) {
      return
    }
    Log.d(logTag, "onGenerateCommand: $command")
    val textData = StringBuilder()

    var commandId: String = command["id"] as String
    if (!commandId.isNullOrEmpty()) {
      var commandValue = command["value"]

      when (commandId) {

        "appendText" -> {
          Log.d(logTag, "appendText: $commandValue")
          textData.append(commandValue.toString())
          mPrinter!!.addText(textData.toString())
          textData.delete(0, textData.length)
        }
        "addImage" -> {
          try {
            var width: Int = command["width"] as Int
            var height: Int = command["height"] as Int
            var posX: Int = command["posX"] as Int
            var posY: Int = command["posY"] as Int
            val bitmap: Bitmap? = convertBase64toBitmap(commandValue as String)
            Log.d(logTag, "appendBitmap: $width x $height $posX $posY bitmap $bitmap")
            mPrinter!!.addImage(bitmap, posX, posY, width, height, Printer.PARAM_DEFAULT, Printer.PARAM_DEFAULT, Printer.PARAM_DEFAULT, 1.0, Printer.COMPRESS_AUTO)
          } catch (e: Exception) {
            Log.e(logTag, "onGenerateCommand Error" + e.localizedMessage)
          }
        }
        "addFeedLine" -> {
          mPrinter!!.addFeedLine(commandValue as Int)
        }
        "addCut" -> {
          when(commandValue.toString()){
            "CUT_FEED" -> {
              mPrinter!!.addCut(Printer.CUT_FEED)
            }
            "CUT_NO_FEED" -> {
              mPrinter!!.addCut(Printer.CUT_NO_FEED)
            }
            "CUT_RESERVE" -> {
              mPrinter!!.addCut(Printer.CUT_RESERVE)
            } else -> {
              mPrinter!!.addCut(Printer.PARAM_DEFAULT)
            }
          }
        }
        "addLineSpace" -> {
          mPrinter!!.addFeedLine(commandValue as Int)
        }
        "addTextAlign" -> {
          when(commandValue.toString()){
            "LEFT" -> {
              mPrinter!!.addTextAlign(Printer.ALIGN_LEFT)
            }
            "CENTER" -> {
              mPrinter!!.addTextAlign(Printer.ALIGN_CENTER)
            }
            "RIGHT" -> {
              mPrinter!!.addTextAlign(Printer.ALIGN_RIGHT)
            } else -> {
              mPrinter!!.addTextAlign(Printer.PARAM_DEFAULT)
            }
          }
        }
      }
    }
  }

  private fun getPrinterConstant(series: String): Int{
    return when(series){
      "TM_M10" -> Printer.TM_M10
      "TM_M30" -> Printer.TM_M30
      "TM_M30II" -> Printer.TM_M30II
      "TM_M50" -> Printer.TM_M50
      "TM_P20" -> Printer.TM_P20
      "TM_P60" -> Printer.TM_P60
      "TM_P60II" -> Printer.TM_P60II
      "TM_P80" -> Printer.TM_P80
      "TM_T20" -> Printer.TM_T20
      "TM_T60" -> Printer.TM_T60
      "TM_T70" -> Printer.TM_T70
      "TM_T81" -> Printer.TM_T81
      "TM_T82" -> Printer.TM_T82
      "TM_T83" -> Printer.TM_T83
      "TM_T83III" -> Printer.TM_T83III
      "TM_T88" -> Printer.TM_T88
      "TM_T90" -> Printer.TM_T90
      "TM_T100" -> Printer.TM_T100
      "TM_U220" -> Printer.TM_U220
      "TM_U330" -> Printer.TM_U330
      "TM_L90" -> Printer.TM_L90
      "TM_H6000" -> Printer.TM_H6000
      else -> 0
    }
  }

  private fun convertBase64toBitmap(base64Str: String): Bitmap? {
    val decodedBytes: ByteArray = Base64.decode(base64Str, Base64.DEFAULT)
    return BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.size)
  }
}
