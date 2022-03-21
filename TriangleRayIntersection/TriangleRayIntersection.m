function [intersect, t, u, v] = TriangleRayIntersection (orig, dir, vert0, vert1, vert2, options)
% Ray/triangle intersection using the algorithm proposed by Möller and 
% Trumbore (1997), implemented as highly vectorized MATLAB code.
%
% Algorithm:
%  Function solves
%        |t|
%    M * |u| = (o-v0)
%        |v|
%  for [t; u; v] where M = [-d, v1-v0, v2-v0]. u,v are barycentric coordinates
%  and t - the distance from the ray origin in |d| units
%  ray/triangle intersect if u>=0, v>=0 and u+v<=1
%
% Note:
%  The algorithm is able to solve several types of problems:
%  * many faces / single ray  intersection
%  * one  face  / many   rays intersection
%  * one  face  / one    ray  intersection
%  * many faces / many   rays intersection
%  In order to allow that to happen all imput arrays are expected in Nx3 
%  format, where N is number of vertices or rays. In most cases number of
%  vertices is different than number of rays, so one of the imputs will 
%  have to be cloned to have the right size. Use "repmat(A,size(B,1),1)".
%
% Input (all arrays in in Nx3 format, where N is number of vertices or rays):
%  * orig : ray's origin    
%  * dir  : ray's direction
%  * vert0, vert1, vert2: vertices of the triangle
%  * options: aditional customization options
%    * options.triangle - 'one sided' or 'two sided' (default) - how to treat
%        triangles. In 'one sided' version only intersections in single
%        direction are counted and intersections with back facing
%           tringles are ignored 
%    * options.ray - 'ray' (default) or 'segment' - how to treat ray as an
%        infinite line (ray) or as line segment defined by a vector
%    * option.border - controls border handling. If 'normal'(default) 
%        border points are included, but can be easily lost due to 
%        rounding errors. If option.border='inclusive' borders points are 
%        included, with a margin of option.eps. If option.border='exclusive' 
%        borders points are excluded, with margin of option.eps.
%    * options.epsilon (default = 1e-5)
%
% Output:
%   * Intersect - boolean array of length N
%   * t   - distance from the ray origin to the intersection point in |dir|
%   * u,v - barycentric coordinates of the intersection point units    
%
% Based on:
%  *"Fast, minimum storage ray-triangle intersection". Tomas Möller and 
%    Ben Trumbore. Journal of Graphics Tools, 2(1):21--28, 1997. 
%    http://www.graphics.cornell.edu/pubs/1997/MT97.pdf
%  * http://fileadmin.cs.lth.se/cs/Personal/Tomas_Akenine-Moller/raytri/
%  * http://fileadmin.cs.lth.se/cs/Personal/Tomas_Akenine-Moller/raytri/raytri.c
%
% Author:
%    Jarek Tuszynski (jaroslaw.w.tuszynski@saic.com)
%
% License: BSD license (http://en.wikipedia.org/wiki/BSD_licenses)

%% verify that inputs are in correct format
if (size(orig ,1)==3 && size(orig ,2)~=3), orig =orig' ; end
if (size(dir  ,1)==3 && size(dir  ,2)~=3), dir  =dir'  ; end
if (size(vert0,1)==3 && size(vert0,2)~=3), vert0=vert0'; end
if (size(vert1,1)==3 && size(vert1,2)~=3), vert1=vert1'; end
if (size(vert2,1)==3 && size(vert2,2)~=3), vert2=vert2'; end
if (any(size(orig)~=size(vert0)) || ...
    any(size(orig)~=size(vert1)) || ...
    any(size(orig)~=size(vert2)) || ...
    any(size(orig)~=size(dir  )) )
  error('All input vectors have to be of the same size.');
end
if (size(orig,2)~=3)
  error('All input vectors have to be in Nx3 format.');
end

%% Read options
eps      = 1e-5;
triangle = 'two sided';
ray      = 'ray';
border   = 'normal';
if (nargin>5)
  if (isfield(options, 'eps'     )), eps      = options.eps;      end
  if (isfield(options, 'triangle')), triangle = options.triangle; end
  if (isfield(options, 'ray'     )), ray      = options.ray;      end
  if (isfield(options, 'border'  )), border   = options.border;   end
end
eps = abs(eps); % sanity check

%% initialize default output
intersect = false(size(orig,1),1);
t = zeros(size(orig,1),1); u=t; v=t;

%% Find faces parallel to the ray
edge1 = vert1-vert0;          % find vectors for two edges sharing vert0
edge2 = vert2-vert0;
tvec  = orig -vert0;          % distance from vert0 to ray origin
pvec  = cross(dir, edge2,2);  % begin calculating determinant - also used to calculate U parameter
det   = sum(edge1.*pvec,2);   % determinant of the matrix M = dot(edge1,pvec)
parallel = (abs(det)<eps);    % if determinant is near zero then ray lies in the plane of the triangle
if all(parallel), return; end % if all parallel than no intersections
switch border
  case 'normal'
    zero=0.0;
  case 'inclusive'
    zero=eps;
  case 'exclusive'
    zero=-eps;
end

%% Different behavior depending on one or two sided triangles
if strcmpi(triangle,'two sided'),          % treats triangles as two sided
  det(parallel) = 1;                       % change to avoid division by zero
  u  = sum(tvec.*pvec,2)./det;             % calculate U parameter used to test bounds
  ok = (~parallel & u>=-zero & u<=1.0+zero);% mask which allows performing next 2 operations only when needed
  if ~any(ok), return; end                 % if all ray/plane intersections are outside the triangle than no intersections 
  qvec = cross(tvec(ok,:), edge1(ok,:),2); % prepare to test V parameter
  v(ok,:) = sum(dir(ok,:).*qvec,2) ./ det(ok,:);  % calculate V parameter used to test bounds
  intersect = (v>=-zero & u+v<=1.0+zero & ok);  
  if (nargout==1 && strcmpi(ray,'ray')), return; end
  t(ok,:) = sum(edge2(ok,:).*qvec,2)./det(ok,:);
  if (strcmpi(ray,'ray')), return; end
  intersect = (intersect & t>=-zero & t<=1.0+zero);
else % treats triangles as one sided
  u = sum(tvec.*pvec,2);                   % calculate U parameter used to test bounds
  ok = (det>eps & u>=0.0 & u<=det);        % mask which allows performing next 2 operations only when needed
  if ~any(ok), return; end                 % if all ray/plane intersections are outside the triangle than no intersections        
  qvec = cross(tvec(ok,:), edge1(ok,:),2); % prepare to test V parameter
  v(ok,:) = sum(dir(ok,:).*qvec,2);        % calculate V parameter used to test bounds
  intersect = (det>eps & u>=-zero & v>=-zero & u+v<=det*(1+zero));
  if (nargout==1 && strcmpi(ray,'ray')), return; end
  t(ok,:)  = sum(edge2(ok,:).*qvec,2);     
  inv_det = zeros(size(det));
  inv_det(ok,:) = 1./det(ok,:);
  t = t.*inv_det;  % calculate t - distance from origin to the intersection in |d| units
  u = u.*inv_det;
  v = v.*inv_det;
  if (strcmpi(ray,'ray')), return; end
  intersect = (intersect & t>=-zero & t<=1.0+zero); % intersection between origin and destination
end
