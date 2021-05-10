package com.example.challengewithfriends

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.FragmentManager
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide

class ChallengeAdapter(private var myDataset: MutableList<Challenge>, var isCompleted:Boolean, var isCurrent:Boolean, fragmentManager: FragmentManager?):RecyclerView.Adapter<ChallengeAdapter.ViewHolder>() {
    val fragmentManager=fragmentManager
    class ViewHolder internal constructor(itemView: View): RecyclerView.ViewHolder(itemView){
        val title:TextView = itemView.findViewById(R.id.title)
        val description:TextView = itemView.findViewById(R.id.description)
        val author:TextView = itemView.findViewById(R.id.author)
        val imageView:ImageView? = itemView.findViewById(R.id.challenge_image)
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
//        holder.author.text=myDataset[position].author_id
        if (isCompleted){
//            Glide.with(holder.itemView.context).load(myDataset[position].url).into(holder.imageView)
        }
        holder.itemView.setOnClickListener(){
            if (isCurrent){
                // launch fragment, mark as completed, upload picture
                if (fragmentManager != null) {
                    fragmentManager.beginTransaction()
                        .add(R.id.upload_container,UploadFragment())
                        .commit()
                }

            }else if (!isCompleted){
                // mark as claimed
            }
        }
    }

    override fun getItemCount(): Int {
        return myDataset.size
    }
}