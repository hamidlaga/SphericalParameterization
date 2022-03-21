function [theta,phi,r] = cartesian_to_sph_m(x,y,z)
%
% same as cartesian_to_sph but takes as input a matrix
%
r = sqrt(x.^2 + y.^2 + z.^2);
theta = acos(z ./ r);
phi   = atan2(x./r, y./r);

% Now make sure that phi is in [0, 2pi]
[I1,I2]=find(phi<0);

for j=1:length(I1)
    phi(I1(j),I2(j))=phi(I1(j),I2(j))+2*pi;
end
