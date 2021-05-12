package com.example.challengewithfriends

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.MediaStore
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import android.widget.ImageView
import androidx.annotation.RequiresApi
import com.squareup.moshi.Moshi
import com.squareup.moshi.kotlin.reflect.KotlinJsonAdapterFactory
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import java.io.ByteArrayOutputStream
import java.io.IOException
import java.util.*


class MakeAccountFragment : Fragment() {
    private lateinit var username:EditText
    private lateinit var password:EditText
    private lateinit var profilePic:ImageView
    private var encodedString:String=""
    private var imageURI: Uri? = null
    private lateinit var login:Button
    private lateinit var signup:Button
    private val client = OkHttpClient()
    private var playerID:Int? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        arguments?.let {

        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?,
                              savedInstanceState: Bundle?): View? {
        // Inflate the layout for this fragment
        val root:View= inflater.inflate(R.layout.fragment_make_account, container, false)
        username=root.findViewById(R.id.username_create)
        password=root.findViewById(R.id.password_create)
        profilePic=root.findViewById(R.id.profile_pic_create)
        login=root.findViewById(R.id.log_in_create)
        signup=root.findViewById(R.id.sign_up_create)

        val sharedPref = activity?.getSharedPreferences("User Info", Context.MODE_PRIVATE)
        val usernameString=sharedPref?.getString("username", null)
        val passwordString=sharedPref?.getString("password", null)
        if (usernameString!=null && passwordString!=null){
            username.setText(usernameString)
            password.setText(passwordString)
        }

        signup.visibility=View.GONE
        profilePic.setOnClickListener(){
            val gallery = Intent(Intent.ACTION_PICK, MediaStore.Images.Media.INTERNAL_CONTENT_URI)
            startActivityForResult(gallery,100)
            signup.visibility=View.VISIBLE
        }

        signup.setOnClickListener(){
            encode()
            val usernameString=username.text.toString()
            val passwordString=password.text.toString()
            if (usernameString.isNotEmpty() && passwordString.isNotEmpty()){
                makePlayer(usernameString, passwordString)
            }
            login.visibility=View.GONE
            signup.visibility=View.GONE
        }

        login.setOnClickListener(){
            val usernameString=username.text.toString()
            val passwordString=password.text.toString()
            if (usernameString.isNotEmpty() && passwordString.isNotEmpty()){
                login(usernameString, passwordString)
            }
            login.visibility=View.GONE
            signup.visibility=View.GONE
        }
        return root
    }


    @RequiresApi(Build.VERSION_CODES.O)
    private fun encode(){
        val bitmap: Bitmap = MediaStore.Images.Media.getBitmap(activity?.contentResolver,imageURI)
        val baos: ByteArrayOutputStream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG,100,baos)
        val b:ByteArray = baos.toByteArray()
        encodedString = Base64.getEncoder().encodeToString(b)
        encodedString="data:image/png;base64,"+encodedString
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if(resultCode == Activity.RESULT_OK && requestCode == 100){
            imageURI=data?.data
            profilePic.setImageURI(imageURI)
        }
    }

    private fun makePlayer(usernameString:String, passwordString:String){
        CoroutineScope(Dispatchers.Main).launch {
            val json = "application/json; charset=utf-8".toMediaType()
            val body ="{\"username\":\"$usernameString\",\"password\":\"$passwordString\",\"image_data\":\"$encodedString\"}".toRequestBody(json)
            val request = Request.Builder()
                .url("https://challenge-with-friends.herokuapp.com/api/players/")
                .post(body)
                .build()
            withContext(Dispatchers.IO) {
                client.newCall(request).execute().use { response ->
                    if (response.isSuccessful) {
                        val moshi = Moshi.Builder()
                            .addLast(KotlinJsonAdapterFactory())
                            .build()
                        val issueAdapter = moshi.adapter(PostNewPlayerResponse::class.java)
                        val issue = issueAdapter.fromJson(response.body?.string())
                        playerID = issue?.data?.id
                        val sharedPref = activity?.getSharedPreferences("User Info", Context.MODE_PRIVATE)
                        with(sharedPref!!.edit()) {
                            if (playerID != null) {
                                putInt("playerID", playerID!!)
                            }
                            putString("username", usernameString)
                            putString("password", passwordString)
                            apply()
                        }
                        fragmentManager?.beginTransaction()
                            ?.replace(R.id.fragment_container,HomeFragment())
                            ?.commit()

                    }
                }
            }

        }
    }

    private fun login(usernameString: String, passwordString: String){
        CoroutineScope(Dispatchers.Main).launch {
            val json = "application/json; charset=utf-8".toMediaType()
            val body ="{\"username\":\"$usernameString\",\"password\":\"$passwordString\"}".toRequestBody(json)
            val request = Request.Builder()
                .url("https://challenge-with-friends.herokuapp.com/api/login/")
                .post(body)
                .build()
            withContext(Dispatchers.IO) {
                client.newCall(request).execute().use { response ->
                    if (response.isSuccessful) {
                        val moshi = Moshi.Builder()
                            .addLast(KotlinJsonAdapterFactory())
                            .build()
                        val issueAdapter = moshi.adapter(PostNewPlayerResponse::class.java)
                        val issue = issueAdapter.fromJson(response.body?.string())
                        playerID = issue?.data?.id
                        val sharedPref = activity?.getSharedPreferences("User Info", Context.MODE_PRIVATE)
                        with(sharedPref!!.edit()) {
                            if (playerID != null) {
                                putInt("playerID", playerID!!)
                            }
                            putString("username", usernameString)
                            putString("password", passwordString)
                            apply()
                        }
                        fragmentManager?.beginTransaction()
                            ?.replace(R.id.fragment_container,HomeFragment())
                            ?.commit()
                    }
                }
            }

        }
    }

    companion object {

        @JvmStatic
        fun newInstance() =
                MakeAccountFragment().apply {
                    arguments = Bundle().apply {

                    }
                }
    }
}