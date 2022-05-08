package com.example.contact_app

import android.content.ContentResolver
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.os.PersistableBundle
import android.provider.ContactsContract
import androidx.core.app.ActivityCompat
import androidx.lifecycle.lifecycleScope
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.launch

const val RQ_CODE = 100
const val REQUEST_READ_CONTACTS = 101

class MainActivity : FlutterActivity() {
    lateinit var myresult: MethodChannel.Result
    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "MY_CHANNEL"
        ).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            // Note: this method is invoked on the main thread.
            if (call.method == "mycall") {
                myresult = result //Store the flutter result

                //start new screen

                val intent1 =
                    Intent(context, SecondActivity::class.java) //Start your special native stuff
                startActivityForResult(intent1, RQ_CODE)

            } else {
                result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == RQ_CODE) {
            if (ActivityCompat.checkSelfPermission(
                    this,
                    android.Manifest.permission.READ_CONTACTS
                )
                == PackageManager.PERMISSION_GRANTED
            ) {
                lifecycleScope.launch {
                    getContacts()
                }
            }
        }
    }

    private fun getContacts() {
        val contactList = ArrayList<Map<String,String>>()
        val resolver: ContentResolver = contentResolver;
        val cursor = resolver.query(
            ContactsContract.Contacts.CONTENT_URI, null, null, null,
            null
        )

        cursor?.let { cursorObject ->
            while (cursor.moveToNext()) {
                val id =
                    cursorObject.getString(cursorObject.getColumnIndex(ContactsContract.Contacts._ID))
                val name =
                    cursorObject.getString(cursorObject.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME))

                val phoneNumber =
                    cursorObject.getString(cursorObject.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME))

                val contact = ContactModel(id = id, name = name, phoneNumber = phoneNumber)
                contactList.add(contact.getResult())
            }
        }
        cursor?.close()
        myresult.success(contactList)
    }

    data class ContactModel(val id: String, val name: String, val phoneNumber: String){
        fun getResult() = hashMapOf<String, String>().apply {
            put("id", id)
            put("name", name)
            put("phoneNumber", phoneNumber)
        }
    }
}

