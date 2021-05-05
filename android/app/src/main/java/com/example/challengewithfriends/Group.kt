package com.example.challengewithfriends

data class Group(
    val id:Int,
    val name:String,
    val players:Array<Player>,
    val challenges:Array<Challenge>
)
