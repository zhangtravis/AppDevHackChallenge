package com.example.challengewithfriends

import android.content.Context
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import com.squareup.moshi.Moshi
import com.squareup.moshi.kotlin.reflect.KotlinJsonAdapterFactory
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import java.io.IOException


class ProfileFragment : Fragment() {
    private lateinit var username:EditText
    private lateinit var password:EditText
    private val client = OkHttpClient()
    private var playerID:Int? = null
    private lateinit var submit: Button
    private lateinit var group1:EditText
    private lateinit var group2:EditText
    private lateinit var group3:EditText
    private lateinit var leave1:Button
    private lateinit var leave2:Button
    private lateinit var leave3:Button
    private lateinit var add1:Button
    private lateinit var add2:Button
    private lateinit var add3:Button
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
        val sharedPref = root.context?.getSharedPreferences("User Info", Context.MODE_PRIVATE)
        val usernameString=sharedPref?.getString("username", null)
        val passwordString=sharedPref?.getString("password", null)
        if (usernameString!=null){
            username.setText(usernameString)
            password.setText(passwordString)
        }
        submit.setOnClickListener(){
//            getPlayerByUsername()
            setSharedPref(root)
        }
        setGroupStuff(root)
        return root
    }

    private fun setSharedPref(root:View){
        val sharedPref = root.context?.getSharedPreferences("User Info", Context.MODE_PRIVATE)
        with(sharedPref!!.edit()){
            if (playerID!=null){
//              playerID?.let { putInt("playerID", it) }
            }else{
                username.setText("")
                password.setText("")
            }
            putString("username",username.text.toString())
            putString("password",password.text.toString())
            apply()
        }
    }

    private fun getPlayerByUsername(){
        val usernameString=username.toString()
        val passwordString=password.toString()
        CoroutineScope(Dispatchers.Main).launch {
            val request = Request.Builder()
                .url("https://challenge-with-friends.herokuapp.com/api/players/$usernameString")
                .build()

            withContext(Dispatchers.IO) {
                client.newCall(request).execute().use { response ->
                    if (!response.isSuccessful) throw IOException("Unexpected code $response")

                    val moshi = Moshi.Builder()
                        .addLast(KotlinJsonAdapterFactory())
                        .build()
                    val issueAdapter = moshi.adapter(Player::class.java)
                    val issue = issueAdapter.fromJson(response.body?.string())
                    playerID = if(passwordString == issue?.password) issue.id else null
                }
            }
        }
    }

    private fun setGroupStuff(root:View){
        add1.setOnClickListener(){
            addToGroup(group1.text.toString())
            leave1.visibility=View.VISIBLE
            add1.visibility=View.GONE
        }
        add2.setOnClickListener(){
            addToGroup(group2.text.toString())
            leave2.visibility=View.VISIBLE
            add2.visibility=View.GONE
        }
        add3.setOnClickListener(){
            addToGroup(group3.text.toString())
            leave3.visibility=View.VISIBLE
            add3.visibility=View.GONE
        }
        leave1.setOnClickListener(){

        }
    }

    private fun addToGroup(name:String){
        var groupID:Int?=null
        CoroutineScope(Dispatchers.Main).launch {
            val request = Request.Builder()
                .url("https://challenge-with-friends.herokuapp.com/api/groups/$name")
                .build()

            withContext(Dispatchers.IO) {
                client.newCall(request).execute().use { response ->
                    if (!response.isSuccessful) throw IOException("Unexpected code $response")

                    val moshi = Moshi.Builder()
                        .addLast(KotlinJsonAdapterFactory())
                        .build()
                    val issueAdapter = moshi.adapter(SuccessTest::class.java)
                    val issue = issueAdapter.fromJson(response.body?.string())
                    if (issue!= null && issue.success){
                        val moshi = Moshi.Builder()
                            .addLast(KotlinJsonAdapterFactory())
                            .build()
                        val issueAdapter = moshi.adapter(Group::class.java)
                        val issue = issueAdapter.fromJson(response.body?.string())
                        groupID=issue?.id
                    }else{
                        val request = Request.Builder()
                            .url("https://challenge-with-friends.herokuapp.com/api/groups/")
                            .post("{\"name\": $name}".toRequestBody())
                            .build()

                        client.newCall(request).execute().use { response ->
                            if (!response.isSuccessful) throw IOException("Unexpected code $response")
                            val moshi = Moshi.Builder()
                                .addLast(KotlinJsonAdapterFactory())
                                .build()
                            val issueAdapter = moshi.adapter(Group::class.java)
                            val issue = issueAdapter.fromJson(response.body?.string())
                            groupID=issue?.id
                        }
                    }
                    if (playerID!=null && groupID!=null){
                        val request = Request.Builder()
                            .url("https://challenge-with-friends.herokuapp.com/api/groups/assign_player_group")
                            .post("{\"player_id\":$playerID,\"group_id\":$groupID}".toRequestBody())
                            .build()

                        client.newCall(request).execute().use { response ->
                            if (!response.isSuccessful) throw IOException("Unexpected code $response")

                        }
                    }
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