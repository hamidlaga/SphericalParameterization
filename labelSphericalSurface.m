% Uses matlab's built-in kdtree search (R15)
%
%

function L  = labelSphericalSurface(M, shape, faceLabels)

[n, m, ~] = size(M);
L         = zeros(n, m);

nvert  = size(shape.V, 2);
nfaces = size(shape.Tri, 2);

% the center of each face
C = (shape.V(:, shape.Tri(1, :)) + shape.V(:, shape.Tri(2, :)) + shape.V(:, shape.Tri(3, :))) / 3;

% size(C)
% pause
% make a kdtree with C
tree = KDTreeSearcher(C'); % kdtree_build(C');

% IdxNN = knnsearch(tree,Q,'K',2)

P = reshape(M, [n*m, 3]);
Ix = knnsearch(tree, P,'K', 1);
Lx = faceLabels(Ix);

L = reshape(Lx, [n, m]);
% 
% for i=1:n,
%     for j=1:m
%         p = squeeze(M(i, j, :));
%         
%         ix = knnsearch(tree, p(:)','K', 1); % kdtree_nearest_neighbor(tree, p(:)');
%         
%         L(i, j) = faceLabels(ix);
%     end
% end

% kdtree_delete(tree);