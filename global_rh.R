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

# Close the file!
nc_close(nc)

# TODO: print the dimensions and structure of these data
# TODO: use image() to make a quick plot of the first year's data

# Function that computed the global flux, which is area-weighted sum
# of all grid cells
globalflux <- function(gridded_fluxes, cell_areas) {
  sum(gridded_fluxes * cell_areas * 1e6, na.rm = TRUE) / 1e15  # return Pg C
}

# Set up our results data frame
results <- data.frame(year = years, global_rh = NA_real_)

for(i in seq_along(years)) {
  results$global_rh[i] <- globalflux(gridded_fluxes = rh[,,i], 
                                     cell_areas = cellarea)
}

# Plot the results!
library(ggplot2)
p <- ggplot(results, aes(year, global_rh)) + geom_line()
print(p)
