function  Ix = findVertexOrder(originalMesh, pm_off_Mesh)
% For each vertex in pm_off_mesh, finds its closest on originalMesh
%

n = size(pm_off_Mesh.V, 2);        % number of vertices

m = size(originalMesh.V, 2);

V = originalMesh.V;
Ix = zeros(1, n);

for i=1:n,
    
   disp(i);
   D = zeros(1, m);
   
   p = pm_off_Mesh.V(:, i);
   
   D = sum((V - repmat(p, 1, m)).^2, 1);
   
   [~, Ix(i)] = min(D);
   
end
