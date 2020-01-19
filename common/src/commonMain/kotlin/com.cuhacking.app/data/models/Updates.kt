@file:UseSerializers(DateTimeTzSerializer::class)

package com.cuhacking.app.data.models

import kotlinx.serialization.UseSerializers
import com.cuhacking.app.data.DateTimeTzSerializer
import com.soywiz.klock.DateTimeTz
import kotlinx.serialization.Serializable

@Serializable
data class UpdatesResponse(
    val version: DateTimeTz,
    val updates: Map<String, Update>
)

@Serializable
data class Update(
    val name: String,
    val description: String,
    val location: String,
    val deliveryTime: DateTimeTz
)
