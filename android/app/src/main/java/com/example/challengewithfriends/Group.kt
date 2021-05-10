package com.example.challengewithfriends

import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class Group(
    val id:Int,
    val name:String,
    val players:Array<Player>,
    val challenges:Array<Challenge>
)
