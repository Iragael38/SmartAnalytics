# ACROISER AVEC    https://rpubs.com/sarah_salazar/434797 
 

library(rUnemploymentData)

data(df_state_unemployment)

head(df_state_unemployment)
boxplot(df_state_unemployment[, -1],
        main="USA State Unemployment Data",
        xlab="Year", 
        ylab="Percent Unemployment")





**************
  
  
  How to make a compelling map,
in a few dozen lines of code

The code to create this map is surprisingly brief.

#==============
# LOAD PACKAGES
#==============

library(ggplot2)
library(viridis)

#==========
# LOAD DATA
#==========

url.unemploy_map <- url("http://sharpsightlabs.com/wp-content/datasets/unemployment_map_data_2016_nov.RData")

load(url.unemploy_map)

#===========
# CREATE MAP
#===========

ggplot() +
  geom_polygon(data = map.county_unemp, aes(x = long, y = lat, group = group, fill = unemployed_rate)) +
  geom_polygon(data = map.states, aes(x = long, y = lat, group = group), color = "#EEEEEE", fill = NA, size = .3) +
  coord_map("albers", lat0 = 30, lat1 = 40) +
  labs(title = "United States unemployment rate, by county" , subtitle = "November, 2016") +
  labs(fill = "% unemployed") +
  scale_fill_viridis() +
  theme(text = element_text(family = "Gill Sans", color = "#444444")
        ,plot.title = element_text(size = 30)
        ,plot.subtitle = element_text(size = 20)
        ,axis.text = element_blank()
        ,axis.title = element_blank()
        ,axis.ticks = element_blank()
        ,panel.grid = element_blank()
        ,legend.position = c(.9,.4)
        ,legend.title = element_text(size = 16)
        ,legend.background = element_blank()
        ,panel.background = element_blank()
  )


Now, I will admit that there was a fair amount of data manipulation that made this map possible. I’ve provided the dataset to you (you can access it and use it immediately), so you don’t have to do the hard work of gathering, wrangling, and shaping this data in order to create this map.

Nevertheless, once you have the dataset ready, the final code to create the map is only about 20 lines. Once again (and for the record) this is why I love ggplot2. ggplot2 gives you the tools to create compelling data visualizations with relative ease and simplicity.

A few other things to note:
  This is a cousin of the heatmap

This type of map is called a choropleth map. The chloropleth is sort of a cousin of the heatmap. The primary difference is that to create the heatmap in ggplot2, we use geom_tile(), whereas to create this choropleth map, we use geom_polygon(). In either case though, we’re plotting shapes, and shading those shapes in proportion to some metric. Syntactically, in ggplot2, we shade those regions by mapping a variable to the fill = aesthetic.

Having said that, there are clear differences as well. Getting the polygon data for the counties and manipulating the data into shape is much harder for a choropleth than for a typical heatmap. Getting data for heatmaps is typically much easier.

Having said that, I recommend that if you want to learn to make a map like this, start with the heatmap first. Once again, I’m recommending that you learn the basics first, because basic techniques serve as a foundation for more complicated ones.

If you start with the heatmap, you’ll get some practice with a few critical skills. Namely, you’ll be able to practice working with different color palettes. To create compelling heatmaps (and choropleths), you’ll need to know how to use colors to create the right visual effect.

Learning the heatmap will also give you ggplot syntax practice, and show you how to map variables to the fill = aesthetic.
We built this plot in layers

In many of my recent blog posts, I’ve emphasized “layering” as an essential principle of data visualization.

In this visualization, it’s subtle, but the layering principle is still at work.

There are two primary layers here. Go through the code and see if you can identify them.

Next, as an exercise, try removing the “state” layer and see what happens. Why is it useful to have? Also, notice that the states are only outlines (i.e., they aren’t filled in …). Why did I do that, and how did I accomplish it? Leave your answers to these in the comments below …
Maps aren’t good for making precise comparisons

I’ll admit that I quite like maps. As a data scientist, they’re fun to make. They’re compelling and beautiful to look at (if you execute them well).

But a map like this has limitations.

The big limitation is that when data is encoded as color (as we’ve done in this map) humans aren’t good at making precise distinctions between values. For example, if you live in the US, try identifying your home county. Can you tell the exact unemployment rate? Probably not. Moreover, try to compare one county vs another. You’ll quickly realize that you can make general statements like “county X has higher unemployment than county Y,” but you won’t be able to make precise statements on the basis of this map alone.

Another exercise: What visualization technique could you use if you wanted to make precise distinctions? (Leave your answer in the comments below.)
80% of this is just formatting

If you’re a beginner with ggplot2, the code might look a little complex.

It’s actually much simpler than it seems at first glance.

About 80% of the code for the finalized chart is just formatting code. 80% just deals with things like the font formatting, the legend position, the text colors, etc.

We can actually strip away a lot of that formatting code and still create a functional map.

Here’s a stripped down version:
  
  ggplot() +
  geom_polygon(data = map.county_unemp, aes(x = long, y = lat, group = group, fill = unemployed_rate))

We can strip the map down to two lines of code. Two lines of code are the core. Two lines of code do the “heavy lifting” to create the map … the rest is just formatting.

So, the good news is that if you want to begin making maps like these, you can get started quickly by learning only a couple lines of code.