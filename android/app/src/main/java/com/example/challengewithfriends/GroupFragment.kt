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
import com.squareup.moshi.Moshi
import com.squareup.moshi.kotlin.reflect.KotlinJsonAdapterFactory
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.Request
import java.io.IOException


class GroupFragment : Fragment() {
    private lateinit var allChallengeRecyclerView : RecyclerView
    private lateinit var allChallengeAdapter : RecyclerView.Adapter<*>
    private lateinit var allChallengeLayoutManager : RecyclerView.LayoutManager
    private var allChallengeDataSet= mutableListOf<Challenge>()
    private var searchSafeAllChallengeDataSet= mutableListOf<Challenge>()
    private var immutableAllChallengeDataSet= mutableListOf<Challenge>()
    private val client = OkHttpClient()
    private lateinit var radio1:RadioButton
    private lateinit var radio2:RadioButton
    private lateinit var radio3:RadioButton
    private lateinit var radio:RadioGroup
    private lateinit var searchbar:EditText
    private lateinit var searchButton: Button
    private lateinit var clearRadioButton: Button
    private lateinit var clearSearchButton:Button
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
        getChallengeList()
        allChallengeAdapter = ChallengeAdapter(allChallengeDataSet,false)
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
        clearRadioButton=root.findViewById(R.id.clear)
        clearSearchButton=root.findViewById(R.id.clear_search_button)

        clearRadioButton.setOnClickListener(){
            radio.clearCheck()
            restoreData(searchSafeAllChallengeDataSet,allChallengeDataSet)
            allChallengeAdapter.notifyDataSetChanged()
        }

    }

    private fun setRadioButton(button:RadioButton, group:String){
        if(group==null){
            button.visibility=View.INVISIBLE
            return
        }
        button.text=group
        button.setOnClickListener(){
            restoreData(searchSafeAllChallengeDataSet,allChallengeDataSet)
            allChallengeDataSet.retainAll { challenge:Challenge ->
//                challenge.group == group
            true
            }
        }
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
                        allChallengeDataSet.add(Challenge(it.id,it.title,it.description,it.claimed,it.completed,/*it.author_id,it.group_id,*/it.player))
                    }
                }
            }
            allChallengeAdapter.notifyDataSetChanged()
            searchSafeAllChallengeDataSet=allChallengeDataSet.toMutableList()
            immutableAllChallengeDataSet=allChallengeDataSet.toMutableList()
        }
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