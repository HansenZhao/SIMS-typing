classdef SIMSDataAssem < handle
    
    properties (SetAccess = private)
        mz;
        dataMat;
    end
    
     properties (Dependent)
        nMS;       
        imageSize;
        sumRes;
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
        
        function r = get.sumRes(obj)
            r = zeros(obj.imageSize);
            if ~isempty(obj.dataMat)
                for m = 1:obj.nMS
                    r = r + obj.dataMat{m};
                end
            end
        end
        
        function addFiles(obj,mzCheck)
            if ~exist('mzCheck','var')
                mzCheck = 1;
            end
            fp = uigetdir();
            [fn,fp] = listFile('*.txt',fp);
            L = length(fn);
            for m = 1:L
                obj.addFile(fp{m},fn{m},mzCheck);
                if mod(m,100) == 0
                    fprintf(1,'%d/%d\n',m,L);
                end
            end
        end
        
        function addFile(obj,fp,fn,mzCheck)
            if ~exist('mzCheck','var')
                mzCheck = 1;
            end
            if nargin == 1
                sd = SIMSTxtData();
            else
                sd = SIMSTxtData(fp,fn);
            end
            
            if sd.mz < 0 && mzCheck
                return;
            end
            
            if isempty(obj.dataMat)
                obj.dataMat{1} = sd.rawMat;
                obj.mz = sd.mz;
            elseif sd.imageSize == obj.imageSize
                obj.dataMat{end+1} = sd.rawMat;
                obj.mz(end+1) = sd.mz;
            end
            obj.sortMS();
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
        
        function [t,cellPos] = toSC(obj,refMask,method)
            if size(refMask,1) ~= obj.imageSize
                disp('inconsistence image size');
                return;
            end
            ids = unique(refMask);
            L = length(ids);
            if ~exist('method','var')
                method = 'mean';
            end
            pixelVolume = zeros(L,1);
            meanX = zeros(L,1);
            meanY = zeros(L,1);
            cellPos = cell(L,1);
            data = zeros(L,obj.nMS);
            switch method
                case 'mean'
                    hfunc = @(x,I)mean(x(I));
                case 'max'
                    hfunc = @(x,I)max(x(I));
            end
            for m = 1:1:L
                pixelVolume(m) = sum(refMask(:) == ids(m));
                tmp = refMask==ids(m);
                [X,Y] = find(tmp);
                meanX(m) = mean(X);
                meanY(m) = mean(Y);
%                 cellPos{m} = imoverlay(obj.sumRes/max(obj.sumRes(:)),bwperim(tmp),[1,0,0]);
                cellPos{m} = imoverlay(obj.sumRes/max(obj.sumRes(:)),tmp,[1,0,0]);
                for n = 1:obj.nMS               
                    data(m,n) = hfunc(obj.dataMat{n},tmp);
                end
            end
            t = table(ids,pixelVolume,meanX,meanY,data);
        end
    end
    
end

