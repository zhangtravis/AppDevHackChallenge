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
        getChallengeList()
        currentChallengeAdapter = ChallengeAdapter(currChallengeDataSet,false, true)
        currentChallengeRecyclerView.adapter=currentChallengeAdapter

        pastChallengeRecyclerView=root.findViewById(R.id.past_challenges)
        pastChallengeLayoutManager = LinearLayoutManager(root.context)
        pastChallengeRecyclerView.layoutManager=pastChallengeLayoutManager

        pastChallengeAdapter=ChallengeAdapter(pastChallengeDataSet,true, false)
        pastChallengeRecyclerView.adapter=pastChallengeAdapter
        return root
    }

    private fun getChallengeList(){
        CoroutineScope(Dispatchers.Main).launch {
            val request = Request.Builder()
                    .url("https://challenge-with-friends.herokuapp.com/api/challenges/")
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
                        if(it.claimed && !it.completed) {
                            currChallengeDataSet.add(Challenge(it.id, it.title, it.description, it.claimed, it.completed,/*it.author_id,it.group_id,*/it.player))
                        }else if (it.claimed && it.completed){
                            pastChallengeDataSet.add(Challenge(it.id, it.title, it.description, it.claimed, it.completed,/*it.author_id,it.group_id,*/it.player))
                        }
                    }
                }
            }
            currentChallengeAdapter.notifyDataSetChanged()
            pastChallengeAdapter.notifyDataSetChanged()
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