% N is the resolution of the spherical grid
% landmarksPhi and landmarksTheta are the spherical coordimsates of the landmarks

[Theta, Phi] = getSphericalGrid(N);
th = Theta(1, :);
phi= Phi(:, 1)';

% Phi index  (Row index in Sebastian's convention)
I0 = floor(landmarksPhi / phi(2))+1; 

% Theta index  (column index in Sebastian's convention)
J0 = floor( landmarksTheta / th(2))+1; 

[Xs,Ys,Zs] = sphere(40);
scale      = 0.015;
figure(32), clf;
surface(squeeze(M(:, :, 1)), squeeze(M(:, :, 2)), squeeze(M(:, :, 3))); 
axis equal; cameramenu;
hold on;
for k=1:length(J0),
   
    i = I0(k);
    j = J0(k);
    X = squeeze(M(i, j, :) );           %  
    
    surf(Xs*scale + X(1), Ys*scale+X(2), Zs*scale+ X(3),'CData',repmat(k, size(Xs)));
        
end



    