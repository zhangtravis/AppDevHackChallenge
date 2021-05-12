package com.example.challengewithfriends

import android.content.Context
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
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


class LeaderboardFragment : Fragment() {
    private lateinit var leaderborardRecyclerView : RecyclerView
    private lateinit var leaderborardAdapter : RecyclerView.Adapter<*>
    private lateinit var leaderboardLayoutManager : RecyclerView.LayoutManager
    private var leaderboardDataSet= mutableListOf<Leaderboard>()
    private val client = OkHttpClient()
    private var playerID:Int? = null
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
        val root:View =  inflater.inflate(R.layout.fragment_leaderboard, container, false)
        val sharedPref = activity?.getSharedPreferences("User Info", Context.MODE_PRIVATE)
        playerID=sharedPref?.getInt("playerID",0)
        getGroups()
        leaderborardRecyclerView=root.findViewById(R.id.leaderboard_recycler)
        leaderboardLayoutManager= LinearLayoutManager(root.context)
        leaderborardRecyclerView.layoutManager=leaderboardLayoutManager
        getLeaderboard("Global")
        leaderborardAdapter=LeaderboardAdapter(leaderboardDataSet)
        leaderborardRecyclerView.adapter=leaderborardAdapter
        return root
    }

    private fun getGroups(){
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
                        playerGroups = issue?.data?.groups
                        for (i:Int in playerGroups!!.indices){
                            getLeaderboard(playerGroups!![i].name, i)
                        }
                    }
                }
            }
        }
    }

    private fun getLeaderboard(groupTitle:String, number:Int=-1){
        var urlString="https://challenge-with-friends.herokuapp.com/api/leaderboard/"
        if (groupTitle=="Global") {
            urlString+= ""
        }else{
            urlString+="${playerGroups!![number].id}/"
        }
        CoroutineScope(Dispatchers.Main).launch {
            val request = Request.Builder()
                .url(urlString)
                .build()

            withContext(Dispatchers.IO) {
                client.newCall(request).execute().use { response ->
                    if (!response.isSuccessful) throw IOException("Unexpected code $response")

                    val moshi = Moshi.Builder()
                        .addLast(KotlinJsonAdapterFactory())
                        .build()
                    val issueAdapter = moshi.adapter(LeaderboardResponse::class.java)
                    val issue = issueAdapter.fromJson(response.body?.string())
                    leaderboardDataSet.add(Leaderboard(groupTitle,issue?.data))
                }
            }
            leaderborardAdapter.notifyDataSetChanged()
        }
    }

    companion object {
        @JvmStatic
        fun newInstance() =
            LeaderboardFragment().apply {
                arguments = Bundle().apply {
                }
            }
    }
}