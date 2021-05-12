package com.example.challengewithfriends

import android.content.Context
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.LinearLayout
import com.google.android.material.bottomnavigation.BottomNavigationView

class MainActivity : AppCompatActivity() {
    private lateinit var bottomNavigationView: BottomNavigationView
    private lateinit var fragmentContainer:LinearLayout
    private val fragmentManager=supportFragmentManager
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val sharedPref = this.getSharedPreferences("User Info", Context.MODE_PRIVATE)
        var playerID = sharedPref.getInt("playerID",0)

        
        fragmentContainer=findViewById(R.id.fragment_container)
        fragmentManager.beginTransaction()
            .add(R.id.fragment_container, /*if (playerID==0)*/ MakeAccountFragment()) /*else HomeFragment())*/
            .commit()
        setBottomNav()
    }
    private fun setBottomNav(){
        bottomNavigationView=findViewById(R.id.bottom_nav_bar)
        bottomNavigationView.setOnNavigationItemSelectedListener {
            when (it.itemId) {
                R.id.home_item -> {
                    fragmentManager.beginTransaction()
                        .replace(R.id.fragment_container,HomeFragment())
                        .commit()
                }
                R.id.groups_item -> {
                    fragmentManager.beginTransaction()
                        .replace(R.id.fragment_container,GroupFragment())
                        .commit()
                }
                R.id.new_challenge_item -> {
                    fragmentManager.beginTransaction()
                        .replace(R.id.fragment_container,NewChallengeFragment())
                        .commit()
                }
                R.id.leaderboard_item -> {
                    fragmentManager.beginTransaction()
                        .replace(R.id.fragment_container,LeaderboardFragment())
                        .commit()
                }
                R.id.profile_item -> {
                    fragmentManager.beginTransaction()
                        .replace(R.id.fragment_container,ProfileFragment())
                        .commit()
                }
            }
            true
        }
    }
}