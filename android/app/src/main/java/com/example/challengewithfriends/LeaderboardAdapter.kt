package com.example.challengewithfriends

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import kotlin.math.min

class LeaderboardAdapter(private var myDataset:MutableList<Leaderboard>): RecyclerView.Adapter<LeaderboardAdapter.ViewHolder>() {
    class ViewHolder internal constructor(itemView: View): RecyclerView.ViewHolder(itemView){
        val title:TextView=itemView.findViewById(R.id.leaderboard_title)
        val player1:TextView = itemView.findViewById(R.id.leaderboard_player1)
        val player2:TextView = itemView.findViewById(R.id.leaderboard_player2)
        val player3:TextView = itemView.findViewById(R.id.leaderboard_player3)
        val player4:TextView = itemView.findViewById(R.id.leaderboard_player4)
        val player5:TextView = itemView.findViewById(R.id.leaderboard_player5)
        val playerthis:TextView = itemView.findViewById(R.id.leaderboard_player_this)
        val points1:TextView=itemView.findViewById(R.id.leaderboard_points1)
        val points2:TextView=itemView.findViewById(R.id.leaderboard_points2)
        val points3:TextView=itemView.findViewById(R.id.leaderboard_points3)
        val points4:TextView=itemView.findViewById(R.id.leaderboard_points4)
        val points5:TextView=itemView.findViewById(R.id.leaderboard_points5)
        val pointsthis:TextView=itemView.findViewById(R.id.leaderboard_points_this)
        val playerArr:Array<TextView> = arrayOf(player1, player2, player3, player4, player5)
        val pointsArr:Array<TextView> = arrayOf(points1, points2, points3, points4, points5)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.leaderboard_item, parent, false) as View
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.title.text=myDataset[position].title
        for (i:Int in 0..min(holder.playerArr.size-1, myDataset[position].items?.size!! -1)){
            holder.playerArr[i].text=myDataset[position].items?.get(i)?.get(0)
            holder.pointsArr[i].text=myDataset[position].items?.get(i)?.get(1)
        }
        val sharedPref = holder.itemView.context?.getSharedPreferences("User Info", Context.MODE_PRIVATE)
        val username = sharedPref?.getString("username",null)
        var userPos=0
        if (username!=null){
            for (i:Int in myDataset[position].items?.indices!!){
                if (myDataset[position].items?.get(i)?.get(0)==username){
                    userPos=i
                    break
                }
            }
        }
        holder.playerthis.text=myDataset[position].items?.get(userPos)?.get(0)
        holder.pointsthis.text=myDataset[position].items?.get(userPos)?.get(1)
    }

    override fun getItemCount(): Int {
        return myDataset.size
    }
}