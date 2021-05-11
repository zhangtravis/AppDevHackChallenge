package com.example.challengewithfriends

import android.content.Context
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import android.widget.ImageView
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
import java.io.IOException


class MakeAccountFragment : Fragment() {
    private lateinit var username:EditText
    private lateinit var password:EditText
    private lateinit var profilePic:ImageView
    private lateinit var submit:Button
    private val client = OkHttpClient()
    private var playerID:Int? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        arguments?.let {

        }
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?,
                              savedInstanceState: Bundle?): View? {
        // Inflate the layout for this fragment
        val root:View= inflater.inflate(R.layout.fragment_make_account, container, false)
        username=root.findViewById(R.id.username_create)
        password=root.findViewById(R.id.password_create)
        profilePic=root.findViewById(R.id.profile_pic_create)
        submit=root.findViewById(R.id.submit_create)

        submit.setOnClickListener(){
            val usernameString=username.text.toString()
            val passwordString=password.text.toString()
            if (usernameString.isNotEmpty() && passwordString.isNotEmpty()){
                makePlayer(usernameString, passwordString)
                fragmentManager?.beginTransaction()
                    ?.replace(R.id.fragment_container,ProfileFragment())
                    ?.commit()
            }

        }
        return root
    }

    private fun makePlayer(usernameString:String, passwordString:String){
        CoroutineScope(Dispatchers.Main).launch {
            val json = "application/json; charset=utf-8".toMediaType()
            val body ="{\"username\":\"$usernameString\",\"password\":\"$passwordString\",\"image_data\":\"null\"}".toRequestBody(json)
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
                                playerID?.let { putInt("playerID", it) }
                            }
                            putString("username", usernameString)
                            putString("password", passwordString)
                            apply()
                        }
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