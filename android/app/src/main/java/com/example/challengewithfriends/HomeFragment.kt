package com.example.challengewithfriends

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView


class HomeFragment : Fragment() {
    private lateinit var currentChallengeRecyclerView : RecyclerView
    private lateinit var currentChallengeAdapter : RecyclerView.Adapter<*>
    private lateinit var currentChallengeLayoutManager : RecyclerView.LayoutManager
    private lateinit var pastChallengeRecyclerView : RecyclerView
    private lateinit var pastChallengeAdapter : RecyclerView.Adapter<*>
    private lateinit var pastChallengeLayoutManager : RecyclerView.LayoutManager
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
        var currChallengeDataSet= mutableListOf<Challenge>()
        currentChallengeAdapter = ChallengeAdapter(currChallengeDataSet,false)
        currentChallengeRecyclerView.adapter=currentChallengeAdapter

        pastChallengeRecyclerView=root.findViewById(R.id.past_challenges)
        pastChallengeLayoutManager = LinearLayoutManager(root.context)
        pastChallengeRecyclerView.layoutManager=pastChallengeLayoutManager
        var pastChallengeDataSet = mutableListOf<Challenge>()
        pastChallengeAdapter=ChallengeAdapter(pastChallengeDataSet,true)
        pastChallengeRecyclerView.adapter=pastChallengeAdapter
        return root
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