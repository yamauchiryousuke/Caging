figure
syotadata = zeros(8,3);

syotadata(:,3) = [15.5865;
17.93383333;
20.15383333;
20.5945;
21.0505;
18.98716667;
22.08066667;
18.59283333;];

for i = 1:size(syotadata(3))
    syotadata(1) = 159.39;
    syota(2) = 800-i*80;
    if i == size(syotadata(3))
       syotadata(0)=0; 
    end
end

scatter3(syotadata(:,1),syotadata(:,2),syotadata(:,3))