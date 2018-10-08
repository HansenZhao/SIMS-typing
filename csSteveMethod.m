function [ L,cellNum,cellBorder,mat_raw,mat_pri,mat_border,mat_mod, priObject ] = csSteveMethod( I,varargin )
    %ref:https://blogs.mathworks.com/steve/2006/06/02/cell-segmentation/
    % posted by Steve Eddins
    % options:
    % H (default 0.05)
    % is_CLAHE (default 1)
    % Object_Closing_Radius (default 3)
    % Object_is_Closing (default true)
    % Object_is_Filling (default true)
    % Border_thres (default 0.65)
    % Border_Open_Radius (default 3)
    % Border_Eleminating (default 10)
    % Border_is_Filling (default true);
    % Border_is_Opening (default true)
    % Border_is_Eleminating (default true)
    % is_Simiauto (default false)
    
    if nargin == 1
        options = genDefaultSteveOption;
    else
        options = varargin{1};
        if ~isfield(options,'H')
            options.H = 0.05;
        end
        if ~isfield(options,'is_CLAHE')
            options.is_CLAHE = 1;
        end
        if ~isfield(options,'Object_Closing_Radius')
            options.Object_Closing_Radius = 3;
        end
        if ~isfield(options,'Object_is_Closing')
            options.Object_is_Closing = 1;
        end
        if ~isfield(options,'Object_is_Filling')
            options.Object_is_Filling = 1;
        end
        if ~isfield(options,'Border_thres')
            options.Border_thres = 0.65;
        end
        if ~isfield(options,'Border_Open_Radius')
            options.Border_Open_Radius = 3;
        end
        if ~isfield(options,'Border_Eleminating')
            options.Border_Eleminating = 10;
        end
        if ~isfield(options,'Border_is_Opening')
            options.Border_is_Opening = 1;
        end
        if ~isfield(options,'Border_is_Eleminating')
            options.Border_is_Eleminating = 1;
        end
        if ~isfield(options,'Border_is_Filling')
            options.Border_is_Filling = 1;
        end
        
        if ~isfield(options,'is_Semiauto')
            options.is_Semiauto = 0;
        end
    end
    
    mat_raw = I./max(I(:));
    if options.is_CLAHE
        mat_raw = adapthisteq(mat_raw);
    end
    
    if options.is_Semiauto
        priObject = varargin{2};
    else
        priObject = imextendedmax(mat_raw,options.H);
        if options.Object_is_Closing
            priObject = imclose(priObject,ones(options.Object_Closing_Radius));
        end
        if options.Object_is_Filling
            priObject = imfill(priObject,'holes');
        end
    end
    priObject = bwareaopen(priObject,30);
    priObject = imclearborder(priObject,4);
    mat_pri = imoverlay(mat_raw,priObject,[1,.3,.3]);
    
    borderObject = imbinarize(mat_raw,options.Border_thres);
    if options.Border_is_Filling
        borderObject = imfill(borderObject,'holes');
    end
    if options.Border_is_Opening
        borderObject = imopen(borderObject,ones(options.Border_Open_Radius));
    end
    if options.Border_is_Eleminating
        borderObject = bwareaopen(borderObject,options.Border_Eleminating);
    end
    
    mat_border = imoverlay(mat_raw,borderObject,[1,.3,.3]);
    
    mat_mod = imimposemin(imcomplement(mat_raw),~borderObject|priObject);
    
    %mat_mod = mat_mod | ~borderObject;
    
    L = watershed(mat_mod);
    cellNum = max(L(:)) - 1; % 0 border, 1 background
    cellBorder = L==0;
end

