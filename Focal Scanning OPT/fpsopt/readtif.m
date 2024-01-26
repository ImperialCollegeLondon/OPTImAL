function im = readtif(filename)

fileinfo = imfinfo(filename);

rows = fileinfo(1).Height;
cols = fileinfo(1).Width;
frms = length(fileinfo);

im = zeros(rows,cols,frms);
for i = 1:frms
    im(:,:,i) = imread(filename,i);
end