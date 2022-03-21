function Shape3D = loadoff(filename)

obj_file = fopen(filename);
tmp      = fread(obj_file, 3);
s        = fscanf(obj_file, '%d', [3 1]);

%now read the vertices
Shape3D.V = fscanf(obj_file, '%f', [3 s(1)]);

%now read the faces
VV = fscanf(obj_file, '%d', [4 s(2)]);
Shape3D.Tri = VV(2:4, :) + 1;


%close the file
fclose(obj_file);
