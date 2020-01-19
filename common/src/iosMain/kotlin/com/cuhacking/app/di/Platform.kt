package com.cuhacking.app.di

import com.cuhacking.app.data.DATABASE_NAME
import com.cuhacking.app.data.db.CuHackingDatabase
import com.squareup.sqldelight.db.SqlDriver
import com.squareup.sqldelight.drivers.ios.NativeSqliteDriver
import org.kodein.di.Kodein
import org.kodein.di.erased.bind
import org.kodein.di.erased.singleton

internal actual val platformModule = Kodein.Module(name = "iOS") {
    bind<SqlDriver>() with singleton { NativeSqliteDriver(CuHackingDatabase.Schema, DATABASE_NAME) }
}