package com.example.challengewithfriends

import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class LeaderboardResponse(
    val success:Boolean,
    val data: Array<Array<String>>
)

