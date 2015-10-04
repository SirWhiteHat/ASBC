% Modified from http://www.mathworks.co.uk/help/matlab/ref/flipud.html

%****ALSO modified to only use three points across centre. n fixed at 3.

function [ Px Py ] = applyBezierSmoothing( x, y, centre, width )
% Requires coordinates as X/Y matrix    
in = zeros(2,3); %codegen

in(1,:) = [x(centre-width/2) x(centre) x(centre+width/2)];
in(2,:) = [y(centre-width/2) y(centre) y(centre+width/2)];
% p = rot90(rot90(rot90(p)));
p = rot90(in);

n = size(p);
n = n(1);
n1 = n(1)-1;

sigma = zeros(1,n1+1);%codegen

for    i=0:1:n1
    sigma(i+1)=factorial(n1)/(factorial(i)*factorial(n1-i));    
end

UB=zeros(1,n); %codegen
l = zeros(500,3); %codegen
lcount = 0; %codegen

for u=0:0.002:1
    lcount = lcount + 1; %codegen
    
    for d=1:n
        UB(d)=sigma(d)*((1-u)^(n-d))*(u^(d-1));
    end
    
    l(lcount,:) = UB; %codegen
end

P=l*p;

xStart = x(1:(centre-(width/2)-1),1);
xFinish = x((centre+(width/2)+1):end,1);

yStart = y(1,1:(centre-(width/2)-1));
yFinish = y(1,(centre+(width/2)+1):end);

xMid = flipud(P(:,1));
yMid = rot90(flipud(P(:,2)));

Px = [xStart ; xMid ; xFinish];
Py = [yStart yMid yFinish];
end