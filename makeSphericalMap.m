function [M, fIdx] = makeSphericalMap(S, sphS, N)
%
% N - resolution of the spherical map (the final map will be of res. N x N
% S - the mesh
% sphS - vertices of S embedded on the sphere
% Ix - landmark indices
%
%
% Output: 
% M -   (N+1) x (N+1) x 3  (\phi \times \theta)  (compatible with Sebastian's convention)
%  \phi: 0 to 2\pi
%  \theta: 0 to \pi
%
% fIdx - of size (N+1)\times (N+1), which gives for each point on the
% sphere its corresponding face on the mesh
%%

% %%
% 2. Create a spherical grid
if nargin < 3,
    N = 128;
end

[Theta, Phi] = getSphericalGrid(N);
N = size(Theta, 1); 
[X, Y, Z] = spherical_to_cart(Theta, Phi, 1); %radius 1

%%
% 3. Compute the parameterization
% 3.1. Intersect the rays (X, Y, Z) with the spherical mesh
%      The output should be the triangle + barycentric coords of the intersection point 
% Let fIdx the indices of the intersection faces
%     BCC the bcc coords

option=[]; 
option.triangle = 'one sided'; 
option.ray      = 'ray';
option.border   = 'normal';

V1 = sphS.V(:, sphS.Tri(1, :))';
V2 = sphS.V(:, sphS.Tri(2, :))';
V3 = sphS.V(:, sphS.Tri(3, :))';

fIdx = zeros(size(X)); % zeros(numel(X), 1);
BCC  = zeros(size(X, 1), size(X, 2), 3); % zeros(numel(X), 3);

nFaces  = size(V1, 1);

M = zeros(N, N, 3);

for i=1:size(X, 1), %numel(X),
   % disp(i);
   for j=1:size(X, 2),
       % v0 = [X(i) Y(i) Z(i)]; 
        v0 = -[X(i, j) Y(i, j) Z(i, j)];        % for some reason I need to use -1 here (maybe becasue of the orientation of the normals)

       [intersect  t u v] = TriangleRayIntersection( zeros(nFaces, 3), repmat(v0, nFaces, 1), V1, V2, V3, option);

       ix = find(intersect > 0); 
       if numel(ix) == 1,       
          fIdx(i, j) = ix(1);
          BCC(i,j, :) = [(1-u(ix(1))-v(ix(1))) u(ix(1)) v(ix(1)) ];
       else
          %numel(ix)
    %       intersect
    %       pause
          fIdx(i, j) = 1;

       end
       
       % set P and M
       M(i, j, :) = BCC(i, j, 1) * S.V(:, S.Tri(1, fIdx(i, j)) ) +  ...
                    BCC(i, j, 2) * S.V(:, S.Tri(2, fIdx(i, j)) ) +  ...
                    BCC(i, j, 3) * S.V(:, S.Tri(3, fIdx(i, j)) );
       M(i, j, :) = M(i, j, :) / sum(BCC(i, j, :), 3);
      
    end
end



