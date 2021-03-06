/*
 *    Copyright 2019 cuHacking
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

package com.cuhacking.app.di

import android.content.Context
import com.cuhacking.app.CuHackingApplication
import com.cuhacking.app.admin.ui.AdminViewModel
import com.cuhacking.app.home.ui.HomeViewModel
import com.cuhacking.app.info.ui.InfoViewModel
import com.cuhacking.app.map.ui.MapViewModel
import com.cuhacking.app.profile.ui.ProfileViewModel
import com.cuhacking.app.schedule.ui.EventDetailViewModel
import com.cuhacking.app.schedule.ui.ScheduleViewModel
import com.cuhacking.app.signin.ui.SignInViewModel
import com.cuhacking.app.ui.MainViewModel
import dagger.BindsInstance
import dagger.Component
import javax.inject.Singleton

@Singleton
@Component(modules = [SharedPreferencesModule::class, DataModule::class, AppModule::class])
interface CoreComponent {

    @Component.Builder
    interface Builder {
        @BindsInstance
        fun applicationContext(applicationContext: Context): Builder

        fun sharedPreferenceModule(sharedPreferencesModule: SharedPreferencesModule): Builder

        fun build(): CoreComponent
    }

    fun mapViewModelFactory(): ViewModelFactory<MapViewModel>
    fun profileViewModelFactory(): ViewModelFactory<ProfileViewModel>
    fun signInViewModelFactory(): ViewModelFactory<SignInViewModel>
    fun infoViewModelFactory(): ViewModelFactory<InfoViewModel>
    fun scheduleViewModelFactory(): ViewModelFactory<ScheduleViewModel>
    fun eventDetailViewModelFactory(): ViewModelFactory<EventDetailViewModel>
    fun homeViewModelFactory(): ViewModelFactory<HomeViewModel>
    fun adminViewModelFactory(): ViewModelFactory<AdminViewModel>
    fun mainViewModelFactory(): ViewModelFactory<MainViewModel>

    fun inject(application: CuHackingApplication)

}