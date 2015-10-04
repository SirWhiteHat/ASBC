classdef dspTypeIirYuleWalk < dspType
    properties
        nDim = 2;
        name = 'iiryw'
    end
    
    methods
        function obj = dspTypeIirYuleWalk(n)
            obj = obj@dspType(n);
        end
        
        function dim = dimensionSize(self,n)
            switch n
                case 1
                    dim = 2;
                case 2
                    dim = self.n;
            end
        end
        
        function filt = renderFilter(self, f, mag)
            [b,a] = yulewalk(self.n, f, mag);
            filt.B = b(1:end)';
            filt.A = a(1:end)';
        end
    end
end