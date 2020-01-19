package com.cuhacking.app.data

import com.cuhacking.app.data.db.Announcement
import com.cuhacking.app.data.db.CuHackingDatabase
import com.soywiz.klock.*
import com.squareup.sqldelight.ColumnAdapter
import com.squareup.sqldelight.db.SqlDriver

const val DATABASE_NAME = "cuHacking.db"

fun createDatabase(driver: SqlDriver): CuHackingDatabase {
    return CuHackingDatabase(
        driver,
        Announcement.Adapter(deliveryTimeAdapter = DateTimeAdapter)
    )
}

private object DateTimeAdapter : ColumnAdapter<DateTimeTz, String> {
    override fun decode(databaseValue: String): DateTimeTz =
        ISO8601.DATETIME_COMPLETE.parse(databaseValue)

    override fun encode(value: DateTimeTz): String = ISO8601.DATETIME_COMPLETE.format(value)
}