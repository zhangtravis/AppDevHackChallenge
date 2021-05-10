package com.example.challengewithfriends

import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class Player(
    val id:Int,
    val username:String,
    val points:Int,
    val current_challenges:Array<Challenge>,
    val completed_challenges:Array<Challenge>,
    val groups:Array<Group>,
    val authored_challenges:Array<Challenge>
)
