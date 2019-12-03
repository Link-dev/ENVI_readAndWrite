function envihdrwrite(hdrfile, info)
% ENVIHDRWRITE read and return ENVI image file header information.
%   INFO = ENVIHDRWRITE(info,'HDR_FILE') writes the ENVI header file
%   'HDR_FILE'. Parameter values are provided by the fields of structure
%   info.
%
%   Example:
%   >> info = envihdrread('my_envi_image.hdr')
%   info =
%          description: [1x101 char]
%              samples: 658
%                lines: 749
%                bands: 3
%        header_offset: 0
%            file_type: 'ENVI Standard'
%            data_type: 4
%           interleave: 'bsq'
%          sensor_type: 'Unknown'
%           byte_order: 0
%             map_info: [1x1 struct]
%      projection_info: [1x102 char]
%     wavelength_units: 'Unknown'
%           pixel_size: [1x1 struct]
%           band_names: [1x154 char]
%     info = enviwrite('my_envi_image2.hdr');
%
% Felix Totir

%if there is not info for image, just save it's basic parameter

params=fieldnames(info);

fid = fopen(hdrfile,'w');
fprintf(fid,'%s\n','ENVI');

for idx=1:length(params)
    param = params{idx};
    value = getfield(info,param);
    param(findstr(param,'_')) = ' '; %automatic name
    
    %
    if isnumeric(value)
        line=[param,' = ',num2str(value)];
    elseif isfield(value, 'projection')
        fprintf(fid, 'map info = {');
        fprintf(fid, '%s, ', value.projection);
        if isfield(value, 'image_coords')
            fprintf(fid, '%f, ', value.image_coords(1));
            fprintf(fid, '%f, ', value.image_coords(2));
        end
        if isfield(value, 'mapx')
            fprintf(fid, '%f, ', value.mapx);
        end
        if isfield(value, 'mapy')
            fprintf(fid, '%f, ', value.mapy);
        end
        if isfield(value, 'dx')
            fprintf(fid, '%f, ', value.dx);
        end
        if isfield(value, 'dy')
            fprintf(fid, '%f, ', value.dy);
        end
        if isfield(value, 'zone')
            fprintf(fid, '%d, ', value.zone);
        end
        if isfield(value, 'hemi')
            fprintf(fid, '%s, ', value.hemi);
        end
        if isfield(value, 'datum')
            fprintf(fid, '%s, ', value.datum);
        end
        if isfield(value, 'units')
            fprintf(fid, 'units = %s', value.units);
        end
        fprintf(fid, '}\n');
        continue;
    elseif isfield(value, 'x')
        fprintf(fid, 'pixel size = {');
        fprintf(fid, '%f, ', value.x);
        if isfield(value, 'y')
            fprintf(fid, '%f, ', value.y);
        end
        if isfield(value, 'units')
            fprintf(fid, 'units = %s', value.units);
        end
        fprintf(fid, '}\n');
    elseif strcmp(param, 'coordinate system')
        continue;
    else
        line=[param,' = ',value];
    end
        
    fprintf(fid,'%s\n',line);
    
end

fclose(fid);

