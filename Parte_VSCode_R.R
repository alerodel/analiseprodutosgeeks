
##### Teste BIX #####
getwd()
search()

# importando e lendo as bibliotecas
#install.packages("ggplot2")
#install.packages("tidyverse")
#install.packages("tidyr")
#install.packages("readr")
#install.packages("lattice")
#install.packages("readxl")

library(tidyverse)
library(lattice)
library(tidyr)
library(ggplot2)
library(readr)
library(readxl)

excel_sheets("BasedeDadosBix.xlsx")

TabelaVenda <- read_excel("BasedeDadosBix.xlsx", sheet = "Venda")
View(TabelaVenda)

TabelaProduto <- read_excel("BasedeDadosBix.xlsx", sheet = "Produto")

TabelaConsumidores <- read_excel("BasedeDadosBix.xlsx", sheet = "Consumidores")

TabelaLojas <- read_excel("BasedeDadosBix.xlsx", sheet = "Lojas")

View(TabelaConsumidores)
View(TabelaLojas)
View(TabelaProduto)

str(TabelaVenda)
str(TabelaConsumidores)
str(TabelaLojas)
str(TabelaProduto)

#summarizando os dados
summary(TabelaVenda)
summary(TabelaConsumidores)
summary(TabelaLojas)
summary(TabelaProduto)

# manipulando dados com o "dplyr"
#install.packages("dplyr")
library(dplyr)

##### Salvando cada aba da planilha em .csv #####
write.csv(TabelaVenda, "D:/Documents/UNIVERSIDADE/CURSOS_APERFEICOAMENTO/DATA_SCIENCE/Testes_Empresas/Bix/Dados/Vendas.csv")
write.csv(TabelaConsumidores, "D:/Documents/UNIVERSIDADE/CURSOS_APERFEICOAMENTO/DATA_SCIENCE/Testes_Empresas/Bix/Dados/Consumidores.csv")
write.csv(TabelaProduto, "D:/Documents/UNIVERSIDADE/CURSOS_APERFEICOAMENTO/DATA_SCIENCE/Testes_Empresas/Bix/Dados/Produtos.csv")
write.csv(TabelaLojas, "D:/Documents/UNIVERSIDADE/CURSOS_APERFEICOAMENTO/DATA_SCIENCE/Testes_Empresas/Bix/Dados/Lojas.csv")


################## Minhas perguntas ##################
# 1 - Qual é a loja com mais vendas no geral
# 2 - Qual é o nome do produto mais vendido no geral
# 3 - Qual é o nome do produto mais vendido na loja com maior venda
# 4 - Qual é o tamnaho do produto mais vendido
# 5 - Qual é o estado com maior venda
# 6 - Qual é o cliente que mais comprou e onde mora
# 7 - Qual é o sexo que mais compra produtos
# 8 - O que cada sexo mais gosta de comprar
# 9 - Qual é o total de unidades vendidas por sexo

TabelaVenda['Total'] <- (TabelaVenda$Quantity*TabelaVenda$UnitPrice - (TabelaVenda$Quantity*TabelaVenda$UnitPrice*TabelaVenda$Discount))
view(TabelaVenda)

separate(TabelaVenda, Date, c('year', 'month', 'day'), sep = "-",remove = FALSE)

View(TabelaVenda %>%
  group_by(year = 2019,
           month = 04) %>%
  summarise(MediaMensal = mean(Total),
            median(Total),
            sqrt(Total)))

 ##############################################################################
 ### Rascunhos

View(TabelaVenda %>%
  group_by(ProductID) %>%
  select(Quantity = 1, ProductID))

View(TabelaVenda %>%
  group_by(ProductID) %>%
  summarise(QuantityMax = max(Quantity),
            Total = n()))

View(TabelaConsumidores %>% 
  group_by(ID = "002ec297b1b00fb9dde7ee6ac24b67713", Name) %>%
  summarise(Total = n()))

a <- select(TabelaConsumidores, ID) %>%
  group_by(TabelaConsumidores, Name = "Iron Man", Size = "G")

View(a[1])

b <- TabelaVenda %>%
  select(ProductID, Quantity, Date) %>%
  arrange(Date) %>%
  group_by(ProductID = c(a[1]))

#Usando o pacote "Tidyr"
install.packages("Tidyr")
library(tidyr)
tabela1 <- TabelaVenda %>%
  mutate(ValorLiquido = Quantity * (UnitPrice - UnitPrice*Discount)) #%>%

tabela2 <- tabela1 %>%  
  separate(Date, into = c("Year", "Month", "Day"), sep = "\\-") %>%
  group_by(ProductID = c(a[1]), StoreID, Year = '2019')

barplot(tabela2$StoreID, tabela2$Quantity)

