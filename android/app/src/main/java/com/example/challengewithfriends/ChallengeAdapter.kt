package com.example.challengewithfriends

import android.content.Context
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.FragmentManager
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import java.io.IOException

class ChallengeAdapter(private var myDataset: MutableList<Challenge>, var isCompleted:Boolean, var isCurrent:Boolean, fragmentManager: FragmentManager?):RecyclerView.Adapter<ChallengeAdapter.ViewHolder>() {
    val fragmentManager=fragmentManager
    private val client = OkHttpClient()
    class ViewHolder internal constructor(itemView: View): RecyclerView.ViewHolder(itemView){
        val title:TextView = itemView.findViewById(R.id.title)
        val description:TextView = itemView.findViewById(R.id.description)
        val author:TextView = itemView.findViewById(R.id.author)
        val imageView:ImageView? = itemView.findViewById(R.id.challenge_image)
        val pastEmpty:TextView?=itemView.findViewById(R.id.emptyPast)

    }
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(
            if(isCompleted) R.layout.challenge_with_image else R.layout.challenge_item,
            parent,
            false) as View
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.title.text=myDataset[position].title
        holder.description.text=myDataset[position].description
        holder.author.text=myDataset[position].author_username
        if (isCompleted){
            holder.imageView?.let { Glide.with(holder.itemView.context).load(myDataset[position].image?.url).into(it) }
        }
        holder.itemView.setOnClickListener(){
            if (isCurrent){
                // launch fragment, mark as completed, upload picture
                if (holder.pastEmpty!=null){
                    holder.pastEmpty.visibility=View.GONE
                }
                fragmentManager?.beginTransaction()
                        ?.add(R.id.upload_container,UploadFragment.newInstance(myDataset[position].id))
                        ?.commit()
                delItem(position)
            }else if (!isCompleted){
                // mark as claimed
                val sharedPref = holder.itemView.context?.getSharedPreferences("User Info", Context.MODE_PRIVATE)
                val playerID = sharedPref?.getInt("playerID",0)
                val challengeID=myDataset[position].id
                CoroutineScope(Dispatchers.Main).launch {
                    val json = "application/json; charset=utf-8".toMediaType()
                    val body = "{\"player_id\":\"$playerID\",\"challenge_id\":\"$challengeID\"}".toRequestBody(json)
                    val request = Request.Builder()
                            .url("https://challenge-with-friends.herokuapp.com/api/challenges/assign_challenge_player/")
                            .post(body)
                            .build()

                    withContext(Dispatchers.IO) {
                        client.newCall(request).execute().use { response ->
                            if (!response.isSuccessful) throw IOException("Unexpected code $response")
                        }
                    }
                }
                Toast.makeText(holder.itemView.context, "Challenge Claimed!", Toast.LENGTH_SHORT).show()
                delItem(position)
            }
        }
    }

    private fun delItem(pos:Int){
        myDataset.removeAt(pos)
        notifyDataSetChanged()
    }

    override fun getItemCount(): Int {
        return myDataset.size
    }
}