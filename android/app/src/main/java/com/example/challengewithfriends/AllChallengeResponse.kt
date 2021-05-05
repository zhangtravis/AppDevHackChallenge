package com.example.challengewithfriends

import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class AllChallengeResponse(
    val success:Boolean,
    val data:Array<Challenge>
)
