function [x,y,z]=spherical_to_cart_m(theta,phi,r)

if nargin < 3,
    r = ones(size(theta));
end

x = r.*sin(theta).*sin(phi);
y = r.*sin(theta).*cos(phi);
z = r.*cos(theta);

