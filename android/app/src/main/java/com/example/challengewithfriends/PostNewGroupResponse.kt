package com.example.challengewithfriends

import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class PostNewGroupResponse(
    val success:Boolean,
    val data:Group
)
