package com.example.challengewithfriends

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView

class ChallengeAdapter(private var myDataset: MutableList<Challenge>, var isCompleted:Boolean):RecyclerView.Adapter<ChallengeAdapter.ViewHolder>() {
    class ViewHolder internal constructor(itemView: View): RecyclerView.ViewHolder(itemView){
        val title:TextView = itemView.findViewById(R.id.title)
        val description:TextView = itemView.findViewById(R.id.description)
        val author:TextView = itemView.findViewById(R.id.author)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.challenge_item,parent,false) as View
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.title.text=myDataset[position].title
        holder.description.text=myDataset[position].description
//        holder.author.text=myDataset[position].author_id
        holder.itemView.setOnClickListener(){

        }
    }

    override fun getItemCount(): Int {
        return myDataset.size
    }
}