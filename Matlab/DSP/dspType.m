classdef dspType
    %dspType Template DSP type from which to inherit.
    %   Represents requirements for a DSP method. Template is FIR.
    
    properties (Access = protected)
        n
    end
    
    methods
        function obj = dspType(n)
            obj.n = n;
        end
        
        function obj = getFilter(self, f, dbmag, fs)
            [mag,f] = self.prepareFilter(f, dbmag, fs);
            obj = self.renderFilter(f,mag);
        end
    
        function [ mag, f ] = prepareFilter(~, f, dbmag, fs)
            % Add a zero point
            dbmag = [dbmag(1), dbmag];
            f = [0, f];

            % Normalise frequency values within 0-1, based on fs
            fScale = 1/max(f)*(max(f)/fs)*2;
            f = f.*fScale;

            % Add final point
            dbmag = [dbmag, dbmag(end)];
            f = [f, 1];

            % Convert dB to magnitude response
            mag = db2mag(dbmag);
        end
        
        function dim = nDimensions(self)
            dim = self.nDim;
        end
        
        function obj = label(self)
            obj = [upper(self.name(1)) lower(self.name(2:end)) num2str(self.n)];
        end
    end
    
    properties(Abstract)
        nDim
        name
    end
    
    methods(Abstract)
        dimensionSize(n);
        renderFilter(f,mag);
    end
end