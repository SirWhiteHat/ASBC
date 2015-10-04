classdef dspTypeFir < dspType
    properties
        nDim = 1;
        name = 'fir'
    end
    
    methods
        function obj = dspTypeFir(n)
            obj = obj@dspType(n);
        end
        
        function dim = dimensionSize(self,n)
            dim = self.n;
        end
        
        function filt = renderFilter(self, f, mag)
            % return exact size filter
            filt.coeffs = [fir2(self.n-2, f, mag) zeros(1-mod(self.n,2),1)]';
        end
    end
end