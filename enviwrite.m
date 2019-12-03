function enviwrite(D,datafile,info,hdrfile)
%enviread: Read binary image files using ENVI header information
%[D,x,info,y]=enviread(datafile) where the header file is named
%filename.hdr and exists in the same directory. Otherwise use
%[D,x,info,y]=enviread(datafile,hdrfile) The output contains D, x, info and
%y containing the images data, header info, x-coordinate vector and
%y-coordinate vector, respectively. D will be in whatever number format
%(double, int, etc.) as in the ENVI file.
if nargin < 2
    error('You must specify at least two inputs')
elseif nargin < 3
    [a,b,c] = size(D);
    D = double(D);
    info = struct('samples', b, 'lines', a, 'bands', c, 'byte_order', 0, 'header_offset', 0,...
        'file_type', 'ENVI Standard','interleave', 'bsq', 'data_type', 5);
    hdrfile=[deblank(datafile),'.hdr']; %implicit name
elseif nargin < 4
    hdrfile=[deblank(datafile),'.hdr']; %implicit name
end

envihdrwrite(hdrfile, info);
envidatawrite(D,datafile,info);


