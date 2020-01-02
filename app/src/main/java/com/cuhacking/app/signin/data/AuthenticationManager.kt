package com.cuhacking.app.signin.data

import com.cuhacking.app.Database
import com.cuhacking.app.data.CoroutinesDispatcherProvider
import com.cuhacking.app.data.Result
import com.cuhacking.app.data.api.ApiService
import com.cuhacking.app.data.auth.UserRole
import com.cuhacking.app.data.db.User
import com.cuhacking.app.util.getBearerAuth
import com.google.android.gms.tasks.Tasks
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import kotlinx.coroutines.withContext
import java.lang.Exception
import java.util.*
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class AuthenticationManager @Inject constructor(
    private val auth: FirebaseAuth,
    private val database: Database,
    private val api: ApiService,
    private val dispatchers: CoroutinesDispatcherProvider
) {
    suspend fun authenticateUser(email: String, password: String): Result<User> =
        withContext(dispatchers.io) {
            // Allow only a single user to be signed in at a time
            if (auth.currentUser != null) {
                signOut(auth.currentUser!!)
            }

            return@withContext try {
                val result = Tasks.await(auth.signInWithEmailAndPassword(email, password))
                val user = result.user!!

                val (apiUser) = api.getUser(user.uid, user.getBearerAuth()!!)
                val (_, name, userEmail, color, school, role) = apiUser
                val roleValue = when (role) {
                    "user" -> UserRole.USER
                    "admin" -> UserRole.ADMIN
                    "sponsor" -> UserRole.SPONSOR
                    else -> UserRole.USER
                }

                database.userQueries.insert(
                    user.uid,
                    name,
                    userEmail,
                    color,
                    school,
                    true,
                    Date().time,
                    roleValue
                )

                Result.Success(database.userQueries.getById(user.uid).executeAsOne())
            } catch (e: Exception) {
                Result.Error<User>(e)
            }
        }

    suspend fun signOut(user: FirebaseUser) = withContext(dispatchers.io) {
        database.userQueries.delete(user.uid)
        auth.signOut()
    }
}