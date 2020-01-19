package com.cuhacking.app.di

import com.cuhacking.app.data.DATABASE_NAME
import com.cuhacking.app.data.db.CuHackingDatabase
import com.squareup.sqldelight.db.SqlDriver
import com.squareup.sqldelight.drivers.ios.NativeSqliteDriver
import io.ktor.client.HttpClient
import io.ktor.client.engine.ios.Ios
import org.kodein.di.Kodein
import org.kodein.di.erased.bind
import org.kodein.di.erased.singleton

internal actual val platformModule = Kodein.Module(name = "iOS") {
    bind<SqlDriver>() with singleton { NativeSqliteDriver(CuHackingDatabase.Schema, DATABASE_NAME) }

    bind<HttpClient>() with singleton { HttpClient(Ios) }
}