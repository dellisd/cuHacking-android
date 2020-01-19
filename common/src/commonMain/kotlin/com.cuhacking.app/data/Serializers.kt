package com.cuhacking.app.data

import com.soywiz.klock.DateTimeTz
import com.soywiz.klock.ISO8601
import com.soywiz.klock.parse
import kotlinx.serialization.*
import kotlinx.serialization.internal.StringDescriptor

@Serializer(forClass = DateTimeTz::class)
object DateTimeTzSerializer : KSerializer<DateTimeTz> {
    override val descriptor: SerialDescriptor = StringDescriptor.withName("DateTimeTz")

    override fun deserialize(decoder: Decoder): DateTimeTz =
        ISO8601.DATETIME_COMPLETE.parse(decoder.decodeString())

    override fun serialize(encoder: Encoder, obj: DateTimeTz) {
        encoder.encodeString(ISO8601.DATETIME_COMPLETE.format(obj))
    }
}