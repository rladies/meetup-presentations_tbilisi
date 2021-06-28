################## კოვიდ-19 ის მონაცემთა ბაზის მანიპულაცია, ანალიზი, ვიზუალიზაცია და ანიმაცია. 


#დავაინსტალიროთ ყველა საჭირო პაკეტი -->  ggplot2; gganimate; dplyr; gifski; png, coronavirus
#devtools::install_github("RamiKrispin/coronavirus") NB: install devtools too, if u dont have it! 
 
install.packages(c("ggplot2", "gganimate", "dplyr", "gifski", "png"))



#ჩავტვირთოთ ყველა საჭირო პაკეტი 
library(ggplot2)
library(gganimate)
library(dplyr)
library(gifski)
library(png)
library(coronavirus)


# დავააფდეითოთ კორონავირუსის პაკეტი 
update_dataset()

# შევამოწმოთ როდის განახლდა ბოლოს მონაცემთა ბაზა 

coronavirus %>% arrange(desc(date)) %>% View

#სტრუქტურის შემოწმება
str(coronavirus)

# თუ ამ ბაზას ვერ უკავშირდებით, ალტერნატივა1: CRAN; ალტერნატივა 2: CSV/EXEL files


#"გამოვხშიროთ" საქართველოს მონაცემები საერთო ბაზიდან, შექვმნათ ახალი დატაფრეიმი, დავათვალიეროთ.

covid_19_ge <- coronavirus %>% filter(country == "Georgia") %>% arrange(desc(date))
head(covid_19_ge, 20)
View(covid_19_ge)

# მონაცემთა მანიპულაცია: წავშალოთ ცარიელი და არაფრის მომცემი column -ები. 

covid_19_ge <-covid_19_ge %>% select(-c(province, lat, long))

covid_19_ge <-covid_19_ge %>% select(-province)

covid_19_ge <-covid_19_ge %>% select(country, type, cases)

head()


# შევქმნათ ახალი ცვლადი - შემთხვევების კუმულაციური ჯამი. # დააკვირდით: სამი ზმნა dplyr -დან!

covid_19_ge <-covid_19_ge %>% group_by(type) %>% arrange(type, date) %>% mutate(cumulative_sum = cumsum(cases))
t


#შევამოწმოთ დადასტურებული შემთხვევების ჯამური რაოდენობა as of 13.12. 20 

covid_19_ge %>% filter(type == "confirmed") %>% tail

# შევამოწმოთ გამოჯანმრთელებულების ჯამური რაოდენობა  as of 12.13. 20 

covid_19_ge %>% filter(type == "recovered") %>% tail


# შევამოწმოთ გარდაცვლილების ჯამური რაოდენობა as of 12.13. 20 

covid_19_ge %>% filter(type == "death") %>% tail


##### ვიზუალიზაცია: ნახოთ როგორია დადასტურებული, გარდაცვლილი და გამოჯანმრთელებული ქეისების დინამიკა დროში 

p1 <-ggplot(data = covid_19_ge, aes(x = date, y = cumulative_sum, group = type, color = type)) + 
        geom_line()

# როგორია ზრდის პატერნი დროში? 

p1_linear <- p1 + geom_smooth(method = "lm", se = FALSE) +  
        ylab("Cumulative confirmed cases") 

p1_linear


p1_linear +  scale_y_log10() 

# გავაკეთილშობილოთ ჩვენი ვიზუალიზაცია :) 

p1_advanced <-ggplot(data = covid_19_ge, aes(x = date, y =cumulative_sum, group = type, color = type)) + #ბაზისური ფენა
        geom_line(size = 1.8) + #შევცვალოთ ხაზის სისქე
        labs(title = "Covid-19 in Georgia", subtitle = "February, 26 - December, 13, 2020", x = "Date", 
             y = "Cumulative cases") +  #სათაური, ღერძის სახელები 
        scale_y_continuous() + #დავაზუსტოთ რა ტიპის მონაცემია განთავსებული y ღერძზე
        scale_x_date(date_labels = "%d-%b", date_breaks = "1 month")+ #დავაზუსტოთ რა ტიპის მონაცემია განთავსებული x ღერძზე და ერთთვიანი ინტერვალი მივუთითოთ
        theme_classic() + #შევუცვალოთ თემა 
        theme(legend.position = "right", plot.title = element_text(color = "red", size = 16, #შევცვალოთ ლეგენდის პოზიცია, სათაურის ფონტის ზომა, გავაბოლდოთ, ცენტრში გავიტანოთ
                                                                   face = "bold", hjust = 0.5), plot.subtitle = element_text(color = "blue", size = 12, face = "bold", hjust = 0.5)) +
        theme(axis.title.x = element_text(size=13, face="bold", colour = "blue"),
              axis.title.y = element_text(size=13, face="bold", colour = "blue"),
              axis.text.x = element_text(size=11, face="bold", colour = "black"),
              axis.text.y = element_text(size=11, face="bold", colour = "black"), 
              legend.text = element_text(siz = 11, face = "bold"),
              plot.caption = element_text(size =10, color = "black"))

p1_advanced

# შევქმნათ ანიმაცია საქართველოში არსებულ შემთხვევებზე: 



animation1 <-p1_advanced + transition_reveal(date)
animate(animation1, renderer = gifski_renderer()) 
anim_save("gif1.gif") #დავასეივოთ



# გავაუმჯობესოთ გიფი 


animate(animation1, duration = 5, fps = 20, width = 1200, height = 900, renderer = gifski_renderer())
anim_save("output.gif") 




