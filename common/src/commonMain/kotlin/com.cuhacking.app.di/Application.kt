package com.cuhacking.app.di

import com.cuhacking.app.data.ApiService
import com.cuhacking.app.data.createDatabase
import com.cuhacking.app.data.db.CuHackingDatabase
import org.kodein.di.Kodein
import org.kodein.di.erased.bind
import org.kodein.di.erased.instance
import org.kodein.di.erased.singleton

val kodein = Kodein {
    import(platformModule)
    bind<CuHackingDatabase>() with singleton { createDatabase(instance()) }
    bind<ApiService>() with singleton { ApiService(instance()) }
}