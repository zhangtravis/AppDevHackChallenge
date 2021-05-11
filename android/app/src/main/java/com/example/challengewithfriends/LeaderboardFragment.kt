package com.example.challengewithfriends

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
        leaderborardRecyclerView=root.findViewById(R.id.leaderboard_recycler)
        leaderboardLayoutManager= LinearLayoutManager(root.context)
        leaderborardRecyclerView.layoutManager=leaderboardLayoutManager
        getLeaderboard("Global")
        leaderborardAdapter=LeaderboardAdapter(leaderboardDataSet)
        leaderborardRecyclerView.adapter=leaderborardAdapter
        return root
    }

    private fun getLeaderboard(groupTitle:String){
        var urlString="https://challenge-with-friends.herokuapp.com/api/leaderboard/"
        if (groupTitle=="Global") {
            urlString+= ""
        }else{
            CoroutineScope(Dispatchers.Main).launch {
                val request = Request.Builder()
                    .url("https://challenge-with-friends.herokuapp.com/api/groups/$groupTitle/")
                    .build()

                withContext(Dispatchers.IO) {
                    client.newCall(request).execute().use { response ->
                        if (!response.isSuccessful) return@use

                        val moshi = Moshi.Builder()
                            .addLast(KotlinJsonAdapterFactory())
                            .build()
                        val issueAdapter = moshi.adapter(PostNewGroupResponse::class.java)
                        val issue = issueAdapter.fromJson(response.body?.string())
                        urlString+="${issue?.data?.id}/"
                    }
                }
            }
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