function y = fun__zero(x,threshold,max_true_value,alpha)
%FUN__ZERO does
% 
% Synopsis: y = fun__zero(x,threshold,max_true_value,alpha)
% 
%

xm = x(x<=threshold);
xp = x(x>threshold);

%  y(x>threshold) = -alpha*sqrt(xp.^2 -threshold^2);
%  y(x<=threshold)= max_true_value*sqrt(1-xm.^2/threshold^2);

y(x>threshold) = -alpha*xp;
y(x<=threshold)= max_true_value;

end
