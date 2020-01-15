//
//  MapViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-06-28.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MGLMapViewDelegate {
    // MARK: Instance Variables
    private var viewModel: MapViewModel?

    private var mapView: MGLMapView!
    private let tableViewCellWidth = 50
    private let tableViewCellHeight = 50
   
    private var lineLayers: [String: MGLLineStyleLayer] = [:]
    private var fillLayers: [String: MGLFillStyleLayer] = [:]
    private var backdropLayers: [String: MGLFillStyleLayer] = [:]
    private var backdropLineLayers: [String: MGLLineStyleLayer] = [:]
    private var symbolLayers: [String: MGLSymbolStyleLayer] = [:]
    private var floorPickerHeightAnchor: NSLayoutConstraint!
    
    var closestBuilding: Building?

    private var floorPickerTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        tableView.layer.cornerRadius = 10
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  Asset.Colors.background.color
        
        MapViewModel.create { [weak self] (mapViewModel, error) in
            guard let self = self else {
                return
            }
            if error != nil {
                print(error?.localizedDescription)
            }
            self.viewModel = mapViewModel
            DispatchQueue.main.async {
                self.setupMap()
                self.setupFloorPicker()
            }
        }
    }

    // MARK: Setup Methods
    private func setupMap() {
        let url = traitCollection.userInterfaceStyle == .light ? MGLStyle.lightStyleURL :  MGLStyle.darkStyleURL

        mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.delegate = self
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 45.382667477255127, longitude: -75.69630255230739), zoomLevel: 18, animated: false)
        view.addSubview(mapView)
    }
    
    /// Sets up the levels of the specified building by adding it to the map
    /// - Parameter building: The building to be added to the map
    private func setupLevels(forBuilding building: Building) {
        guard let style = self.mapView.style else { return }

        let source = building.shapeSource
        style.addSource(source)

        let backdropLayer = MGLFillStyleLayer(identifier: "\(building.name)-backdrop-layer", source: source)
        backdropLayer.fillColor = NSExpression(forConstantValue: Asset.Colors.backdrop.color)

        let backdropLineLayer = MGLLineStyleLayer(identifier: "\(building.name)-backdrop-line-layer", source: source)
        backdropLineLayer.lineWidth = NSExpression(forConstantValue: 5)
        backdropLineLayer.lineColor = NSExpression(forConstantValue: Asset.Colors.line.color)

        let lineLayer = MGLLineStyleLayer(identifier: "\(building.name)-line-layer", source: source)
        lineLayer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",[18: 0, 19: 3])
        lineLayer.lineColor = NSExpression(forConstantValue: Asset.Colors.line.color)
        let fillLayer = MGLFillStyleLayer(identifier: "\(building.name)-fill-layer", source: source)
        let defaultFill = Asset.Colors.default.color
        fillLayer.fillColor = NSExpression(format: building.fillFormat,
                                           Asset.Colors.room.color,
                                           Asset.Colors.washroom.color,
                                           Asset.Colors.elevator.color,
                                           Asset.Colors.hallway.color,
                                           Asset.Colors.stairs.color,
                                           defaultFill)

        let symbolLayer = MGLSymbolStyleLayer(identifier: "\(building.name)-symbol-layer", source: source)
        symbolLayer.iconImageName = NSExpression(format: building.symbolIconFormat, "washroom", "elevator", "stairs", "")
        symbolLayer.minimumZoomLevel = 19
        symbolLayer.iconScale = NSExpression(forConstantValue: 0.2)
        symbolLayer.text = NSExpression(forKeyPath: "name")
        symbolLayer.textTranslation = NSExpression(forConstantValue: NSValue(cgVector: CGVector(dx: 0, dy: 22)))
        symbolLayer.textFontSize = NSExpression(forConstantValue: 16)

        style.addLayer(backdropLayer)
        style.addLayer(backdropLineLayer)
        style.addLayer(fillLayer)
        style.addLayer(symbolLayer)
        style.addLayer(lineLayer)

        backdropLayers[building.name] = backdropLayer
        backdropLineLayers[building.name] = backdropLineLayer
        fillLayers[building.name] = fillLayer
        symbolLayers[building.name] = symbolLayer
        lineLayers[building.name] = lineLayer
        updatePredicates(forBuilding: building)
    }
    
    
    /// Updates the predicates of the specified building. Predicates are what are used to filter out the map data (eg. Show a certain floor of the building)
    /// - Parameter building: The building to be updated
    private func updatePredicates(forBuilding building: Building) {
        backdropLayers[building.name]?.predicate = building.backdropPredicate
        backdropLineLayers[building.name]?.predicate = building.backdropLinePredicate
        lineLayers[building.name]?.predicate = building.linePredicate
        fillLayers[building.name]?.predicate = building.floorPredicate
        symbolLayers[building.name]?.predicate = building.symbolPredicate
    }
    private func setupFloorPicker() {
        floorPickerTableView.delegate = self
        floorPickerTableView.dataSource = self
        floorPickerTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(floorPickerTableView)
        NSLayoutConstraint.activate([
            floorPickerTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            floorPickerTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            floorPickerTableView.widthAnchor.constraint(equalToConstant: 45)
        ])
        var height = tableViewCellHeight
        if let closestBuilding = closestBuilding {
            height = tableViewCellHeight*closestBuilding.floors.count
        }
        floorPickerHeightAnchor = floorPickerTableView.heightAnchor.constraint(equalToConstant: CGFloat(height))
        floorPickerHeightAnchor.isActive = true
    }

    /// Calculates which building is closest to the specified point
    /// - Parameter point: the target point
    private func closestBuilding(toPoint point: CLLocation) -> Building? {
        guard let buildings = viewModel?.buildings,
            let firstBuilding = buildings.first else {
            return nil
        }
        var shortestDistance = point.distance(from: firstBuilding.center)
        var closestBuilding = firstBuilding
        buildings.forEach { (building) in
            let distance = point.distance(from: building.center)
            if distance < shortestDistance {
                shortestDistance = distance
                closestBuilding = building
            }
        }
        return closestBuilding
    }

    // MARK: MGLMapViewDelegate Methods
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        //Adding the images to the mapView to make them accessible in the map.
        mapView.style?.setImage(Asset.Images.washroom.image, forName: "washroom")
        mapView.style?.setImage(Asset.Images.elevator.image, forName: "elevator")
        mapView.style?.setImage(Asset.Images.stairs.image, forName: "stairs")
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        guard let viewModel = self.viewModel else {
            return
        }
        viewModel.buildings.forEach { (building) in
            setupLevels(forBuilding: building)
        }
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        //Finds which building the user is closest too and updates the floor picker to match that building
        let centerPoint = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        if let newClosestBuilding = closestBuilding(toPoint: centerPoint),
        newClosestBuilding.name != closestBuilding?.name {
            self.closestBuilding = newClosestBuilding
            floorPickerTableView.reloadData()
            viewModel?.buildings.forEach({ (building) in
                building.currentFloor = building.floors.first
                updatePredicates(forBuilding: building)
            })
        }
    }
    
    // MARK: TableViewDelegate & TableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let closestBuilding = closestBuilding else {
            return 0
        }
        floorPickerHeightAnchor.constant = CGFloat(tableViewCellHeight*closestBuilding.floors.count)
        return closestBuilding.floors.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(tableViewCellHeight)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let closestBuilding = closestBuilding else {
            return
        }
        closestBuilding.currentFloor = closestBuilding.floors[closestBuilding.floors.count - 1 - indexPath.row]
        updatePredicates(forBuilding: closestBuilding)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let closestBuilding = closestBuilding, indexPath.row == closestBuilding.floors.count-1 {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let closestBuilding = closestBuilding else {
            return UITableViewCell()
        }
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(closestBuilding.floors[closestBuilding.floors.count - 1 - indexPath.row].name)"
        cell.textLabel?.textAlignment = .center
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor =  Asset.Colors.purple.color
        cell.selectedBackgroundView = selectedBackgroundView
        return cell
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if mapView == nil, viewModel == nil {
            return
        }
        if #available(iOS 13.0, *) {
            // UIScreen was used here because using the ViewController's traitCollection caused inconsistent behaviour.
            // It would sometimes return light value when the user was in dark mode and vice-versa.
            if UIScreen.main.traitCollection.userInterfaceStyle == previousTraitCollection?.userInterfaceStyle {
                return
            }
            let url = UIScreen.main.traitCollection.userInterfaceStyle == .light ? MGLStyle.lightStyleURL :  MGLStyle.darkStyleURL

            guard let currentLayers = mapView.style?.layers, let viewModel = viewModel else { return }
            currentLayers.forEach { (layer) in
                guard let mapStyle = mapView.style else { return }
                if let styleLayer = mapStyle.layer(withIdentifier: layer.identifier) {
                     mapStyle.removeLayer(styleLayer)
                 }
            }
            viewModel.buildings.forEach { (building) in
                if let source = mapView.style?.source(withIdentifier: building.shapeSource.identifier) {
                    mapView.style?.removeSource(source)
                }
            }
            mapView.styleURL = url
        }
    }
}
