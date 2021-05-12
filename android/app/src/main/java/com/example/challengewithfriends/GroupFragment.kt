package com.example.challengewithfriends

import android.annotation.SuppressLint
import android.content.Context
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
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
    private lateinit var allEmpty:TextView
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
        val root:View= inflater.inflate(R.layout.fragment_group, container, false)

        allChallengeRecyclerView  = root.findViewById(R.id.all_challenges)
        allChallengeLayoutManager= LinearLayoutManager(root.context)
        allChallengeRecyclerView.layoutManager=allChallengeLayoutManager
        getChallengeList()
        allChallengeAdapter = ChallengeAdapter(allChallengeDataSet,false, false, fragmentManager)
        allChallengeRecyclerView.adapter=allChallengeAdapter

        searchSafeAllChallengeDataSet=allChallengeDataSet.toMutableList()
        immutableAllChallengeDataSet=allChallengeDataSet.toMutableList()

        radio=root.findViewById(R.id.radio)
        radio1=root.findViewById(R.id.radio_1)
        radio2=root.findViewById(R.id.radio_2)
        radio3=root.findViewById(R.id.radio_3)
        searchbar=root.findViewById(R.id.search_bar)
        searchButton=root.findViewById(R.id.search_button)
        clearRadioButton=root.findViewById(R.id.clear)
        clearSearchButton=root.findViewById(R.id.clear_search_button)
        radio1.visibility=View.GONE
        radio2.visibility=View.GONE
        radio3.visibility=View.GONE
        getPlayerGroups(root)

        allEmpty= root.findViewById(R.id.emptyAll)
        checkListEmpty()
        return root
    }

    private fun getPlayerGroups(root:View){
        val sharedPref = activity?.getSharedPreferences("User Info", Context.MODE_PRIVATE)
        val playerID = sharedPref?.getInt("playerID",0)
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
                        playerGroups=issue?.data?.groups
                        activity?.runOnUiThread(){
                            setFilterStuff()
                        }
                    }
                }
            }
        }
    }

    private fun checkListEmpty(){
        if (allChallengeDataSet.size==0){
            allEmpty.visibility=View.VISIBLE
        }else{
            allEmpty.visibility=View.GONE
        }
    }

    @SuppressLint("UseCompatLoadingForDrawables")
    private fun setFilterStuff() {
            clearRadioButton.setOnClickListener(){
            radio.clearCheck()
            restoreData(searchSafeAllChallengeDataSet,allChallengeDataSet)
            allChallengeAdapter.notifyDataSetChanged()
            radio1.background=resources.getDrawable(R.drawable.rounded_corner)
            radio2.background=resources.getDrawable(R.drawable.rounded_corner)
            radio3.background=resources.getDrawable(R.drawable.rounded_corner)
        }
        radio1.visibility=View.GONE
        radio2.visibility=View.GONE
        radio3.visibility=View.GONE
        if(playerGroups!!.isNotEmpty()){
            clearRadioButton.visibility=View.VISIBLE
            setRadioButton(radio1, playerGroups!![0].id, 0, radio2, radio3)
            if(playerGroups!!.size>=2){
                setRadioButton(radio2, playerGroups!![1].id,1, radio1, radio3)
                if(playerGroups!!.size>=3){
                    setRadioButton(radio3, playerGroups!![2].id,2, radio1, radio2)
                }
            }
        }else{
            clearRadioButton.visibility=View.GONE
        }
        setUpSearch(searchbar,searchButton,clearSearchButton,clearRadioButton)
    }

    private fun setUpSearch(searchBar:EditText, searchButton:Button, clearSearchButton:Button, clearRadioButton: Button){
        searchBar.setOnClickListener(){
            searchBar.setText("")
            clearRadioButton.performClick()
        }
        searchButton.setOnClickListener(){
            val search:String = searchBar.text.toString()
            allChallengeDataSet.retainAll{ challenge:Challenge ->
                challenge.title.contains(search) || challenge.description.contains(search) // || challenge.author_id.contains(search) || challenge.group_id.contains(search)
            }
            allChallengeAdapter.notifyDataSetChanged()
            searchSafeAllChallengeDataSet=allChallengeDataSet.toMutableList()
        }
        clearSearchButton.setOnClickListener(){
            searchBar.setText("Search")
            restoreData(immutableAllChallengeDataSet,allChallengeDataSet)
            restoreData(immutableAllChallengeDataSet, searchSafeAllChallengeDataSet)
            allChallengeAdapter.notifyDataSetChanged()
        }

    }

    @SuppressLint("UseCompatLoadingForDrawables")
    private fun setRadioButton(button:RadioButton, group:Int,index:Int, other1:RadioButton, other2:RadioButton){
        button.visibility=View.VISIBLE
        button.text=playerGroups!![index].name.trim()
        button.setOnClickListener(){
            restoreData(searchSafeAllChallengeDataSet,allChallengeDataSet)
            allChallengeDataSet.retainAll { challenge:Challenge ->
                challenge.group_id == group
            }
            allChallengeAdapter.notifyDataSetChanged()
            button.background=resources.getDrawable(R.drawable.rounded_corner_selected)
            other1.background=resources.getDrawable(R.drawable.rounded_corner)
            other2.background=resources.getDrawable(R.drawable.rounded_corner)
        }
    }

    private fun getChallengeList(){
        CoroutineScope(Dispatchers.Main).launch {
            val request = Request.Builder()
                    .url("https://challenge-with-friends.herokuapp.com/api/challenges/unclaimed")
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
                        allChallengeDataSet.add(Challenge(it.id, it.title, it.description, it.claimed, it.completed,it.author_username, it.author_id,it.group_id, null))//,it.player))
                    }
                }
            }
            allChallengeAdapter.notifyDataSetChanged()
            searchSafeAllChallengeDataSet=allChallengeDataSet.toMutableList()
            immutableAllChallengeDataSet=allChallengeDataSet.toMutableList()
            checkListEmpty()
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