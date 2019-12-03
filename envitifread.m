function [D, info] = envitifread(datafile)


[D, ~]=geotiffread(datafile);
infoTmp = geotiffinfo(datafile);

params=fieldnames(infoTmp);
info = [];
info.map_info = [];
info.file_type = 'GeoTif';  %
info.header_offset = 0;
info.sensor_type = 'Unknown';
info.byte_order = 0;

switch class(D)
    case 'uint8'
        info.data_type = 1;
    case 'int16'
        info.data_type= 2;
    case 'int32'
        info.data_type= 3;
    case 'float'
        info.data_type= 4;
    case 'double'
        info.data_type= 5;
%     case 'COMPLEX'
%         iscx=true;
%         info.data_type= 6;
%     case 'COMPLEX'
%         iscx=true;
%         info.data_type= 9;
    case 'uint16'
        info.data_type= 12;
    case 'uint32'
        info.data_type= 13;
    case 'int64'
        info.data_type= 14;
    case 'uint64'
        info.data_type= 15;
    otherwise
        error(['File type number: ',num2str(dtype),' not supported']);
end

info.interleave = 'bsq';
for idx=1:length(params)
    param = params{idx};
    value = getfield(infoTmp,param);

    if strcmp(param,'Width')
        info.samples = value;
    elseif strcmp(param,'Height')
        info.lines = value;
    elseif strcmp(param,'BitDepth')
        info.bands = value;
    elseif strcmp(param,'Ellipsoid')
        info.map_info.datum = strrep(value, ' ', '-');
        GCS_datum = ['GCS' '_' strrep(value, ' ', '_')];
        D_datum = ['D' '_' strrep(value, ' ', '_')];
    elseif strcmp(param,'Projection')
        if contains(value,'UTM')
            proj = strrep(value, ' ', '_');
            info.map_info.projection = 'UTM';
            info.map_info.image_coords = [1.000 1.000];
            info.map_info.zone = strtrim(value(10:end-1));
            proj2 = strtrim(value(end));
            if strcmp(proj2,'N')
                info.map_info.hemi = 'North';
            elseif strcmp(proj2,'S')
                info.map_info.hemi = 'South';
            end
        end
    elseif strcmp(param,'PM')
        PM = value;
    elseif strcmp(param,'UOMLength')
        if strcmp(value,'metre')
            info.map_info.units = 'Meters';
        end
    elseif strcmp(param,'BoundingBox')
        info.map_info.mapx = value(1,1);
        info.map_info.mapy = value(2,2);
    elseif strcmp(param,'PixelScale')
        info.map_info.dx = value(1);
        info.map_info.dy = value(2);
    end
end

