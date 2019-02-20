install.packages("stringr")
install.packages("xlsx")
install.packages("rJava")

library("stringr")
library("xlsx")
library("rJava")


setwd("D:/TEMP/R")

df = read.csv("mapa_zawartosci_T_edit.csv", header = TRUE)
df[,"total_1951_1960"] <- NA
df$total_1951_1960 <-str_count(df$X1951.1960, "T")

df[,"total_1961_1970"] <- NA
df$total_1961_1970 <-str_count(df$X1961.1970, "T")

df[,"total_1971_1980"] <- NA
df$total_1971_1980 <-str_count(df$X1971.1980, "T")

df[,"total_1981_1990"] <- NA
df$total_1981_1990 <-str_count(df$X1981.1990, "T")

df[,"total_1991_2000"] <- NA
df$total_1991_2000 <-str_count(df$X1991.2000, "T")

df$total_2001_2010 <-str_count(df$X2001.2010, "T")

#ograniczenie danych z kolumny do 2015 pomijajac 2016
df$X2011.2020 <- substr(df$X2011.2020, 0, 5)

df$total_2011_2020 <-str_count(df$X2011.2020, "T")

df$total_1951_2015 <- rowSums(df[, c(11:17)])

write.table(df, "total_data_stacje.txt", sep="\t")
write.csv(df,"total_data_stacje.csv" )
