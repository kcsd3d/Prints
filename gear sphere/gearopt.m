clear all
close all
clc

n1=12;
n2=6;

dc=1;
gamma=2*atan(1/sqrt(2));
r2=dc/sqrt(2);
for i=1:1000
    r1=dc*sin(gamma-asin(r2/dc));
    r2=n2/n1*r1;
    if abs(gamma-asin(r2/dc)-asin(r1/dc))<.00001
        break
    end
end
r1
r2