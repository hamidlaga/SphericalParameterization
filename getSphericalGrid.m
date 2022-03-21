%
% Makes a spherical grid in theta and phi coordinates
% Theta: 0 to \pi
% Phi:   0 to 2\pi
%
function  [Theta, Phi] = getSphericalGrid(N)

theta = pi*[0:N]/N;
Theta = repmat(theta,N+1,1);

phi = 2*pi*[0:N]/(N);
Phi = repmat(phi',1, N+1);
