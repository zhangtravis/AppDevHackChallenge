package com.example.challengewithfriends

import android.content.Context
import android.os.Bundle
import android.util.Log
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.squareup.moshi.Moshi
import com.squareup.moshi.kotlin.reflect.KotlinJsonAdapterFactory
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.Request
import java.io.IOException


class HomeFragment : Fragment() {
    private lateinit var currentChallengeRecyclerView : RecyclerView
    private lateinit var currentChallengeAdapter : RecyclerView.Adapter<*>
    private lateinit var currentChallengeLayoutManager : RecyclerView.LayoutManager
    private var currChallengeDataSet= mutableListOf<Challenge>()
    private lateinit var pastChallengeRecyclerView : RecyclerView
    private lateinit var pastChallengeAdapter : RecyclerView.Adapter<*>
    private lateinit var pastChallengeLayoutManager : RecyclerView.LayoutManager
    private var pastChallengeDataSet = mutableListOf<Challenge>()
    private val client = OkHttpClient()
    private lateinit var currEmpty:TextView
    private lateinit var pastEmpty:TextView
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
        val root:View = inflater.inflate(R.layout.fragment_home, container, false)

        currentChallengeRecyclerView  = root.findViewById(R.id.curr_challenges)
        currentChallengeLayoutManager= LinearLayoutManager(root.context, LinearLayoutManager.HORIZONTAL, false)
        currentChallengeRecyclerView.layoutManager=currentChallengeLayoutManager
        getcurrentChallengeList()
        currentChallengeAdapter = ChallengeAdapter(currChallengeDataSet,false, true,fragmentManager)
        currentChallengeRecyclerView.adapter=currentChallengeAdapter

        pastChallengeRecyclerView=root.findViewById(R.id.past_challenges)
        pastChallengeLayoutManager = LinearLayoutManager(root.context)
        pastChallengeRecyclerView.layoutManager=pastChallengeLayoutManager
        getPastChallenges()
        pastChallengeAdapter=ChallengeAdapter(pastChallengeDataSet,true, false,fragmentManager)
        pastChallengeRecyclerView.adapter=pastChallengeAdapter

        currentChallengeAdapter.notifyDataSetChanged()
        pastChallengeAdapter.notifyDataSetChanged()

        currEmpty=root.findViewById(R.id.emptyCurr)
        checkCurrListEmpty()
        pastEmpty=root.findViewById(R.id.emptyPast)
        checkPastListEmpty()
        return root
    }

    private fun checkCurrListEmpty(){
        if (currChallengeDataSet.size==0){
            currEmpty.visibility=View.VISIBLE
        }else{
            currEmpty.visibility=View.GONE
        }
    }
    private fun checkPastListEmpty(){
        if (pastChallengeDataSet.size==0){
            pastEmpty.visibility=View.VISIBLE
        }else{
            pastEmpty.visibility=View.GONE
        }
    }

    private fun getcurrentChallengeList(){
        val sharedPref = activity?.getSharedPreferences("User Info", Context.MODE_PRIVATE)
        val playerID = sharedPref?.getInt("playerID",0)
        Log.d("tag1", ""+playerID)
        if (playerID==0) return
        CoroutineScope(Dispatchers.Main).launch {
            val request = Request.Builder()
                    .url("https://challenge-with-friends.herokuapp.com/api/players/$playerID/challenges/")
                    .build()

            withContext(Dispatchers.IO) {
                client.newCall(request).execute().use { response ->
                    if (!response.isSuccessful) throw IOException("Unexpected code $response")

                    val moshi = Moshi.Builder()
                            .addLast(KotlinJsonAdapterFactory())
                            .build()
                    val issueAdapter = moshi.adapter(AllChallengeResponse::class.java)
                    val issue = issueAdapter.fromJson(response.body?.string())
                    issue?.data?.forEach {
                        currChallengeDataSet.add(Challenge(it.id, it.title, it.description, it.claimed, it.completed,it.author_username,it.author_id,it.group_id, null))//,it.player))
                    }
                }
            }
            currentChallengeAdapter.notifyDataSetChanged()
            checkCurrListEmpty()
        }
    }

    private fun getPastChallenges(){
        val sharedPref = activity?.getSharedPreferences("User Info", Context.MODE_PRIVATE)
        val playerID = sharedPref?.getInt("playerID",0)
        CoroutineScope(Dispatchers.Main).launch {
            val request = Request.Builder()
                    .url("https://challenge-with-friends.herokuapp.com/api/challenges/completed/")
                    .build()

            withContext(Dispatchers.IO) {
                client.newCall(request).execute().use { response ->
                    if (!response.isSuccessful) throw IOException("Unexpected code $response")

                    val moshi = Moshi.Builder()
                            .addLast(KotlinJsonAdapterFactory())
                            .build()
                    val issueAdapter = moshi.adapter(AllChallengeResponse::class.java)
                    val issue = issueAdapter.fromJson(response.body?.string())
                    issue?.data?.forEach {
                        pastChallengeDataSet.add(Challenge(it.id, it.title, it.description, it.claimed, it.completed,it.author_username,it.author_id,it.group_id, it.image))//,it.player))
                    }
                }
            }
            pastChallengeAdapter.notifyDataSetChanged()
            checkPastListEmpty()
        }
    }

    companion object {
        @JvmStatic
        fun newInstance() =
            HomeFragment().apply {
                arguments = Bundle().apply {

                }
            }
    }
}