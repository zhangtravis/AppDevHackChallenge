package com.example.challengewithfriends

data class Challenge(
    val id:Int,
    var title:String,
    val description:String,
    val claimed:Boolean,
    val completed:Boolean,
    val author_username:String,
    val author_id:String,
    val group_id:Int
//    val player:Array<Player>
    )
