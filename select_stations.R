
setwd("D:/TEMP")
install.packages("readxl")
library("readxl")
install.packages("plotly")
library("plotly")
install.packages("colorspace")
library("colorspace")
install.packages("plyr")
library('plyr')
install.packages("stringi")
library("stringi")
install.packages("ggplot2")
library("ggplot2")
install.packages("ggplot")
library("dplyr")
install.packages("dplyr")
library("ggplus")
install.packages("ggplus")
devtools::install_github("guiastrennec/ggplus")

library("tibble")
library("readxl")
library("plotly")
library("colorspace")
library('plyr')
library("stringi")
library("ggplot2")
library("tribble")
setwd("D:/TEMP")


dat <- read.csv("codz.csv", header = FALSE)

#remove rows with no information about temperature
remove_empty_temp <-dat[!(dat$V9==99.9),]

#remove rows which were measured before 1981
remove_date <- remove_empty_temp[!(remove_empty_temp$V4<1981),]

#write.csv(remove_empty_temp, "remove_empty_temp.csv")

stations <- readxl::read_xls("stacje_bezelekt.xls")

stations <- stations[,-(12:17)]
names(stations)[names(stations) == 'POSTERUNEK'] <- 'V2'

# join tables according to the station
select <- merge(stations, remove_date, by="V2")
select_1 <- select[,-(5:12)]

#change names of columns
names(select_1)[names(select_1) == 'V2'] <- 'POSTERUNEK'
names(select_1)[names(select_1) == 'V3'] <- 'ID RZEKA'
names(select_1)[names(select_1) == 'V4'] <- 'ROK_HYDRO'
names(select_1)[names(select_1) == 'V5'] <- 'MONTH RH'
names(select_1)[names(select_1) == 'V6'] <- 'DZIEN'
names(select_1)[names(select_1) == 'V7'] <- 'STAN WODY'
names(select_1)[names(select_1) == 'V8'] <- 'PRZEPŁYW'
names(select_1)[names(select_1) == 'V9'] <- 'TEMP'
names(select_1)[names(select_1) == 'V10'] <- 'MONTH_CALEND'

write.csv(select_1, "select_station.csv")

#sortuj wg. nazwy (alfabetycznie) i roku , miesięcy i dni (rosnaco)
with_sort <- select_1 [ order(select_1[ , 1], select_1[ ,6], select_1[ ,12], select_1[ ,8] ),]

with_sort$date <- as.Date(with(with_sort, paste(with_sort$DZIEN, with_sort$MONTH_CALEND, with_sort$ROK_HYDRO,sep="-")), "%d-%m-%Y")

#######

#good
# wszystkie na 1
p5 <- ggplot2::ggplot(with_sort, ggplot2::aes(x = date, y = TEMP))
p5 + ggplot2::geom_line(ggplot2::aes(color = POSTERUNEK))
# kazdy wykres oddzielnie
(p5 <- p5 + ggplot2::geom_line() +
    ggplot2::facet_wrap(~POSTERUNEK, ncol=2, nrow=2))
####### DZIAŁA OUTPUTY NA WIELU STRONACH I W LANDSCAPE = paper="a4r"

# wszystkie na 1
p5 <- ggplot2::ggplot(with_sort, ggplot2::aes(x = date, y = TEMP))
p5 + ggplot2::geom_line(ggplot2::aes(color = POSTERUNEK))
# kazdy wykres oddzielnie
(p5 <- p5 + ggplot2::geom_line()+ 
    ggplot2::facet_grid(~POSTERUNEK))
#alterations to the theme and looks
p6 <- p5+ggplot2::theme_linedraw()+ 
    ggplot2::labs(x="date of measurement", y="water temperature *C", title = "Water temperature measured at gauging stations ", subtitle = NULL)+ 
  theme(plot.title = element_text(hjust = 0.5))
p7 <- p6+mtext("Magic function", side=3)


pdf('multiple_page_plot2.pdf', paper="a4r", width = 12, height = 11)
ggplus::facet_multiple(plot = p6, 
               facets = "POSTERUNEK" , 
               ncol = 1, 
               nrow = 1)

dev.off()

#dodac zaczac wszystkie wykresy od tego samego roku, dodac nazwe rzeki


