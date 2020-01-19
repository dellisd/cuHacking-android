package com.cuhacking.app.data

import com.cuhacking.app.data.models.UpdatesResponse
import io.ktor.client.HttpClient

interface CuHackingApi {
    suspend fun getUpdates(): UpdatesResponse
}

class ApiService(private val client: HttpClient) : CuHackingApi {

    override suspend fun getUpdates(): UpdatesResponse {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }
}