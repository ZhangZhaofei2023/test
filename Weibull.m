clc
clear

file01=fopen('D:\工作学习\项目\时域长短期预报问题\NLStaPredict-初步可用版本1\x_F.dat','r');

point_num=fscanf(file01,'%d',[1,1]);
x=fscanf(file01,'%f',[point_num,1]);
F=fscanf(file01,'%f',[point_num,1]);

fclose(file01);

N=point_num-1;

%Eq.(6)
for i=1:N
    Y(i,1)=log(-log(1-F(i,1)));
    X(i,1)=log(x(i,1));
end

sum_X=sum(X(1:N,1));
sum_Y=sum(Y(1:N,1));
sum_XX=sum(X(1:N,1).^2);
sum_YY=sum(Y(1:N,1).^2);
sum_XY=sum(X(1:N,1).*Y(1:N,1));
X_avg=sum_X/N;
Y_avg=sum_Y/N;

%Eq.(9)
beta=(N*sum_XY-sum_X*sum_Y)/(N*sum_XX-sum_X^2);
a=Y_avg-beta*X_avg;
%Eq.(10)
yita=exp(-a/beta);

%Eq.(11)
I_XY=sum((X(1:N,1)-X_avg).*(Y(1:N,1)-Y_avg));
I_XX=sum((X(1:N,1)-X_avg).^2);
beta2=I_XY/I_XX;
a2=Y_avg-beta2*X_avg;
yita2=exp(-a/beta2);

error1=abs(beta-beta2)/beta;
error2=abs(yita-yita2)/yita;

dx=200;
for i=1:1000
    x(i,1)=dx*i;
    F_F(i,1)=1-exp(-(x(i,1)/yita)^beta);
    f_f(i,1)=(beta/yita)*(x(i,1)/yita)^(beta-1)*exp(-(x(i,1)/yita)^beta);
end

square_error=sum_YY-a*sum_Y-beta*sum_XY;
square_error2=sum_YY-a2*sum_Y-beta2*sum_XY;

subplot(1, 2, 1);
plot(x(:,1), F_F(:,1));             
xlabel('pressure(Pa)');             
ylabel('F(x)');             
title('y = F(x)');     
grid on;                

subplot(1, 2, 2);      
plot(x(:,1), f_f(:,1));
xlabel('pressure(Pa)');             
ylabel('f(x)');             
title('y = f(x)');
grid on; 