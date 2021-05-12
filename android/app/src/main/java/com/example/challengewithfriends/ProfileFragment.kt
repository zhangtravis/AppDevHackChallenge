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
import java.io.ByteArrayOutputStream
import java.util.*


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
    private var playerGroups:Array<Group>? = arrayOf()
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
        setPicClick()
        return root
    }

    private fun setPicClick(){
        profilePic.setOnClickListener(){
            val gallery = Intent(Intent.ACTION_PICK, MediaStore.Images.Media.INTERNAL_CONTENT_URI)
            startActivityForResult(gallery,100)
        }
    }
    @RequiresApi(Build.VERSION_CODES.O)
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if(resultCode == Activity.RESULT_OK && requestCode == 100){
            val imageURI=data?.data
            val bitmap: Bitmap = MediaStore.Images.Media.getBitmap(activity?.contentResolver,imageURI)
            val baos: ByteArrayOutputStream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.PNG,100,baos)
            val b:ByteArray = baos.toByteArray()
            var encodedImage:String = Base64.getEncoder().encodeToString(b)
            encodedImage="data:image/png;base64,"+encodedImage
            CoroutineScope(Dispatchers.Main).launch {
                val json = "application/json; charset=utf-8".toMediaType()
                val body = "{\"player_id\":\"$playerID\",\"image_data\":\"$encodedImage\"}".toRequestBody(json)
                val request = Request.Builder()
                    .url("https://challenge-with-friends.herokuapp.com/api/players/update_profile_pic/")
                    .post(body)
                    .build()

                withContext(Dispatchers.IO) {
                    client.newCall(request).execute().use { response ->
                        if (!response.isSuccessful) throw IOException("Unexpected code $response")
                    }
                    setPic()
                }
            }
        }
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
            leaveGroup(group1.text.toString())
            group1.setText("")
            leave1.visibility=View.GONE
            add1.visibility=View.VISIBLE
        }
        leave2.setOnClickListener(){
            leaveGroup(group2.text.toString())
            group2.setText("")
            leave2.visibility=View.GONE
            add2.visibility=View.VISIBLE
        }
        leave3.setOnClickListener(){
            leaveGroup(group2.text.toString())
            group3.setText("")
            leave3.visibility=View.GONE
            add3.visibility=View.VISIBLE
        }
        getPlayerGroups()
    }

    private fun getPlayerGroups(){
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
                        playerGroups=issue?.data?.groups
                        activity?.runOnUiThread(){
                            for (i:Int in playerGroups!!.indices){
                                if (i==0){
                                    group1.setText(playerGroups!![i].name)
                                    leave1.visibility=View.VISIBLE
                                    add1.visibility=View.GONE
                                }
                                if (i==1){
                                    group2.setText(playerGroups!![i].name)
                                    leave2.visibility=View.VISIBLE
                                    add2.visibility=View.GONE
                                }
                                if (i==2){
                                    group3.setText(playerGroups!![i].name)
                                    leave3.visibility=View.VISIBLE
                                    add3.visibility=View.GONE
                                }
                            }
                        }
                    }
                }
            }
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


    private fun leaveGroup(groupName:String){
        var groupId:Int = -1
        for (i:Int in playerGroups!!.indices){
            if (groupName==playerGroups!![i].name) groupId=playerGroups!![i].id
        }
        if (groupId==-1) return
        CoroutineScope(Dispatchers.Main).launch {
            val request = Request.Builder()
                .delete()
                .url("https://challenge-with-friends.herokuapp.com/api/groups/$groupId/$playerID/")
                .build()

            withContext(Dispatchers.IO) {
                client.newCall(request).execute().use { response ->
                    if (!response.isSuccessful) throw IOException("Unexpected code $response")
                }
            }
        }
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