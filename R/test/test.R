library("Lahman");
s <- subset(Salaries, yearID==2015);
b <- subset(Batting, yearID==2015);
p <- subset(Pitching, yearID==2015);
x <- sort.list(s$salary);

x;
quan