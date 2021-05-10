package com.example.challengewithfriends

import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class PostNewPlayerResponse(
    val success:Boolean,
    val data:Player
)
