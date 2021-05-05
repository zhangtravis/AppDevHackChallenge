package com.example.challengewithfriends

data class Challenge(
    val id:String,
    var title:String,
    val description:String,
    val claimed:Boolean,
    val completed:Boolean,
//    val author_id:String,
//    val group_id:Int,
    val player:Array<Player>
    )
