package com.furkanages.quicko_app

import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import com.google.android.gms.games.PlayGames

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Attempt silent sign-in to Google Play Games on app start.
        val gamesSignInClient = PlayGames.getGamesSignInClient(this)
        gamesSignInClient.isAuthenticated()
            .addOnCompleteListener { task ->
                val isAuthenticated = task.isSuccessful && task.result.isAuthenticated
                Log.d("PGS", "isAuthenticated check success=${task.isSuccessful}, authenticated=$isAuthenticated")
                if (!isAuthenticated) {
                    gamesSignInClient.signIn().addOnCompleteListener { signInTask ->
                        Log.d("PGS", "signIn completed success=${signInTask.isSuccessful}")
                    }
                }
            }
    }
}
