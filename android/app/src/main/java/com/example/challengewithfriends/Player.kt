package com.example.challengewithfriends

data class Player(
    val id:Int,
    val name:String,
    val username:String,
    val password:String,
    val points:Int,
    val challenges:Array<Challenge>,
    val groups:Array<Group>,
    val authored_challenges:Array<Challenge>
)
