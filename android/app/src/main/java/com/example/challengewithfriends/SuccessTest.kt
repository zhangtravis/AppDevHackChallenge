package com.example.challengewithfriends

import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class SuccessTest(
    val success:Boolean
)
