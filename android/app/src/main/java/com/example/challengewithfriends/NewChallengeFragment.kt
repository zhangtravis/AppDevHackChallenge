package com.example.challengewithfriends

import android.content.Context
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
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


class NewChallengeFragment : Fragment() {
    private val client = OkHttpClient()
    private lateinit var newChallengeTitle:EditText
    private lateinit var newChallengeDescription:EditText
    private lateinit var submit:Button
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
        val root:View= inflater.inflate(R.layout.fragment_new_challenge, container, false)
        newChallengeTitle=root.findViewById(R.id.new_challenge_title)
        newChallengeDescription=root.findViewById(R.id.new_challenge_description)
        submit=root.findViewById(R.id.submit_add)
        submit.setOnClickListener(){
            createChallenge(newChallengeTitle.text.toString(), newChallengeDescription.text.toString())
            newChallengeTitle.setText("")
            newChallengeDescription.setText("")
            Toast.makeText(activity?.applicationContext, "Challenge Created!", Toast.LENGTH_SHORT).show()
        }
        return root
    }

    private fun createChallenge(title:String, description:String) {
        val sharedPref = activity?.getSharedPreferences("User Info", Context.MODE_PRIVATE) ?:return
        val username = sharedPref.getString("username","")
        val playerID = sharedPref.getInt("playerID",0)
        val groupID=0
        CoroutineScope(Dispatchers.Main).launch {
            val json = "application/json; charset=utf-8".toMediaType()
            val body = "{\"title\":\"$title\",\"description\":\"$description\",\"username\":\"$username\",\"author_id\":\"$playerID\",\"group_id\":\"$groupID\"}".toRequestBody(json)
            val request = Request.Builder()
                    .url("https://challenge-with-friends.herokuapp.com/api/challenges/")
                    .post(body)
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
            NewChallengeFragment().apply {
                arguments = Bundle().apply {

                }
            }
    }
}