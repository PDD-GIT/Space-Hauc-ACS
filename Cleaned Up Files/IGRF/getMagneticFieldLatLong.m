function mag = getMagneticFieldLatLong(latitude, longitude)
    mag = igrf(now, latitude, longitude, 350);
end