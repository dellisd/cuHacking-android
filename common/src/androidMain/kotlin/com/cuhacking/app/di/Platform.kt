package com.cuhacking.app.di

import com.cuhacking.app.data.DATABASE_NAME
import com.cuhacking.app.data.db.CuHackingDatabase
import com.squareup.sqldelight.android.AndroidSqliteDriver
import com.squareup.sqldelight.db.SqlDriver
import org.kodein.di.Kodein
import org.kodein.di.erased.bind
import org.kodein.di.erased.instance
import org.kodein.di.erased.singleton

internal actual val platformModule = Kodein.Module(name = "Android") {
    bind<SqlDriver>() with singleton {
        AndroidSqliteDriver(
            CuHackingDatabase.Schema,
            instance(),
            DATABASE_NAME
        )
    }
}