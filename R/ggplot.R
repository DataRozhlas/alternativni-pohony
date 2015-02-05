library("ggplot2")

# cena PHM

ggplot(ccs, aes(x=datum, y=cena)) + geom_line(aes(colour=palivo)) + xlab(label = "") + ylab(label = "cena v korunách za litr") + ggtitle("Průměrná cena pohonných hmot (zdroj: CCS)") + scale_colour_brewer(type="qual", palette = 6)

# prodaná auta - pohon

ggplot(vozidla, aes(x=datum, y=prodano)) + geom_line(aes(colour=palivo)) + xlab(label = "") + ylab(label = "prodaných kusů") + ggtitle("Nově registrovaná auta podle paliva (zdroj: SDA)") + scale_colour_brewer(type="qual", palette = 6)

# podíl pohonů na trhu

ggplot(trh, aes(x = datum, y = podil)) + geom_area(aes(colour = palivo, fill = palivo), position = 'stack') + scale_colour_brewer(type="qual", palette = 6) + scale_fill_brewer(type="qual", palette = 6) + xlab("") + ylab("podíl na trhu v procentech")
# alternativní, bar chart

ggplot(alternativni, aes(x=datum, y=prodano, fill = palivo)) + geom_bar(stat = "identity") + xlab(label = "") + ylab(label = "prodaných kusů") + ggtitle("Nově registrovaná auta, jen alternativní paliva bez \"ostatních\" (zdroj: SDA)") + scale_fill_brewer(type="qual", palette = 6)
