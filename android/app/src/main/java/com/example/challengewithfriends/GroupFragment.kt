package com.example.challengewithfriends

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import android.widget.RadioButton
import android.widget.RadioGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView


class GroupFragment : Fragment() {
    private lateinit var allChallengeRecyclerView : RecyclerView
    private lateinit var allChallengeAdapter : RecyclerView.Adapter<*>
    private lateinit var allChallengeLayoutManager : RecyclerView.LayoutManager
    private var allChallengeDataSet= mutableListOf<Challenge>()
    private var searchSafeAllChallengeDataSet= mutableListOf<Challenge>()
    private var immutableAllChallengeDataSet= mutableListOf<Challenge>()
    private lateinit var radio1:RadioButton
    private lateinit var radio2:RadioButton
    private lateinit var radio3:RadioButton
    private lateinit var radio:RadioGroup
    private lateinit var searchbar:EditText
    private lateinit var searchButton: Button
    private lateinit var clearButton: Button
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
        val root:View= inflater.inflate(R.layout.fragment_group, container, false)

        allChallengeRecyclerView  = root.findViewById(R.id.all_challenges)
        allChallengeLayoutManager= LinearLayoutManager(root.context)
        allChallengeRecyclerView.layoutManager=allChallengeLayoutManager
        allChallengeDataSet.add(Challenge("Challenge seven"))
        allChallengeDataSet.add(Challenge("Challenge eight"))
        allChallengeDataSet.add(Challenge("Challenge nine"))
        allChallengeDataSet.add(Challenge("Challenge ten"))
        allChallengeAdapter = ChallengeAdapter(allChallengeDataSet)
        allChallengeRecyclerView.adapter=allChallengeAdapter

        searchSafeAllChallengeDataSet=allChallengeDataSet.toMutableList()
        immutableAllChallengeDataSet=allChallengeDataSet.toMutableList()



        return root
    }

    private fun setFilterStuff(root:View){
        radio=root.findViewById(R.id.radio)
        radio1=root.findViewById(R.id.radio_1)
        radio2=root.findViewById(R.id.radio_2)
        radio3=root.findViewById(R.id.radio_3)
        searchbar=root.findViewById(R.id.search_bar)
        searchButton=root.findViewById(R.id.search_button)
        clearButton=root.findViewById(R.id.clear)


    }

    private fun restoreData(safeList: MutableList<Challenge>, listToRestore: MutableList<Challenge>){
        listToRestore.clear()
        for (s in safeList){
            listToRestore.add(s)
        }
    }

    companion object {
        @JvmStatic
        fun newInstance() =
            GroupFragment().apply {
                arguments = Bundle().apply {

                }
            }
    }
}