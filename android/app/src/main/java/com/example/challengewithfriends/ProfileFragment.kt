package com.example.challengewithfriends

import android.content.Context
import android.net.Uri
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import android.widget.ImageView
import androidx.core.net.toUri
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
import com.bumptech.glide.Glide



class ProfileFragment : Fragment() {
    private lateinit var username:EditText
    private lateinit var password:EditText
    private val client = OkHttpClient()
    private var playerID:Int? = null
    private lateinit var submit: Button
    private lateinit var logout:Button
    private lateinit var group1:EditText
    private lateinit var group2:EditText
    private lateinit var group3:EditText
    private lateinit var leave1:Button
    private lateinit var leave2:Button
    private lateinit var leave3:Button
    private lateinit var add1:Button
    private lateinit var add2:Button
    private lateinit var add3:Button
    private lateinit var profilePic:ImageView
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        arguments?.let {
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        val root:View = inflater.inflate(R.layout.fragment_profile, container, false)
        submit=root.findViewById(R.id.submit)
        logout=root.findViewById(R.id.log_out)
        username=root.findViewById(R.id.username)
        password=root.findViewById(R.id.password)
        group1=root.findViewById(R.id.group1)
        group2=root.findViewById(R.id.group2)
        group3=root.findViewById(R.id.group3)
        leave1=root.findViewById(R.id.group1_leave)
        leave2=root.findViewById(R.id.group2_leave)
        leave3=root.findViewById(R.id.group3_leave)
        add1=root.findViewById(R.id.group1_add)
        add2=root.findViewById(R.id.group2_add)
        add3=root.findViewById(R.id.group3_add)
        profilePic=root.findViewById(R.id.profile_pic_profile)
        val sharedPref = activity?.getSharedPreferences("User Info", Context.MODE_PRIVATE)
        playerID=sharedPref?.getInt("playerID",0)
        val usernameString=sharedPref?.getString("username", null)
        val passwordString=sharedPref?.getString("password", null)
        if (usernameString!=null && passwordString!=null){
            username.setText(usernameString)
            password.setText(passwordString)
        }
        submit.setOnClickListener(){
            login()
        }
        logout.setOnClickListener(){
//            playerID=null
//            setSharedPref()
            fragmentManager?.beginTransaction()
                ?.replace(R.id.fragment_container,MakeAccountFragment())
                ?.commit()
        }
        setGroupStuff(root)
        setPic()
        return root
    }

    private fun setSharedPref(){
        val sharedPref = activity?.getSharedPreferences("User Info", Context.MODE_PRIVATE)
        with(sharedPref!!.edit()){
            if (playerID!=null){
              putInt("playerID", playerID!!)
            }else{
                username.setText("")
                password.setText("")
//                playerID=0
//                putInt("playerID", playerID!!)
            }
            putString("username",username.text.toString())
            putString("password",password.text.toString())
            apply()
        }
    }

    private fun login(){
        val usernameString=username.text.toString()
        val passwordString=password.text.toString()
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

    private fun setPic(){
        if (playerID==null || playerID == 0) return
        var url:String? = null
        CoroutineScope(Dispatchers.Main).launch {
            val request = Request.Builder()
                .url("https://challenge-with-friends.herokuapp.com/api/players/$playerID/")
                .build()
            withContext(Dispatchers.IO) {
                client.newCall(request).execute().use { response ->
                    if (response.isSuccessful) {
                        val moshi = Moshi.Builder()
                            .addLast(KotlinJsonAdapterFactory())
                            .build()
                        val issueAdapter = moshi.adapter(PostNewPlayerResponse::class.java)
                        val issue = issueAdapter.fromJson(response.body?.string())
                        url=issue?.data?.image?.url
                    }
                }
            }
            if (url !=null) Glide.with(context!!).load(url).into(profilePic)
        }
    }

    private fun setGroupStuff(root:View){
        add1.setOnClickListener(){
            addGroup(group1.text.toString())
            leave1.visibility=View.VISIBLE
            add1.visibility=View.GONE
        }
        add2.setOnClickListener(){
            addGroup(group2.text.toString())
            leave2.visibility=View.VISIBLE
            add2.visibility=View.GONE
        }
        add3.setOnClickListener(){
            addGroup(group3.text.toString())
            leave3.visibility=View.VISIBLE
            add3.visibility=View.GONE
        }
        leave1.setOnClickListener(){
            //leave group
            leave1.visibility=View.GONE
            add1.visibility=View.VISIBLE
        }
        leave2.setOnClickListener(){
            //leave group
            leave2.visibility=View.GONE
            add2.visibility=View.VISIBLE
        }
        leave3.setOnClickListener(){
            //leave group
            leave3.visibility=View.GONE
            add3.visibility=View.VISIBLE
        }
    }


    private fun addGroup(groupName: String){
        var groupID:Int?= null
        CoroutineScope(Dispatchers.Main).launch {
            val request = Request.Builder()
                .url("https://challenge-with-friends.herokuapp.com/api/groups/$groupName/")
                .build()
            withContext(Dispatchers.IO) {
                client.newCall(request).execute().use { response ->
                    if (!response.isSuccessful){
                        val json = "application/json; charset=utf-8".toMediaType()
                        val body = "{\"name\":\"$groupName\"}".toRequestBody(json)
                        val request = Request.Builder()
                            .url("https://challenge-with-friends.herokuapp.com/api/groups/")
                            .post(body)
                            .build()
                        withContext(Dispatchers.IO) {
                            client.newCall(request).execute().use { response ->
                                if (!response.isSuccessful){
                                    throw IOException("Here! Unexpected code $response")
                                }
                                val moshi = Moshi.Builder()
                                    .addLast(KotlinJsonAdapterFactory())
                                    .build()
                                val issueAdapter = moshi.adapter(PostNewGroupResponse::class.java)
                                val issue = issueAdapter.fromJson(response.body?.string())
                                groupID = issue?.data?.id
                            }
                        }
                    }else{
                        val moshi = Moshi.Builder()
                            .addLast(KotlinJsonAdapterFactory())
                            .build()
                        val issueAdapter = moshi.adapter(PostNewGroupResponse::class.java)
                        val issue = issueAdapter.fromJson(response.body?.string())
                        groupID = issue?.data?.id
                    }
                    if (groupID!=null && playerID!=null){
                        val json = "application/json; charset=utf-8".toMediaType()
                        val body = "{\"player_id\":\"$playerID\", \"group_id\":\"$groupID\"}".toRequestBody(json)
                        val request = Request.Builder()
                            .url("https://challenge-with-friends.herokuapp.com/api/groups/assign_player_group/")
                            .post(body)
                            .build()
                        withContext(Dispatchers.IO) {
                            client.newCall(request).execute().use { response ->
                                if (!response.isSuccessful) {
                                    throw IOException("Here2! Unexpected code $response")
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private fun addToGroup(groupName:String){
        var groupID:Int?
        CoroutineScope(Dispatchers.Main).launch {
            val request = Request.Builder()
                .url("https://challenge-with-friends.herokuapp.com/api/groups/$groupName")
                .build()

            withContext(Dispatchers.IO) {
                client.newCall(request).execute().use { response ->
                    if (!response.isSuccessful) {
                        val json = "application/json; charset=utf-8".toMediaType()
                        val body = "{\"name\":\"$groupName\"}".toRequestBody(json)
                        val request =Request.Builder()
                            .url("https://challenge-with-friends.herokuapp.com/api/groups/")
                            .post(body)
                            .build()
                        client.newCall(request).execute().use { response ->
                            if (!response.isSuccessful) throw IOException("Here3 Unexpected code $response")
                        }
                        val moshi = Moshi.Builder()
                                .addLast(KotlinJsonAdapterFactory())
                                .build()
                        val issueAdapter = moshi.adapter(PostNewGroupResponse::class.java)
                        val issue = issueAdapter.fromJson(response.body?.string())
                        groupID = issue?.data?.id
                    }else{
                        val moshi = Moshi.Builder()
                                .addLast(KotlinJsonAdapterFactory())
                                .build()
                        val issueAdapter = moshi.adapter(PostNewGroupResponse::class.java)
                        val issue = issueAdapter.fromJson(response.body?.string())
                        groupID = issue?.data?.id
                    }

                    if (playerID!=null && groupID!=null){
                        val json= "application/json; charset=utf-8".toMediaType()
                        val body = "{\"player_id\":\"$playerID\",\"group_id\":\"$groupID\"}".toRequestBody(json)
                        val request=Request.Builder()
                            .url("https://challenge-with-friends.herokuapp.com/api/groups/assign_player_group")
                            .post(body)
                            .build()
                        client.newCall(request).execute().use { response ->
                            if (!response.isSuccessful) throw IOException("Here4 Unexpected code $response")
                        }
                    }

                }
            }
        }
    }

    private fun leaveGroup(groupName:String){

    }

    companion object {

        @JvmStatic
        fun newInstance() =
            ProfileFragment().apply {
                arguments = Bundle().apply {

                }
            }
    }
}