function [ option ] = genDefaultSteveOption()
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
    option = struct;
    option.is_CLAHE = 1;
    option.H = 0.05;
    option.Object_is_Closing = 1;
    option.Object_Closing_Radius = 3;
    option.Object_is_Filling = 1;
    option.Border_thres = 0.65;
    option.Border_is_Opening = 1;
    option.Border_Open_Radius = 3;
    option.Border_is_Eleminating = 1;
    option.Border_Eleminating = 10;   
    option.Border_is_Filling = 1;
    option.is_Semiauto = 0;
end

