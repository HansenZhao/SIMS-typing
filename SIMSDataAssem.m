classdef SIMSDataAssem < handle
    
    properties (SetAccess = private)
        mz;
        dataMat;
    end
    
     properties (Dependent)
        nMS;       
        imageSize;
    end
    
    methods
        function obj = SIMSDataAssem()
            obj.mz = [];
            obj.dataMat = [];
        end
        
        function n = get.nMS(obj)
            n = length(obj.dataMat);
        end
        
        function n = get.imageSize(obj)
            try
                n = size(obj.dataMat{1},1);
            catch
                n = 0;
            end
        end
        
        function addFile(obj,fp,fn)
            if nargin == 1
                sd = SIMSTxtData();
            else
                sd = SIMSTxtData(fp,fn);
            end
            
            if sd.mz < 0
                return;
            end
            
            if isempty(obj.dataMat)
                obj.dataMat{1} = sd.rawMat;
                obj.mz = sd.mz;
            elseif sd.imageSize == obj.imageSize
                obj.dataMat{end+1} = sd.rawMat;
                obj.mz(end+1) = sd.mz;
            end
        end
        
        function sortMS(obj)
            [obj.mz,I] = sort(obj.mz);
            obj.dataMat = obj.dataMat(I);
        end
        
        function [mz,intens] = getMSByIndex(obj,L)
            mz = obj.mz;
            intens = zeros(obj.nMS,1);
            for m = 1:1:obj.nMS
                intens(m) = mean(obj.dataMat{m}(L));
            end
        end
    end
    
end

