library(tidyverse)
forestfires <- read.csv("forestfires.csv")

# Applying 'factors' to order the columns 'day' and 'month'
forestfires <- forestfires %>%
       mutate(month = factor(month, # Recreate a column with the same name and with 'levels' we indicate de order of the elements (months)
                      levels = c("jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec")))

forestfires <- forestfires %>%
     mutate(day = factor(day, levels = c("mon", "tue", "wed", "thu", "fri", "sat", "sun")))


# Grouping the values by day or month to after be able to create the plots
fires_by_month <- forestfires %>%
            group_by(month) %>%
            count()

fires_by_day <- forestfires %>%
        group_by(day) %>%
        count()



# Creating the plots

fires_by_month %>%
      ggplot(aes(x = month, y = n)) +
      geom_col()

fires_by_day %>%
       ggplot(aes(x = day, y = n)) +
        geom_col()



# Creating different plots with the same variables
# First is necessary to 'pivoter' the columns to create the dependent variables in each plot
forestfires_long <- forestfires %>%
        pivot_longer(
                cols = c(FFMC, DMC, DC, ISI, temp, RH, wind, rain, area),
                         names_to = "column",
                         values_to = "values"
                     )



# Code to generate multiples plots (facet_wrap). In this case is necessary to establish
# scales = "free_y" so each plot has its owns y's values separately.

forestfires_long %>%
            ggplot(aes(x = month, y = values)) +
            geom_col() + 
            facet_wrap(vars(column), scales = "free_y")

# Exploring a different variable (area) to analyse the gravity of the fires.
# In this case area is the dependent variable (y) and values will assume the x axis
# As before, I established the scale as "free_x" so each plot has it's own values
# In this code I also filter the values of area, to better visualize, and as well I deleted the "rain" rows from
# the "columns" column.

forestfires_area <- forestfires %>%
            pivot_longer(
                 cols = c(FFMC, DMC, DC, ISI, temp, RH, wind, rain),
                 names_to = "columns",
                 values_to = "values"
             )



forestfires_area %>%
             filter(area >= 0.5 & area <= 3 & columns != "rain") %>%
             ggplot(aes(x = values, y = area)) +
             geom_col() +
             facet_wrap(vars(columns), scales = "free_x")
