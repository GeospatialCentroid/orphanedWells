/*
grap yearly primary productivity values from modis for various geographic areas 
20211220
carverd@colostate.edu
*/

//USA
var USAarea = ee.Geometry.Polygon(
  [
    [-122.1363, 45.00121],
    [-122.1363, 24.85552],
    [-92.59328,24.85552],
    [-92.59328, 45.00121],
    [-122.1363, 45.00121],
  ]
  );

//AUS 
var AUSarea = ee.Geometry.Polygon(
  [
    [113.75,-39.25],
    [113.75,-11.75],
    [154.25,-11.75],
    [154.25,-39.25],
    [113.75,-39.25]
    ])

Map.addLayer(AUSarea, {}, 'aoi');

var modis = ee.ImageCollection("MODIS/006/MOD17A3HGF")
  .select("Npp")
  .toBands()
  .clip(AUSarea)
      // Request the data at the scale and projection of the MODIS image.
    .reproject({
      crs: 'EPSG:4326',
      scale: 500
    });

print(modis)

// Vis parameters 




Map.addLayer(modis.select("2000_02_18_Npp"), imageVisParam,"500" )


// ****** Aggregation to 27.75km ****** //
 
var projection = modis.projection()
print(projection)
print('Native Resolution:', projection.nominalScale()) 
 
// Get the projection at required scale
var modis1k = projection.atScale(1000)
var modis10k = projection.atScale(10000)
var modis27K = projection.atScale(27500)
 
// Step1: 500 to 1000m
var scaledImage1 = modis
  .reduceResolution({
    reducer: ee.Reducer.mean(),
    maxPixels: 1024
  })
  // Request the data at the scale and projection
  // of reduced resolution
  .reproject({
    crs: modis1k
  });
Map.addLayer(scaledImage1.select("2000_02_18_Npp"))

// Step2: 1000m to 10000m
var scaledImage2 = scaledImage1
  .reduceResolution({
    reducer: ee.Reducer.mean(),
    maxPixels: 1024
  })
  // Request the data at the scale and projection
  // of reduced resolution
  .reproject({
    crs: modis10k
  });
Map.addLayer(scaledImage2.select("2000_02_18_Npp"), imageVisParam , "10000")

  
// Step2: 1000m to 10000m
var scaledImage3 = scaledImage2
  .reduceResolution({
    reducer: ee.Reducer.mean(),
    maxPixels: 1024
  })
  // Request the data at the scale and projection
  // of reduced resolution
  .reproject({
    crs: modis27K
  });
Map.addLayer(scaledImage3.select("2000_02_18_Npp"), imageVisParam , "27000")

// Export the image, specifying scale and region.
Export.image.toDrive({
  image: scaledImage2,
  description: 'imageToDriveExample',
  scale: 27000,
  region: AUSarea
});