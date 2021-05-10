package com.example.challengewithfriends

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView

class LeaderboardAdapter(private var myDataset:MutableList<Leaderboard>): RecyclerView.Adapter<LeaderboardAdapter.ViewHolder>() {
    class ViewHolder internal constructor(itemView: View): RecyclerView.ViewHolder(itemView){

    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.leaderboard_item, parent, false) as View
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {

    }

    override fun getItemCount(): Int {
        return myDataset.size
    }
}