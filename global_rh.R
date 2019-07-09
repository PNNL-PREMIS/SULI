# global_rh.R

# Read the Hashimoto (2015) dataset

library(ncdf4)

# Open the file and print its variables and dimensions
nc <- nc_open("RH_yr_Hashimoto2015.nc")
print(nc)

# Load the data we need
rh <- ncvar_get(nc, "co2")
cellarea <- ncvar_get(nc, "area_cellarea")
years <- 1901 + ncvar_get(nc, "time")

# TODO: print the dimensions and structure of these data
# TODO: use image() to make a quick plot of the first year's data

# Function that computed the global flux, which is area-weighted sum
# of all grid cells
globalflux <- function(gridded_fluxes, cell_areas) {
  # TODO
}

# Set up our results data frame
results <- data.frame(year = years, global_rh = NA_real_)

for(yr in years) {
  # TODO - call globalflux() above with each 'slice' of rh
}

# Plot the results!
library(ggplot2)
p <- ggplot(results, aes(year, global_rh)) + geom_line()
print(p)
