package com.example.challengewithfriends

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView


class LeaderboardFragment : Fragment() {
    private lateinit var leaderborardRecyclerView : RecyclerView
    private lateinit var leaderborardAdapter : RecyclerView.Adapter<*>
    private lateinit var leaderboardLayoutManager : RecyclerView.LayoutManager
    private var leaderboardDataSet= mutableListOf<Leaderboard>()
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
        // get data set
        leaderborardAdapter=LeaderboardAdapter(leaderboardDataSet)
        leaderborardRecyclerView.adapter=leaderborardAdapter
        return root
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