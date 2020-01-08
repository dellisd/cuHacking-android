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

package com.cuhacking.app.map.ui

import android.content.res.Configuration
import android.graphics.BitmapFactory
import android.graphics.Color
import android.graphics.RectF
import android.os.Bundle
import android.view.LayoutInflater
import android.view.MenuItem
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.lifecycle.Observer
import androidx.navigation.fragment.findNavController
import com.cuhacking.app.BuildConfig
import com.cuhacking.app.R
import com.cuhacking.app.data.api.models.FloorData
import com.cuhacking.app.data.map.Floor
import com.cuhacking.app.di.injector
import com.cuhacking.app.ui.PageFragment
import com.google.android.material.appbar.MaterialToolbar
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.button.MaterialButtonToggleGroup
import com.google.android.material.card.MaterialCardView
import com.mapbox.mapboxsdk.Mapbox
import com.mapbox.mapboxsdk.camera.CameraPosition
import com.mapbox.mapboxsdk.geometry.LatLng
import com.mapbox.mapboxsdk.geometry.LatLngBounds
import com.mapbox.mapboxsdk.maps.MapView
import com.mapbox.mapboxsdk.maps.MapboxMap
import com.mapbox.mapboxsdk.maps.Style
import com.mapbox.mapboxsdk.style.expressions.Expression.*
import com.mapbox.mapboxsdk.style.layers.FillLayer
import com.mapbox.mapboxsdk.style.layers.LineLayer
import com.mapbox.mapboxsdk.style.layers.PropertyFactory.*
import com.mapbox.mapboxsdk.style.layers.SymbolLayer
import com.mapbox.mapboxsdk.style.sources.GeoJsonSource

class MapFragment : PageFragment(R.layout.map_fragment) {

    companion object {
        fun newInstance() = MapFragment()
    }

    private val viewModel: MapViewModel by viewModels { injector.mapViewModelFactory() }
    private var map: MapboxMap? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Mapbox.getInstance(requireContext(), BuildConfig.MAPBOX_KEY)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        val mapView = view.findViewById<MapView>(R.id.map_view)
        mapView.onCreate(savedInstanceState)

        mapView.getMapAsync { mapboxMap ->
            map = mapboxMap
            val mapStyle =
                when (requireContext().resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK) {
                    Configuration.UI_MODE_NIGHT_YES -> Style.DARK
                    else -> Style.LIGHT
                }
            mapboxMap.setStyle(mapStyle) { style ->
                applyStyle(style)

                viewModel.buildings.observe(this, Observer { buildings ->
                    buildings.forEach { building ->
                        loadBuilding(style, building)
                    }
                })

                viewModel.selectedFloor.observe(this, Observer { map ->
                    map.entries.forEach { (building, floor) ->
                        setLayerFilters(style, building, floor)
                    }
                })
            }

            mapboxMap.addOnMapClickListener(::handleMapClick)

            if (savedInstanceState == null) {
                map?.cameraPosition = CameraPosition.Builder()
                    .target(LatLng(45.382344, -75.696256))
                    .zoom(18.0)
                    .bearing(-125.0)
                    .build()

                mapboxMap.setLatLngBoundsForCameraTarget(
                    LatLngBounds.Builder()
                        .include(LatLng(45.39242286156869, -75.70335388183594))
                        .include(LatLng(45.379824116060036, -75.68588733673096))
                        .build()
                )
                mapboxMap.setMinZoomPreference(15.0)

                mapboxMap.uiSettings.isCompassEnabled = false
            }
        }

        view.findViewById<MaterialButtonToggleGroup>(R.id.button_toggle_group)
            .addOnButtonCheckedListener { _, checkedId, isChecked ->
                if (!isChecked) return@addOnButtonCheckedListener

//                when (checkedId) {
//                    R.id.first -> viewModel.setFloor(Floor.LV01)
//                    R.id.second -> viewModel.setFloor(Floor.LV02)
//                    R.id.third -> viewModel.setFloor(Floor.LV03)
//                }
            }

        val bottomCard = view.findViewById<MaterialCardView>(R.id.bottom_card)
        val bottomSheet = BottomSheetBehavior.from(bottomCard)
        bottomSheet.state = BottomSheetBehavior.STATE_HIDDEN

        viewModel.selectedRoom.observe(this, Observer { roomId ->
            bottomSheet.state = BottomSheetBehavior.STATE_EXPANDED
            view.findViewById<TextView>(R.id.room_name).text = roomId
        })
    }

    private fun applyStyle(style: Style) {
        style.addImage("stairs", BitmapFactory.decodeResource(resources, R.drawable.map_stairs))
        style.addImage(
            "elevator",
            BitmapFactory.decodeResource(resources, R.drawable.map_elevators)
        )
        style.addImage("male", BitmapFactory.decodeResource(resources, R.drawable.map_male))
        style.addImage("female", BitmapFactory.decodeResource(resources, R.drawable.map_female))
        style.addImage("neutral", BitmapFactory.decodeResource(resources, R.drawable.map_neutral))
        style.addImage("info", BitmapFactory.decodeResource(resources, R.drawable.map_info))
        style.addImage("fountain", BitmapFactory.decodeResource(resources, R.drawable.map_fountain))
    }

    private fun loadBuilding(style: Style, building: FloorDataUiModel) {
        style.addSource(building.source)
        val (source, prefix, floors) = building

        FillLayer(prefix, source.id).apply {
            setProperties(
                fillColor(
                    match(
                        get("room-type"), color(Color.parseColor("#545454")),
                        stop(
                            "room", switchCase(
                                eq(get("available"), true), color(Color.parseColor("#b17fe2")),
                                color(Color.parseColor("#CCCCCC"))
                            )
                        )
                        ,
                        stop("washroom", color(Color.parseColor("#ffe544"))),
                        stop("elevator", color(Color.parseColor("#ff1131"))),
                        stop("stairs", color(Color.parseColor("#008ddc"))),
                        stop("hallway", color(Color.parseColor("#FEFEFE")))
                    )
                ),
                fillOpacity(
                    interpolate(linear(), zoom(), stop(17, 0), stop(18, 1))
                )
            )
            style.addLayer(this)
        }

        FillLayer("${prefix}-backdrop", source.id).apply {
            setProperties(
                fillColor(Color.parseColor("#545454"))
            )
            style.addLayerBelow(this, prefix)
        }

        SymbolLayer("${prefix}-name", source.id).apply {
            setProperties(
                textField(get("name")),
                textColor("#FFFFFF"),
                textHaloWidth(1f),
                textHaloColor("#000000")
            )
            maxZoom = 18f
            style.addLayer(this)
        }

        LineLayer("${prefix}-lines", source.id).apply {
            setProperties(
                lineWidth(interpolate(linear(), zoom(), stop(18, 0), stop(19, 3))),
                lineColor("#212121")
            )
            style.addLayer(this)
        }

        LineLayer("${prefix}-backdrop-lines", source.id).apply {
            setProperties(
                lineWidth(5f),
                lineColor("#212121"),
                lineOpacity(interpolate(linear(), zoom(), stop(17, 0), stop(18, 1)))
            )
            style.addLayer(this)
        }

        SymbolLayer("${prefix}-symbols", source.id).apply {
            setProperties(
                textField(
                    switchCase(
                        eq(get("room-type"), "room"), get("name"), literal("")
                    )
                ),
                iconImage(
                    switchCase(
                        eq(get("room-type"), "stairs"),
                        literal("stairs"),
                        eq(get("room-type"), "elevator"),
                        literal("elevator"),
                        all(eq(get("room-type"), "washroom"), eq(get("name"), "Men's")),
                        literal("male"),
                        all(eq(get("room-type"), "washroom"), eq(get("name"), "Women's")),
                        literal("female"),
                        all(eq(get("room-type"), "washroom"), eq(get("name"), "Neutral")),
                        literal("neutral"),
                        eq(get("point-type"), "info"),
                        literal("info"),
                        eq(get("point-type"), "fountain"),
                        literal("fountain"),
                        literal("")
                    )
                ),
                iconSize(0.4f)
            )
            minZoom = 19f
            style.addLayer(this)
        }

        setLayerFilters(style, prefix, floors[0].id)
    }


    private fun setLayerFilters(style: Style, prefix: String, floorId: String) {
        // Room fills
        (style.getLayer(prefix) as FillLayer)
            .setFilter(
                all(
                    eq(get("floor"), floorId),
                    eq(get("type"), "room")
                )
            )

        // Backdrop layer
        (style.getLayer("${prefix}-backdrop") as FillLayer)
            .setFilter(all(eq(get("floor"), floorId), eq(get("type"), "backdrop")))

        // Room outlines
        (style.getLayer("${prefix}-lines") as LineLayer)
            .setFilter(all(eq(get("floor"), floorId), eq(get("type"), "line")))

        // Backdrop lines
        (style.getLayer("${prefix}-backdrop-lines") as LineLayer)
            .setFilter(all(eq(get("floor"), floorId), eq(get("type"), "backdrop-line")))

        // Labels/Icons
        (style.getLayer("${prefix}-symbols") as SymbolLayer)
            .setFilter(all(eq(get("floor"), floorId), eq(get("label"), true)))

        // Name
        (style.getLayer("${prefix}-name") as SymbolLayer)
            .setFilter(all(eq(get("floor"), floorId), eq(get("type"), "backdrop")))
    }

    private fun handleMapClick(latLng: LatLng): Boolean {
        map?.let { mapboxMap ->
            val pointF = mapboxMap.projection.toScreenLocation(latLng)
            val rectF = RectF(pointF.x - 10, pointF.y - 10, pointF.x + 10, pointF.y - 10)
            val features = mapboxMap.queryRenderedFeatures(rectF, "rb")

            if (features.size > 0) {
                if (features[0].hasNonNullValueForProperty("room")) {
                    viewModel.selectRoom(features[0].getStringProperty("room"))
                }

                return true
            }
        }

        return false
    }

    override fun onStart() {
        super.onStart()
        view?.findViewById<MapView>(R.id.map_view)?.onStart()
    }

    override fun onPause() {
        super.onPause()
        view?.findViewById<MapView>(R.id.map_view)?.onPause()
    }

    override fun onResume() {
        super.onResume()
        view?.findViewById<MapView>(R.id.map_view)?.onResume()
    }

    override fun onStop() {
        super.onStop()
        view?.findViewById<MapView>(R.id.map_view)?.onStop()
    }

    override fun onDestroyView() {
        super.onDestroyView()
        view?.findViewById<MapView>(R.id.map_view)?.onDestroy()
    }

    override fun onLowMemory() {
        super.onLowMemory()
        view?.findViewById<MapView>(R.id.map_view)?.onLowMemory()
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        view?.findViewById<MapView>(R.id.map_view)?.onSaveInstanceState(outState)
    }

}
