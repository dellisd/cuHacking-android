package com.cuhacking.app.profile.data

import android.graphics.Bitmap
import android.graphics.Color
import com.cuhacking.app.Database
import com.cuhacking.app.data.CoroutinesDispatcherProvider
import com.cuhacking.app.data.Result
import com.cuhacking.app.data.api.ApiService
import com.cuhacking.app.data.auth.UserRole
import com.cuhacking.app.data.db.User
import com.cuhacking.app.util.getBearerAuth
import com.google.firebase.auth.FirebaseAuth
import com.squareup.sqldelight.runtime.coroutines.asFlow
import com.squareup.sqldelight.runtime.coroutines.mapToOneNotNull
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.withContext
import net.glxn.qrgen.android.QRCode
import java.lang.Exception
import java.util.*
import javax.inject.Inject

class ProfileRepository @Inject constructor(
    private val apiService: ApiService,
    private val database: Database,
    private val dispatchers: CoroutinesDispatcherProvider
) {

    /**
     * Get a [Flow] for a user that can be collected as it is updated in the data source.
     */
    suspend fun getUser(userId: String): Flow<User> = withContext(dispatchers.io) {
        database.userQueries.getById(userId).asFlow().mapToOneNotNull()
    }

    /**
     * Gets a bitmap for a user with a specified width, height, and optionally a colour.
     * The QR code is mapped to a url to the user's profile page.
     */
    fun getUserQRCode(userId: String, size: Int, color: Int? = null): Bitmap {
        return QRCode.from("https://live.cuhacking.com/dashboard/user/$userId")
            .apply {
                if (color != null) withColor(color, Color.WHITE)
            }
            .withSize(size, size)
            .bitmap()
    }

    /**
     * Loads an actual user from the remote api service and updates or saves it to the caching database
     * @param isPrimary Whether or not this user is the *primary* user on the device, i.e. the user who is currently signed in to the app
     */
    suspend fun loadUser(userId: String, isPrimary: Boolean): Result<Unit> =
        withContext(dispatchers.io) {
            return@withContext try {
                val (user) = apiService.getUser(
                    userId,
                    FirebaseAuth.getInstance().currentUser?.getBearerAuth()!!
                )
                val (id, email, _, role, application) = user
                val roleValue = when (role) {
                    "user" -> UserRole.USER
                    "admin" -> UserRole.ADMIN
                    "sponsor" -> UserRole.SPONSOR
                    else -> UserRole.USER
                }
                database.userQueries.insert(
                    id,
                    "${application.basicInfo.firstName} ${application.basicInfo.lastName}",
                    email,
                    "red",
                    application.personalInfo.school,
                    isPrimary,
                    Date().time,
                    roleValue
                )
                Result.Success(Unit)
            } catch (e: Exception) {
                Result.Error<Unit>(e)
            }
        }
}