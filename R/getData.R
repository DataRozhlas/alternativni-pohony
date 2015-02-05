library(xlsx)
library(XML)
library(tidyr)
library(dplyr)

# načti a vyčisti data o počtu registrovaných vozidel podle pohonu

vozidla <- read.csv("../data/registrovana-vozidla.csv")
vozidla <- vozidla %>%
        mutate(datum = as.Date(paste(rok, mesic, "15", sep="-"))) %>%
        select(datum, benzin, diesel, cng, lpg, e85, elektro, hybrid, ostatní)
vozidla <- vozidla %>%
        gather(palivo, prodano, benzin:ostatní)


# jen alternativní pohony

alternativni <- read.csv("../data/registrovana-vozidla.csv")
alternativni <- alternativni %>%
        mutate(datum = as.Date(paste(rok, mesic, "15", sep="-"))) %>%
        select(datum, cng, lpg, e85, elektro, hybrid)
alternativni <- alternativni %>%
        gather(palivo, prodano, cng:hybrid)


# načti a vyčisti data o cenách pohonných hmot
ccs <- readHTMLTable("../data/ccs.html")[[1]]
ccs <- ccs[ , c(1, 2, 4)]
ccs$Datum <- as.Date(as.character(ccs$Datum), format="%d.%m.%Y")
names(ccs) <- c("datum", "benzin", "diesel")
ccs$benzin <- as.numeric(as.character(ccs$benzin))
ccs$diesel <- as.numeric(as.character(ccs$diesel))


ccs <- ccs %>%
        gather(palivo, cena, benzin:diesel)


# podíl na trhu
trh <- read.csv("../data/registrovana-vozidla.csv")
trh <- trh %>%
        mutate(datum = as.Date(paste(rok, mesic, "15", sep="-"))) %>%
        select(datum, benzin, diesel, cng, lpg, e85, elektro, hybrid, ostatní)

trh[is.na(as.matrix(trh))] <- 0

options(scipen = 999)

trh <- trh %>%
        mutate(celkem = benzin + diesel + cng + lpg + e85 + elektro + hybrid + ostatní) %>%
        mutate(benzin = benzin / celkem * 100) %>%
        mutate(diesel = diesel / celkem * 100) %>%
        mutate(cng = cng / celkem * 100) %>%
        mutate(lpg = lpg / celkem * 100) %>%
        mutate(e85 = e85 / celkem * 100) %>%
        mutate(elektro = elektro / celkem * 100) %>%
        mutate(hybrid = hybrid / celkem * 100) %>%
        mutate(ostatní = ostatní / celkem * 100) %>%
        select(datum, hybrid, elektro, e85, lpg, cng, `ostatní`, diesel, benzin)

trh <- trh %>%
        gather(palivo, podil, benzin:hybrid)

